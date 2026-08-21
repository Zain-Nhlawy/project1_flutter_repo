import 'package:project1/features/notifications/data/models/notification_payload_model.dart';

abstract class NotificationsState {
  const NotificationsState();
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationPayloadModel> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
}
