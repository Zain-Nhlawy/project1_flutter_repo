import 'package:project1/features/demo/shared/entities/user_entity.dart';

class MembersModel extends MembersEntity {
  const MembersModel({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.imagePath,
    required super.role,
  });

  factory MembersModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return MembersModel(
      id: user['id'] as String,
      firstName: user['firstName'] as String,
      lastName: user['lastName'] as String,
      email: user['email'] as String,
      imagePath: user['imagePath'] as String?,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'imagePath': imagePath,
      'role': role,
    };
  }
}
