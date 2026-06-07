class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final bool isEmailVerified;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.isEmailVerified,
  });
}