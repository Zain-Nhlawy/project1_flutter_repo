import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project1/features/notifications/domain/entities/notification_payload_entity.dart';

class NotificationPayloadModel extends NotificationPayloadEntity {
  const NotificationPayloadModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    super.screen,
    required super.data,
    required super.receivedAt,
    super.isRead = false,
  });

  factory NotificationPayloadModel.fromRemoteMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    final id = message.messageId ??
        data['id']?.toString() ??
        data['notificationId']?.toString() ??
        '${DateTime.now().millisecondsSinceEpoch}';

    final title = notification?.title ?? data['title']?.toString() ?? '';
    final body = notification?.body ??
        data['body']?.toString() ??
        data['message']?.toString() ??
        '';

    final type = data['type']?.toString() ??
        data['click_action']?.toString() ??
        'general';

    final screen = data['screen']?.toString() ??
        data['screenName']?.toString() ??
        data['screen_name']?.toString() ??
        data['targetScreen']?.toString() ??
        data['target_screen']?.toString() ??
        data['route']?.toString() ??
        data['page']?.toString();

    final receivedAt = message.sentTime ?? DateTime.now();

    return NotificationPayloadModel(
      id: id,
      title: title,
      body: body,
      type: type,
      screen: screen,
      data: Map<String, dynamic>.from(data),
      receivedAt: receivedAt,
      isRead: false,
    );
  }

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    Map<String, dynamic> dataMap = {};
    if (rawData is Map) {
      dataMap = Map<String, dynamic>.from(rawData);
    } else {
      // If flat json, preserve all keys in dataMap
      dataMap = Map<String, dynamic>.from(json);
    }

    final id = json['id']?.toString() ??
        dataMap['id']?.toString() ??
        '${DateTime.now().millisecondsSinceEpoch}';

    final title = json['title']?.toString() ?? dataMap['title']?.toString() ?? '';
    final body = json['body']?.toString() ??
        json['message']?.toString() ??
        dataMap['body']?.toString() ??
        dataMap['message']?.toString() ??
        '';

    final type = json['type']?.toString() ??
        dataMap['type']?.toString() ??
        'general';

    final screen = json['screen']?.toString() ??
        json['screenName']?.toString() ??
        dataMap['screen']?.toString() ??
        dataMap['screenName']?.toString() ??
        dataMap['targetScreen']?.toString() ??
        dataMap['route']?.toString();

    DateTime receivedAt = DateTime.now();
    if (json['receivedAt'] != null) {
      if (json['receivedAt'] is String) {
        receivedAt = DateTime.tryParse(json['receivedAt'] as String) ?? DateTime.now();
      } else if (json['receivedAt'] is int) {
        receivedAt = DateTime.fromMillisecondsSinceEpoch(json['receivedAt'] as int);
      }
    }

    final isRead = json['isRead'] == true || json['isRead'] == 'true';

    return NotificationPayloadModel(
      id: id,
      title: title,
      body: body,
      type: type,
      screen: screen,
      data: dataMap,
      receivedAt: receivedAt,
      isRead: isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'screen': screen,
      'data': data,
      'receivedAt': receivedAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  @override
  NotificationPayloadModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? screen,
    Map<String, dynamic>? data,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return NotificationPayloadModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      screen: screen ?? this.screen,
      data: data ?? this.data,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
