import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../entities/department_message_page_entity.dart';
import '../repository/department_chat_repository.dart';

class GetMessageHistoryUseCase {
  final DepartmentChatRepository repository;

  GetMessageHistoryUseCase(this.repository);

  Future<Either<Failure, DepartmentMessagePageEntity>> call({
    required String departmentId,
    required String demoId,
    String? cursor,
    int take = 15,
  }) {
    return repository.getMessageHistory(
      departmentId: departmentId,
      demoId: demoId,
      cursor: cursor,
      take: take,
    );
  }
}
