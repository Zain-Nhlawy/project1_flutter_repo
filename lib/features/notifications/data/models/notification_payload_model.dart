import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project1/features/notifications/domain/entities/notification_payload_entity.dart';

class NotificationPayloadModel extends NotificationPayloadEntity {
  const NotificationPayloadModel({
    required super.title,
    required super.body,
    required super.type,
    required super.data,
  });

  factory NotificationPayloadModel.fromRemoteMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    final title = notification?.title ?? data['title']?.toString() ?? '';
    final body = notification?.body ?? data['body']?.toString() ?? '';
    final type = data['type']?.toString() ?? data['click_action']?.toString() ?? 'general';

    return NotificationPayloadModel(
      title: title,
      body: body,
      type: type,
      data: Map<String, dynamic>.from(data),
    );
  }

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    return NotificationPayloadModel(
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: json['type']?.toString() ?? 'general',
      data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'data': data,
    };
  }
}
