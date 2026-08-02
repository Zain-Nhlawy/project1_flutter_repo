import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../repository/department_chat_repository.dart';

class DeleteDepartmentMessageUseCase {
  final DepartmentChatRepository repository;

  DeleteDepartmentMessageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String messageId,
  }) {
    return repository.deleteMessage(
      messageId: messageId,
    );
  }
}
