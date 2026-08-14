import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import '../../domain/entities/socket_connection_status.dart';
import '../models/department_message_model.dart';
import '../models/department_presence_model.dart';

abstract class DepartmentChatSocketDataSource {
  Future<void> connect({
    required String accessToken,
    required String departmentId,
  });

  Future<void> disconnect();

  Future<String> sendMessage({
    String? departmentId,
    required String type,
    String? content,
    String? fileUrl,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? replyToId,
  });

  Future<String> editMessage({
    required String messageId,
    required String content,
  });

  Future<String> deleteMessage({required String messageId});

  void sendTyping(bool isTyping);

  SocketConnectionStatus get status;
  Stream<DepartmentMessageModel> get messageReceivedStream;
  Stream<DepartmentMessageModel> get messageEditedStream;
  Stream<DepartmentMessageModel> get messageDeletedStream;
  Stream<Map<String, dynamic>> get typingStatusStream;
  Stream<Set<String>> get userOnlineStream;
  Stream<Set<String>> get userOfflineStream;
  Stream<SocketConnectionStatus> get connectionStatusStream;
  Stream<String> get exceptionStream;
  Stream<String> get joinedDepartmentMemberIdStream;
}

class DepartmentChatSocketDataSourceImpl
    implements DepartmentChatSocketDataSource {
  socket_io.Socket? _socket;
  String? _currentDepartmentId;
  String? _currentAccessToken;

  final _messageReceivedController =
      StreamController<DepartmentMessageModel>.broadcast();
  final _messageEditedController =
      StreamController<DepartmentMessageModel>.broadcast();
  final _messageDeletedController =
      StreamController<DepartmentMessageModel>.broadcast();
  final _typingStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _userOnlineController = StreamController<Set<String>>.broadcast();
  final _userOfflineController = StreamController<Set<String>>.broadcast();
  final _connectionStatusController =
      StreamController<SocketConnectionStatus>.broadcast();
  final _exceptionController = StreamController<String>.broadcast();
  final _joinedDepartmentMemberIdController =
      StreamController<String>.broadcast();

  SocketConnectionStatus _status = SocketConnectionStatus.initial;

  @override
  SocketConnectionStatus get status => _status;

  @override
  Stream<DepartmentMessageModel> get messageReceivedStream =>
      _messageReceivedController.stream;

  @override
  Stream<DepartmentMessageModel> get messageEditedStream =>
      _messageEditedController.stream;

  @override
  Stream<DepartmentMessageModel> get messageDeletedStream =>
      _messageDeletedController.stream;

  @override
  Stream<Map<String, dynamic>> get typingStatusStream =>
      _typingStatusController.stream;

  @override
  Stream<Set<String>> get userOnlineStream => _userOnlineController.stream;

  @override
  Stream<Set<String>> get userOfflineStream => _userOfflineController.stream;

  @override
  Stream<SocketConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  @override
  Stream<String> get exceptionStream => _exceptionController.stream;

  @override
  Stream<String> get joinedDepartmentMemberIdStream =>
      _joinedDepartmentMemberIdController.stream;

  void _updateStatus(SocketConnectionStatus newStatus) {
    _status = newStatus;
    _connectionStatusController.add(newStatus);
  }

  @override
  Future<void> connect({
    required String accessToken,
    required String departmentId,
  }) async {
    _currentAccessToken = accessToken;
    _currentDepartmentId = departmentId;

    if (_socket != null) {
      _socket?.dispose();
      _socket = null;
    }

    _updateStatus(SocketConnectionStatus.connecting);

    final options = socket_io.OptionBuilder()
        .setTransports(['websocket'])
        .setExtraHeaders({'token': accessToken})
        .setAuth({'token': accessToken})
        .disableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(999)
        .setReconnectionDelay(1000)
        .build();

    _socket = socket_io.io('https://api.lincolms.me/departmentChat', options);

    _socket?.onConnect((_) {
      _updateStatus(SocketConnectionStatus.connected);
      _joinRoom();
    });

    _socket?.onConnectError((data) {
      debugPrint('🔴 DepartmentChatSocket connect_error: $data');
      _updateStatus(SocketConnectionStatus.error);
    });

    _socket?.onDisconnect((_) {
      debugPrint('🟡 DepartmentChatSocket disconnected');
      _updateStatus(SocketConnectionStatus.reconnecting);
    });

    _socket?.on('connecting', (_) {
      _updateStatus(SocketConnectionStatus.connecting);
    });

    _socket?.on('messageReceived', (data) {
      if (data is Map<String, dynamic>) {
        try {
          final model = DepartmentMessageModel.fromJson(data);
          _messageReceivedController.add(model);
        } catch (e) {
          debugPrint('Error parsing messageReceived: $e');
        }
      }
    });

    _socket?.on('messageEdited', (data) {
      if (data is Map<String, dynamic>) {
        try {
          final model = DepartmentMessageModel.fromJson(data);
          _messageEditedController.add(model);
        } catch (e) {
          debugPrint('Error parsing messageEdited: $e');
        }
      }
    });

    _socket?.on('messageDeleted', (data) {
      if (data is Map<String, dynamic>) {
        try {
          final model = DepartmentMessageModel.fromJson(data);
          _messageDeletedController.add(model);
        } catch (e) {
          debugPrint('Error parsing messageDeleted: $e');
        }
      }
    });

    _socket?.on('userTypingStatus', (data) {
      if (data is Map<String, dynamic>) {
        _typingStatusController.add(data);
      }
    });

    _socket?.on('userOnline', (data) {
      _emitPresence(data, _userOnlineController);
    });

    _socket?.on('userOffline', (data) {
      _emitPresence(data, _userOfflineController);
    });

    for (final eventName in const [
      'onlineUsers',
      'onlineMembers',
      'usersOnline',
      'membersOnline',
      'presenceSnapshot',
    ]) {
      _socket?.on(eventName, (data) {
        final eventPresence = DepartmentPresenceModel.fromEvent(data);
        final snapshotPresence = DepartmentPresenceModel.fromSnapshot(data);
        final identifiers = {
          ...eventPresence.identifiers,
          ...snapshotPresence.identifiers,
        };
        if (identifiers.isNotEmpty) {
          _userOnlineController.add(identifiers);
        }
      });
    }

    _socket?.on('exception', (data) {
      if (data is Map<String, dynamic>) {
        final msg = data['message']?.toString() ?? 'Socket Exception';
        _exceptionController.add(msg);
      }
    });

    _socket?.connect();
  }

  void _joinRoom() {
    if (_socket != null && _socket!.connected && _currentDepartmentId != null) {
      _socket?.emitWithAck(
        'joinChat',
        {'departmentId': _currentDepartmentId},
        ack: (response) {
          debugPrint('🟢 Joined department chat room response: $response');
          if (response is Map) {
            final responseData = response['data'];
            final memberId =
                response['departmentMemberId']?.toString() ??
                (responseData is Map
                    ? responseData['departmentMemberId']?.toString()
                    : null);
            if (memberId != null && memberId.isNotEmpty) {
              _joinedDepartmentMemberIdController.add(memberId);
            }

            final snapshot = DepartmentPresenceModel.fromSnapshot(response);
            if (snapshot.identifiers.isNotEmpty) {
              _userOnlineController.add(snapshot.identifiers);
            }
          }
        },
      );
    }
  }

  void _emitPresence(dynamic data, StreamController<Set<String>> controller) {
    final presence = DepartmentPresenceModel.fromEvent(data);
    if (presence.identifiers.isNotEmpty) {
      controller.add(presence.identifiers);
    }
  }

  @override
  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _updateStatus(SocketConnectionStatus.initial);
  }

  @override
  Future<String> sendMessage({
    String? departmentId,
    required String type,
    String? content,
    String? fileUrl,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? replyToId,
  }) async {
    final completer = Completer<String>();

    final payload = <String, dynamic>{
      'departmentId': departmentId ?? _currentDepartmentId,
      'type': type,
      if (content != null && content.isNotEmpty) 'content': content,
      if (fileUrl != null) 'fileUrl': fileUrl,
      if (fileName != null) 'fileName': fileName,
      if (mimeType != null) 'mimeType': mimeType,
      if (fileSize != null) 'fileSize': fileSize,
      if (replyToId != null) 'replyToId': replyToId,
    };

    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket is not connected');
    }

    _socket!.emitWithAck(
      'sendMessage',
      payload,
      ack: (response) {
        if (response is Map<String, dynamic> &&
            response['status'] == 'success') {
          completer.complete(response['messageId']?.toString() ?? '');
        } else if (response is Map<String, dynamic> &&
            response['error'] != null) {
          completer.completeError(response['error'].toString());
        } else {
          completer.complete('sent');
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => 'sent',
    );
  }

  @override
  Future<String> editMessage({
    required String messageId,
    required String content,
  }) async {
    final completer = Completer<String>();

    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket is not connected');
    }

    _socket!.emitWithAck(
      'editMessage',
      {'messageId': messageId, 'content': content},
      ack: (response) {
        if (response is Map<String, dynamic> &&
            response['status'] == 'success') {
          completer.complete(response['messageId']?.toString() ?? messageId);
        } else {
          completer.complete(messageId);
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => messageId,
    );
  }

  @override
  Future<String> deleteMessage({required String messageId}) async {
    final completer = Completer<String>();

    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket is not connected');
    }

    _socket!.emitWithAck(
      'deleteMessage',
      {'messageId': messageId},
      ack: (response) {
        if (response is Map<String, dynamic> &&
            response['status'] == 'success') {
          completer.complete(response['messageId']?.toString() ?? messageId);
        } else {
          completer.complete(messageId);
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => messageId,
    );
  }

  @override
  void sendTyping(bool isTyping) {
    if (_socket != null && _socket!.connected) {
      _socket?.emit('typing', {'isTyping': isTyping});
    }
  }

  void dispose() {
    _messageReceivedController.close();
    _messageEditedController.close();
    _messageDeletedController.close();
    _typingStatusController.close();
    _userOnlineController.close();
    _userOfflineController.close();
    _connectionStatusController.close();
    _exceptionController.close();
    _joinedDepartmentMemberIdController.close();
  }

  String? get currentAccessToken => _currentAccessToken;
}
