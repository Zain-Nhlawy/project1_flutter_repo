import 'package:project1/features/auth/data/models/user_model.dart';

class LoginResponse {
  final UserModel? user;

  final String? accessToken;
  final String? refreshToken;

  final bool requires2FA;
  final String? twoFactorToken;

  LoginResponse({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.requires2FA = false,
    this.twoFactorToken,
  });
}
