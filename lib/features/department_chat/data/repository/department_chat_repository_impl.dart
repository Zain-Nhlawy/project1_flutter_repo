import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import '../../domain/entities/department_message_entity.dart';
import '../../domain/entities/department_message_page_entity.dart';
import '../../domain/entities/message_type.dart';
import '../../domain/entities/socket_connection_status.dart';
import '../../domain/repository/department_chat_repository.dart';
import '../data_sources/department_chat_remote_datasource.dart';
import '../data_sources/department_chat_socket_datasource.dart';

class DepartmentChatRepositoryImpl implements DepartmentChatRepository {
  final DepartmentChatRemoteDataSource remoteDataSource;
  final DepartmentChatSocketDataSource socketDataSource;
  final AppSecureStorage storage;

  DepartmentChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
    required this.storage,
  });

  @override
  Future<Either<Failure, DepartmentMessagePageEntity>> getMessageHistory({
    required String departmentId,
    required String demoId,
    String? cursor,
    int take = 15,
  }) async {
    try {
      final res = await remoteDataSource.getMessagesHistory(
        departmentId: departmentId,
        demoId: demoId,
        cursor: cursor,
        take: take,
      );

      final messages = res['messages'] as List<DepartmentMessageEntity>;
      final hasNextPage = res['hasNextPage'] as bool;
      final endCursor = res['endCursor'] as String?;

      return Right(
        DepartmentMessagePageEntity(
          messages: messages,
          hasNextPage: hasNextPage,
          endCursor: endCursor,
        ),
      );
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> connectAndJoin({required String departmentId}) async {
    final token = await storage.read(StorageKeys.token);
    if (token != null && token.isNotEmpty) {
      await socketDataSource.connect(
        accessToken: token,
        departmentId: departmentId,
      );
    }
  }

  @override
  Future<void> disconnect() async {
    await socketDataSource.disconnect();
  }

  @override
  Future<Either<Failure, String>> sendMessage({
    required String departmentId,
    MessageType type = MessageType.text,
    String? content,
    String? fileUrl,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? replyToId,
  }) async {
    try {
      final messageId = await socketDataSource.sendMessage(
        departmentId: departmentId,
        type: type.toJson(),
        content: content,
        fileUrl: fileUrl,
        fileName: fileName,
        mimeType: mimeType,
        fileSize: fileSize,
        replyToId: replyToId,
      );
      return Right(messageId);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> editMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final res = await socketDataSource.editMessage(
        messageId: messageId,
        content: content,
      );
      return Right(res);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteMessage({
    required String messageId,
  }) async {
    try {
      final res = await socketDataSource.deleteMessage(
        messageId: messageId,
      );
      return Right(res);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  void sendTypingStatus({required bool isTyping}) {
    socketDataSource.sendTyping(isTyping);
  }

  @override
  Stream<DepartmentMessageEntity> get messageReceivedStream =>
      socketDataSource.messageReceivedStream;

  @override
  Stream<DepartmentMessageEntity> get messageEditedStream =>
      socketDataSource.messageEditedStream;

  @override
  Stream<DepartmentMessageEntity> get messageDeletedStream =>
      socketDataSource.messageDeletedStream;

  @override
  Stream<Map<String, dynamic>> get typingStatusStream =>
      socketDataSource.typingStatusStream;

  @override
  Stream<String> get userOnlineStream => socketDataSource.userOnlineStream;

  @override
  Stream<String> get userOfflineStream => socketDataSource.userOfflineStream;

  @override
  Stream<SocketConnectionStatus> get connectionStatusStream =>
      socketDataSource.connectionStatusStream;

  @override
  Stream<String> get exceptionStream => socketDataSource.exceptionStream;

  @override
  Stream<String> get joinedDepartmentMemberIdStream =>
      socketDataSource.joinedDepartmentMemberIdStream;
}
