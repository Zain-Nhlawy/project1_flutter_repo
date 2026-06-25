import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<String> register(Map<String, dynamic> body);
  Future<String> verifyEmail(String token);
  Future<UserEntity> login(Map<String, dynamic> body);
  Future<String> forgotPassword(Map<String, dynamic> body);
  Future<String> resetPassword(Map<String, dynamic> body);
  Future<String> changePassword({
  required String oldPassword,
  required String newPassword,
});
  Future<UserEntity> googleLogin(String idToken);
  Future<void> logout();
}