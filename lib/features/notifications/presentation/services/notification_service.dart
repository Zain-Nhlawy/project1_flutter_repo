import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/notifications/data/data_sources/device_info_data_source.dart';
import 'package:project1/features/notifications/data/data_sources/notification_storage_service.dart';
import 'package:project1/features/notifications/data/models/notification_payload_model.dart';
import 'package:project1/features/notifications/domain/use_case/register_fcm_token_usecase.dart';
import 'package:project1/features/notifications/presentation/services/notification_navigation_handler.dart';
import 'package:project1/main.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background FCM message: ${message.messageId}');
  try {
    const storage = FlutterSecureStorage();
    final currentUserId = await storage.read(key: StorageKeys.currentUserId);
    final payload = NotificationPayloadModel.fromRemoteMessage(message);
    final targetUserId = payload.data['userId']?.toString() ??
        payload.data['targetUserId']?.toString() ??
        payload.data['recipientId']?.toString() ??
        payload.data['receiverId']?.toString() ??
        currentUserId;

    if (targetUserId != null && targetUserId.isNotEmpty) {
      final key = 'CACHED_NOTIFICATIONS_USER_$targetUserId';
      final raw = await storage.read(key: key);
      List<dynamic> list = [];
      if (raw != null && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) list = decoded;
        } catch (_) {}
      }
      list.removeWhere((item) => item is Map && item['id'] == payload.id);
      list.insert(0, payload.toJson());
      if (list.length > 100) list = list.sublist(0, 100);
      await storage.write(key: key, value: jsonEncode(list));
    }
  } catch (e) {
    debugPrint('Error caching background notification: $e');
  }
}

class NotificationService {
  final RegisterFcmTokenUseCase registerFcmTokenUseCase;
  final DeviceInfoDataSource deviceInfoDataSource;
  final AppSecureStorage storage;
  final NotificationStorageService storageService;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

  NotificationService({
    required this.registerFcmTokenUseCase,
    required this.deviceInfoDataSource,
    required this.storage,
    required this.storageService,
  });

  Future<void> initialize() async {
    try {
      await storageService.init();
      await _requestPermission();
      await _initializeLocalNotifications();
      _setupForegroundHandler();
      _setupNotificationTapHandlers();
      _setupTokenRefreshListener();

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await checkInitialMessage();
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
      'User notification permission status: ${settings.authorizationStatus}',
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final jsonMap = jsonDecode(response.payload!) as Map<String, dynamic>;
            final payload = NotificationPayloadModel.fromJson(jsonMap);
            storageService.markAsRead(payload.id);
            NotificationNavigationHandler.handleNotificationTap(payload);
          } catch (e) {
            debugPrint('Error handling local notification response: $e');
          }
        }
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> registerToken() async {
    try {
      final userToken = await storage.read(StorageKeys.token);
      if (userToken == null || userToken.isEmpty) {
        debugPrint('Skip FCM registration: User not logged in.');
        return;
      }

      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('FCM Token is null or empty.');
        return;
      }

      final deviceModel = await deviceInfoDataSource.getDeviceModel();

      final result = await registerFcmTokenUseCase(
        token: fcmToken,
        deviceModel: deviceModel,
      );

      result.fold(
        (failure) =>
            debugPrint('Failed to register FCM token: ${failure.message}'),
        (_) => debugPrint('FCM token registered successfully.'),
      );
    } catch (e) {
      debugPrint('Exception during FCM token registration: $e');
    }
  }

  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((newFcmToken) async {
      final userToken = await storage.read(StorageKeys.token);
      if (userToken != null && userToken.isNotEmpty) {
        final deviceModel = await deviceInfoDataSource.getDeviceModel();
        await registerFcmTokenUseCase(
          token: newFcmToken,
          deviceModel: deviceModel,
        );
      }
    });
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final val = await storage.read(StorageKeys.notificationsEnabled);
      return val != 'false';
    } catch (_) {
      return true;
    }
  }

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final payload = NotificationPayloadModel.fromRemoteMessage(message);
      // Cache notification
      await storageService.saveNotification(payload);

      if (!await areNotificationsEnabled()) {
        debugPrint('Foreground notification silenced: User notifications disabled.');
        return;
      }

      _showLocalNotification(payload);
      _showInAppBanner(payload);
    });
  }

  void _setupNotificationTapHandlers() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final payload = NotificationPayloadModel.fromRemoteMessage(message);
      await storageService.saveNotification(payload);
      await storageService.markAsRead(payload.id);
      NotificationNavigationHandler.handleNotificationTap(payload);
    });
  }

  Future<void> checkInitialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = NotificationPayloadModel.fromRemoteMessage(
        initialMessage,
      );
      await storageService.saveNotification(payload);
      await storageService.markAsRead(payload.id);
      NotificationNavigationHandler.handleNotificationTap(payload);
    }
  }

  void _showLocalNotification(NotificationPayloadModel payload) {
    if (payload.title.isEmpty && payload.body.isEmpty) return;

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      color: AppColors.primary,
    );

    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      payload.title,
      payload.body,
      notificationDetails,
      payload: jsonEncode(payload.toJson()),
    );
  }

  void _showInAppBanner(NotificationPayloadModel payload) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceOf(context),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: AppColors.primaryOf(context).withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (payload.title.isNotEmpty)
              Text(
                payload.title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
            if (payload.body.isNotEmpty)
              Text(
                payload.body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          textColor: AppColors.primaryOf(context),
          onPressed: () {
            storageService.markAsRead(payload.id);
            NotificationNavigationHandler.handleNotificationTap(payload);
          },
        ),
      ),
    );
  }
}
