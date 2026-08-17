class DepartmentEntity {
  final String? id;
  final String name;
  final String managerId;
  final String description;
  final int? memberCount;
  final bool? isJoined;
  final bool? isGroup;

  DepartmentEntity({
    this.id,
    required this.name,
    required this.managerId,
    required this.description,
    this.memberCount,
    this.isJoined,
    this.isGroup,
  });
}
