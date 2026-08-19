import 'package:project1/features/department/domain/entities/department_member_entity.dart';

class DepartmentMemberModel extends DepartmentMemberEntity {
  DepartmentMemberModel({
    required super.id,
    required super.departmentId,
    required super.jobTitle,
    required super.demoMemberId,
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.imagePath,
    super.role,
  });

  factory DepartmentMemberModel.fromJson(Map<String, dynamic> json) {
    final demoMemberJson = json['demoMember'] ?? {};
    final userJson = demoMemberJson['user'] ?? {};

    return DepartmentMemberModel(
      id: json['id'] ?? '',
      departmentId: json['departmentId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      demoMemberId: demoMemberJson['id'] ?? '',
      userId: userJson['id'] ?? '',
      firstName: userJson['firstName'] ?? '',
      lastName: userJson['lastName'] ?? '',
      email: userJson['email'] ?? '',
      imagePath: userJson['imagePath']?.toString() ?? '',
      role: demoMemberJson['role']?.toString() ?? json['role']?.toString(),
    );
  }
}
