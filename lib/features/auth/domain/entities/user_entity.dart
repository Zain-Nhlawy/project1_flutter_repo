class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String birthDate;
  final String imagePath;
  final String role;
  final bool isEmailVerified;
  final bool isTwoFactorEnabled;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.imagePath,
    required this.role,
    required this.isEmailVerified,
    required this.isTwoFactorEnabled,
  });
}
