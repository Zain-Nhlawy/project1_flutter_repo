import 'package:project1/features/demo/domain/entities/user_entity.dart';

class MembersModel extends MembersEntity {
  const MembersModel({
    super.id,
    super.demoId,
    super.memberIdInDemo,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.imagePath,
    required super.role,
  });

  factory MembersModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;
    return MembersModel(
      demoId: json['demoId'] as String? ?? user['demoId'] as String? ?? '',
      memberIdInDemo: json['id'] as String?,
      id: user['id'] as String? ?? json['id'] as String? ?? '',
      firstName: user['firstName'] as String? ?? json['firstName'] as String? ?? '',
      lastName: user['lastName'] as String? ?? json['lastName'] as String? ?? '',
      email: user['email'] as String? ?? json['email'] as String? ?? '',
      imagePath: user['imagePath'] as String?,
      role: json['role'] as String? ?? user['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'demoId': demoId,
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'imagePath': imagePath,
      'role': role,
    };
  }
}
