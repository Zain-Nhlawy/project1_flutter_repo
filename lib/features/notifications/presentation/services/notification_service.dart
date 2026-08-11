import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/notifications/data/data_sources/device_info_data_source.dart';
import 'package:project1/features/notifications/data/models/notification_payload_model.dart';
import 'package:project1/features/notifications/domain/use_case/register_fcm_token_usecase.dart';
import 'package:project1/features/notifications/presentation/services/notification_navigation_handler.dart';
import 'package:project1/main.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background FCM message: ${message.messageId}');
}

class NotificationService {
  final RegisterFcmTokenUseCase registerFcmTokenUseCase;
  final DeviceInfoDataSource deviceInfoDataSource;
  final AppSecureStorage storage;

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
  });

  Future<void> initialize() async {
    try {
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
            final payload = NotificationPayloadModel.fromJson(
              Map<String, dynamic>.from(
                Uri.splitQueryString(response.payload!),
              ),
            );
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

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final payload = NotificationPayloadModel.fromRemoteMessage(message);
      _showLocalNotification(payload);
      _showInAppBanner(payload);
    });
  }

  void _setupNotificationTapHandlers() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final payload = NotificationPayloadModel.fromRemoteMessage(message);
      NotificationNavigationHandler.handleNotificationTap(payload);
    });
  }

  Future<void> checkInitialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = NotificationPayloadModel.fromRemoteMessage(
        initialMessage,
      );
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
      payload: Uri(
        queryParameters: {
          'title': payload.title,
          'body': payload.body,
          'type': payload.type,
          ...payload.data.map((key, value) => MapEntry(key, value.toString())),
        },
      ).query,
    );
  }

  void _showInAppBanner(NotificationPayloadModel payload) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.primary, width: 1),
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
                  color: AppColors.textPrimary,
                ),
              ),
            if (payload.body.isNotEmpty)
              Text(
                payload.body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          textColor: AppColors.primary,
          onPressed: () {
            NotificationNavigationHandler.handleNotificationTap(payload);
          },
        ),
      ),
    );
  }
}
