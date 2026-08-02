import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../repository/department_chat_repository.dart';

class EditDepartmentMessageUseCase {
  final DepartmentChatRepository repository;

  EditDepartmentMessageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String messageId,
    required String content,
  }) {
    return repository.editMessage(
      messageId: messageId,
      content: content,
    );
  }
}
