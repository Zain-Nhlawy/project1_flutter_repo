import '../repository/department_chat_repository.dart';

class SetTypingStatusUseCase {
  final DepartmentChatRepository repository;

  SetTypingStatusUseCase(this.repository);

  void call({required bool isTyping}) {
    repository.sendTypingStatus(isTyping: isTyping);
  }
}
