import 'package:flutter/material.dart';
import 'package:project1/features/notifications/domain/entities/notification_payload_entity.dart';
import 'package:project1/main.dart';

abstract class NotificationTypeHandler {
  void handle(NotificationPayloadEntity payload, BuildContext context);
}

class NotificationNavigationHandler {
  static final Map<String, NotificationTypeHandler> _handlers = {};

  static void registerHandler(String type, NotificationTypeHandler handler) {
    _handlers[type] = handler;
  }

  static void handleNotificationTap(NotificationPayloadEntity payload) {
    final context = navigatorKey.currentContext;
    final currentState = navigatorKey.currentState;
    
    if (currentState == null || context == null) return;

    final type = payload.type;
    if (_handlers.containsKey(type)) {
      _handlers[type]!.handle(payload, context);
      return;
    }

    switch (type) {
      case 'order':
        debugPrint('Notification type order tapped with targetId: ${payload.targetId}');
        break;

      case 'message':
      case 'chat':
      case 'department_chat':
        debugPrint('Notification type chat tapped with targetId: ${payload.targetId}');
        break;

      case 'course':
        debugPrint('Notification type course tapped with targetId: ${payload.targetId}');
        break;

      case 'announcement':
      case 'general':
      default:
        debugPrint('General notification tapped: ${payload.title}');
        break;
    }
  }
}
