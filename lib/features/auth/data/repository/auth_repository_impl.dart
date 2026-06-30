import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/data/models/user_model.dart';
import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AppSecureStorage storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<String> register(Map<String, dynamic> body) {
    return remote.register(body);
  }

  @override
  Future<String> verifyEmail(String token) {
    return remote.verifyEmail(token);
  }

  @override
  Future<String> resendVerificationEmail(String email) {
    return remote.resendVerificationEmail(email);
  }

  @override
  Future<LoginResponse> login(Map<String, dynamic> body) async {
    final res = await remote.login(body);

    if (res.requires2FA) {
      return res;
    }

    if (res.accessToken != null && res.refreshToken != null) {
      await storage.write(StorageKeys.token, res.accessToken!);
      await storage.write(StorageKeys.refreshToken, res.refreshToken!);
    }

    return res;
  }

  @override
Future<UserEntity> googleLogin(String idToken) async {
  final data = await remote.googleLogin(idToken);

  final userModel = UserModel.fromJson(data['user']);

  if (data['accessToken'] != null && data['refreshToken'] != null) {
    await storage.write(StorageKeys.token, data['accessToken']);
    await storage.write(StorageKeys.refreshToken, data['refreshToken']);
  }

  return userModel.toEntity();
}

  @override
  Future<UserEntity> getMe() async {
    final userModel = await remote.getMe();
    return userModel.toEntity();
  }

  @override
  Future<String> forgotPassword(Map<String, dynamic> body) {
    return remote.forgotPassword(body);
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> body) {
    return remote.resetPassword(body);
  }

  @override
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return remote.changePassword({
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });
  }

  @override
  Future<void> logout() async {
    await remote.logout();
    await storage.delete(StorageKeys.token);
    await storage.delete(StorageKeys.refreshToken);
  }

  @override
  Future<UserEntity> verify2FA({
    required String twoFactorToken,
    required String tfaCode,
  }) async {
    final userModel = await remote.verify2FA(
      twoFactorToken: twoFactorToken,
      tfaCode: tfaCode,
    );

    return userModel.toEntity();
  }

  @override
  Future<String> generate2FA({
    required String email,
    required String password,
  }) {
    return remote.generate2FA(
      email: email,
      password: password,
    );
  }

  @override
  Future<String> turnOn2FA({
    required String tfaCode,
  }) {
    return remote.turnOn2FA(tfaCode: tfaCode);
  }
}