import 'package:project1/features/auth/data/models/login_response_model.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<String> register(Map<String, dynamic> body);
  Future<String> verifyEmail(String token);
  Future<String> resendVerificationEmail(String email);
Future<LoginResponse> login(Map<String, dynamic> body);
  Future<UserEntity> getMe();
  Future<String> forgotPassword(Map<String, dynamic> body);
  Future<String> resetPassword(Map<String, dynamic> body);
  Future<String> changePassword({
  required String oldPassword,
  required String newPassword,  
});
Future<LoginResponse> googleLogin(String idToken);
  Future<void> logout();
  Future<LoginResponse> verify2FA({
  required String twoFactorToken,
  required String tfaCode,
});
Future<String> generate2FA({
  required String email,
  required String password,
});
Future<String> turnOn2FA({
  required String tfaCode,
});
}