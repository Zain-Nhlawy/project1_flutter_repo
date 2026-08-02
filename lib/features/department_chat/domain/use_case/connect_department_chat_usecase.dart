import '../repository/department_chat_repository.dart';

class ConnectDepartmentChatUseCase {
  final DepartmentChatRepository repository;

  ConnectDepartmentChatUseCase(this.repository);

  Future<void> call({required String departmentId}) {
    return repository.connectAndJoin(departmentId: departmentId);
  }
}
