import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/notifications/data/data_sources/notification_storage_service.dart';
import 'package:project1/features/notifications/data/models/notification_payload_model.dart';
import 'package:project1/features/notifications/presentation/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationStorageService storageService;
  StreamSubscription<List<NotificationPayloadModel>>? _subscription;

  NotificationsCubit({required this.storageService})
      : super(const NotificationsInitial()) {
    _init();
  }

  void _init() {
    _subscription = storageService.notificationsStream.listen((notifications) {
      if (!isClosed) {
        emit(
          NotificationsLoaded(
            notifications: notifications,
            unreadCount: storageService.unreadCount,
          ),
        );
      }
    });
  }

  Future<void> fetchNotifications() async {
    try {
      emit(const NotificationsLoading());
      final notifications = await storageService.getNotifications();
      emit(
        NotificationsLoaded(
          notifications: notifications,
          unreadCount: storageService.unreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    await storageService.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await storageService.markAllAsRead();
  }

  Future<void> deleteNotification(String id) async {
    await storageService.deleteNotification(id);
  }

  Future<void> clearAll() async {
    await storageService.clearAll();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
