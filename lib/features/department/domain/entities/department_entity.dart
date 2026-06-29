class DepartmentEntity {
  final String? id;
  final String name;
  final String managerId;
  final String description;
  final int memberCount;

  DepartmentEntity({
    this.id,
    required this.name,
    required this.managerId,
    required this.description,
    required this.memberCount,
  });
}
