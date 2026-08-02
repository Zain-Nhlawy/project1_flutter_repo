import '../repository/department_chat_repository.dart';

class DisconnectDepartmentChatUseCase {
  final DepartmentChatRepository repository;

  DisconnectDepartmentChatUseCase(this.repository);

  Future<void> call() {
    return repository.disconnect();
  }
}
