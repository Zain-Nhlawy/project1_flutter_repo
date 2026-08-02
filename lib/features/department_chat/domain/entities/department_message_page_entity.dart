import 'department_message_entity.dart';

class DepartmentMessagePageEntity {
  final List<DepartmentMessageEntity> messages;
  final bool hasNextPage;
  final String? endCursor;

  const DepartmentMessagePageEntity({
    required this.messages,
    required this.hasNextPage,
    this.endCursor,
  });
}
