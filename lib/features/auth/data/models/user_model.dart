import 'package:project1/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.birthDate,
    required super.imagePath,
    required super.role,
    required super.isEmailVerified,
    required super.isTwoFactorEnabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      birthDate: json['birthDate'] ?? '',
      imagePath: json['imagePath'] ?? '',
      role: json['role'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      isTwoFactorEnabled: json['isTwoFactorEnabled'] ?? false,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate,
      imagePath: imagePath,
      role: role,
      isEmailVerified: isEmailVerified,
      isTwoFactorEnabled: isTwoFactorEnabled,
    );
  }
}
