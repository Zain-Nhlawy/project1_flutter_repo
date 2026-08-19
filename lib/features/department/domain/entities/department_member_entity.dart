class DepartmentMemberEntity {
  final String id;
  final String departmentId;
  final String jobTitle;
  final String demoMemberId;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String imagePath;
  final String? role;

  DepartmentMemberEntity({
    required this.id,
    required this.departmentId,
    required this.jobTitle,
    required this.demoMemberId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imagePath,
    this.role,
  });
}