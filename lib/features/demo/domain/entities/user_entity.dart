class MembersEntity {
  const MembersEntity({
    this.id,
    this.demoId,
    this.memberIdInDemo,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imagePath,
    this.role,
  });

  final String? id;
  final String? demoId;
  final String? memberIdInDemo;
  final String firstName;
  final String lastName;
  final String email;
  final String? imagePath;
  final String? role;
}
