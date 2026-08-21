import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/notifications/data/models/notification_payload_model.dart';

class NotificationStorageService {
  static const String _legacyStorageKey = 'CACHED_NOTIFICATIONS_LIST';
  static const String _storagePrefix = 'CACHED_NOTIFICATIONS_USER_';
  final AppSecureStorage storage;

  String? _currentUserId;
  bool _isInitialized = false;

  final StreamController<List<NotificationPayloadModel>> _notificationsStreamController =
      StreamController<List<NotificationPayloadModel>>.broadcast();

  final StreamController<int> _unreadCountStreamController =
      StreamController<int>.broadcast();

  List<NotificationPayloadModel> _cachedList = [];

  NotificationStorageService({required this.storage});

  Stream<List<NotificationPayloadModel>> get notificationsStream =>
      _notificationsStreamController.stream;

  Stream<int> get unreadCountStream => _unreadCountStreamController.stream;

  int get unreadCount => _cachedList.where((n) => !n.isRead).length;

  List<NotificationPayloadModel> get currentNotifications => List.unmodifiable(_cachedList);

  String? get currentUserId => _currentUserId;

  String _getStorageKey(String userId) => '$_storagePrefix$userId';

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      // Remove legacy shared key if it exists
      await storage.delete(_legacyStorageKey);
      _currentUserId = await storage.read(StorageKeys.currentUserId);
      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        await getNotifications();
      } else {
        _cachedList = [];
        _notifyListeners();
      }
    } catch (e) {
      debugPrint('Error initializing NotificationStorageService: $e');
    }
    _isInitialized = true;
  }

  Future<void> setCurrentUserId(String? userId) async {
    if (userId != null && userId.isNotEmpty) {
      if (_currentUserId == userId && _isInitialized) return;
      _currentUserId = userId;
      await storage.write(StorageKeys.currentUserId, userId);
      await getNotifications();
    } else {
      await clearCurrentUser();
    }
  }

  Future<void> clearCurrentUser() async {
    _currentUserId = null;
    try {
      await storage.delete(StorageKeys.currentUserId);
    } catch (_) {}
    _cachedList = [];
    _notifyListeners();
  }

  Future<List<NotificationPayloadModel>> getNotifications() async {
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      _currentUserId = await storage.read(StorageKeys.currentUserId);
    }

    if (_currentUserId == null || _currentUserId!.isEmpty) {
      _cachedList = [];
      _notifyListeners();
      return _cachedList;
    }

    try {
      final key = _getStorageKey(_currentUserId!);
      final raw = await storage.read(key);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          _cachedList = decoded
              .map((item) => NotificationPayloadModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ))
              .toList();
          // Sort latest first
          _cachedList.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
        }
      } else {
        _cachedList = [];
      }
    } catch (e) {
      debugPrint('Error loading cached notifications: $e');
      _cachedList = [];
    }

    _notifyListeners();
    return _cachedList;
  }

  Future<void> saveNotification(NotificationPayloadModel notification) async {
    try {
      if (_currentUserId == null || _currentUserId!.isEmpty) {
        _currentUserId = await storage.read(StorageKeys.currentUserId);
      }

      final targetUserId = notification.data['userId']?.toString() ??
          notification.data['targetUserId']?.toString() ??
          notification.data['recipientId']?.toString() ??
          notification.data['receiverId']?.toString();

      final activeUserId = targetUserId ?? _currentUserId;

      if (activeUserId == null || activeUserId.isEmpty) {
        debugPrint('No active user to save notification for.');
        return;
      }

      // If notification belongs to a different user than currently loaded
      if (activeUserId != _currentUserId) {
        final key = _getStorageKey(activeUserId);
        final raw = await storage.read(key);
        List<dynamic> list = [];
        if (raw != null && raw.isNotEmpty) {
          try {
            final decoded = jsonDecode(raw);
            if (decoded is List) list = decoded;
          } catch (_) {}
        }
        list.removeWhere((item) => item is Map && item['id'] == notification.id);
        list.insert(0, notification.toJson());
        if (list.length > 100) list = list.sublist(0, 100);
        await storage.write(key, jsonEncode(list));
        return;
      }

      // Remove any existing notification with identical ID in memory
      _cachedList.removeWhere((n) => n.id == notification.id);
      _cachedList.insert(0, notification);

      if (_cachedList.length > 100) {
        _cachedList = _cachedList.sublist(0, 100);
      }

      await _persist();
      _notifyListeners();
    } catch (e) {
      debugPrint('Error saving notification: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final index = _cachedList.indexWhere((n) => n.id == id);
      if (index != -1 && !_cachedList[index].isRead) {
        _cachedList[index] = _cachedList[index].copyWith(isRead: true);
        await _persist();
        _notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      bool hasChanges = false;
      for (int i = 0; i < _cachedList.length; i++) {
        if (!_cachedList[i].isRead) {
          _cachedList[i] = _cachedList[i].copyWith(isRead: true);
          hasChanges = true;
        }
      }
      if (hasChanges) {
        await _persist();
        _notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final previousLength = _cachedList.length;
      _cachedList.removeWhere((n) => n.id == id);
      if (_cachedList.length != previousLength) {
        await _persist();
        _notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      _cachedList.clear();
      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        await storage.delete(_getStorageKey(_currentUserId!));
      }
      _notifyListeners();
    } catch (e) {
      debugPrint('Error clearing all notifications: $e');
    }
  }

  Future<void> _persist() async {
    if (_currentUserId == null || _currentUserId!.isEmpty) return;
    try {
      final jsonString = jsonEncode(
        _cachedList.map((n) => n.toJson()).toList(),
      );
      await storage.write(_getStorageKey(_currentUserId!), jsonString);
    } catch (e) {
      debugPrint('Error persisting notifications: $e');
    }
  }

  void _notifyListeners() {
    _notificationsStreamController.add(List.unmodifiable(_cachedList));
    _unreadCountStreamController.add(unreadCount);
  }

  void dispose() {
    _notificationsStreamController.close();
    _unreadCountStreamController.close();
  }
}
