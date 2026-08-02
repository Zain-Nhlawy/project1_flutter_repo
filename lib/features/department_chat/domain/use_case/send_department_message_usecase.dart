import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../entities/message_type.dart';
import '../repository/department_chat_repository.dart';

class SendDepartmentMessageUseCase {
  final DepartmentChatRepository repository;

  SendDepartmentMessageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String departmentId,
    MessageType type = MessageType.text,
    String? content,
    String? fileUrl,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? replyToId,
  }) {
    return repository.sendMessage(
      departmentId: departmentId,
      type: type,
      content: content,
      fileUrl: fileUrl,
      fileName: fileName,
      mimeType: mimeType,
      fileSize: fileSize,
      replyToId: replyToId,
    );
  }
}
