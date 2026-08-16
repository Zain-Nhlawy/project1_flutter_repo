import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/notifications/presentation/services/notification_service.dart';
import 'package:project1/l10n/app_localizations.dart';

class NotificationCubit extends Cubit<bool> {
  final AppSecureStorage storage;

  NotificationCubit({required this.storage}) : super(true);

  bool get isEnabled => state;

  Future<void> loadPreference() async {
    try {
      final val = await storage.read(StorageKeys.notificationsEnabled);
      if (val != null) {
        emit(val == 'true');
      } else {
        // If not set yet, check system notification settings
        final settings = await FirebaseMessaging.instance.getNotificationSettings();
        final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
        emit(granted);
      }
    } catch (_) {
      emit(true);
    }
  }

  Future<void> toggleNotifications(BuildContext context, bool enable) async {
    final local = AppLocalizations.of(context);

    if (enable) {
      // User is enabling notifications
      var status = await Permission.notification.status;

      if (status.isDenied) {
        final result = await Permission.notification.request();
        status = result;
      }

      if (status.isPermanentlyDenied) {
        if (context.mounted && local != null) {
          _showPermissionDialog(context, local);
        }
        return;
      }

      final fcmSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final isAuthorized =
          fcmSettings.authorizationStatus == AuthorizationStatus.authorized ||
          fcmSettings.authorizationStatus == AuthorizationStatus.provisional ||
          status.isGranted;

      if (isAuthorized) {
        await storage.write(StorageKeys.notificationsEnabled, 'true');
        emit(true);

        try {
          if (getIt.isRegistered<NotificationService>()) {
            await getIt<NotificationService>().registerToken();
          }
        } catch (_) {}

        if (context.mounted && local != null) {
          SnackbarTheme().newSnackBarSuccess(
            context,
            local.notificationsEnabledMsg,
          );
        }
      } else {
        if (context.mounted && local != null) {
          SnackbarTheme().newSnackBarError(
            context,
            local.notificationPermissionDenied,
          );
        }
      }
    } else {
      // User is disabling notifications
      await storage.write(StorageKeys.notificationsEnabled, 'false');
      emit(false);

      if (context.mounted && local != null) {
        SnackbarTheme().newSnackBarInfo(
          context,
          local.notificationsDisabledMsg,
        );
      }
    }
  }

  void _showPermissionDialog(BuildContext context, AppLocalizations local) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(local.notificationPermissionTitle),
        content: Text(local.notificationPermissionDenied),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(local.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              openAppSettings();
            },
            child: Text(local.openSettings),
          ),
        ],
      ),
    );
  }
}
