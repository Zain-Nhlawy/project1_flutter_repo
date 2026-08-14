import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../entities/department_attachment_upload_entity.dart';
import '../entities/department_message_entity.dart';
import '../entities/department_message_page_entity.dart';
import '../entities/message_type.dart';
import '../entities/socket_connection_status.dart';

abstract class DepartmentChatRepository {
  Future<Either<Failure, DepartmentAttachmentUploadEntity>>
  requestAttachmentUpload({
    required String departmentId,
    required String demoId,
    required String fileName,
  });

  Future<Either<Failure, void>> uploadAttachmentFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String mimeType,
    required void Function(double progress) onProgress,
  });

  Future<Either<Failure, DepartmentMessagePageEntity>> getMessageHistory({
    required String departmentId,
    required String demoId,
    String? cursor,
    int take = 15,
  });

  Future<void> connectAndJoin({required String departmentId});
  Future<void> disconnect();

  Future<Either<Failure, String>> sendMessage({
    required String departmentId,
    MessageType type = MessageType.text,
    String? content,
    String? fileUrl,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? replyToId,
  });

  Future<Either<Failure, String>> editMessage({
    required String messageId,
    required String content,
  });

  Future<Either<Failure, String>> deleteMessage({required String messageId});

  void sendTypingStatus({required bool isTyping});

  Stream<DepartmentMessageEntity> get messageReceivedStream;
  Stream<DepartmentMessageEntity> get messageEditedStream;
  Stream<DepartmentMessageEntity> get messageDeletedStream;
  Stream<Map<String, dynamic>> get typingStatusStream;
  Stream<Set<String>> get userOnlineStream;
  Stream<Set<String>> get userOfflineStream;
  Stream<SocketConnectionStatus> get connectionStatusStream;
  Stream<String> get exceptionStream;
  Stream<String> get joinedDepartmentMemberIdStream;
}
