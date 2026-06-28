import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/data/data_sources/auth_remote_datasource.dart';
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
  Future<UserEntity> login(Map<String, dynamic> body) async {
    final res = await remote.dioClient.dio.post('/authentication/sign-in', data: body);
    final userModel = UserModel.fromJson(res.data['data']['user']);
    await storage.write(StorageKeys.token, res.data['data']['accessToken']);
    await storage.write(StorageKeys.refreshToken, res.data['data']['refreshToken']);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> googleLogin(String idToken) async {
    final res = await remote.dioClient.dio.post(
      '/authentication/google/mobile',
      data: {'idToken': idToken},
    );
    final userModel = UserModel.fromJson(res.data['data']['user']);

    await storage.write(StorageKeys.token, res.data['data']['accessToken']);
    await storage.write(StorageKeys.refreshToken, res.data['data']['refreshToken']);

    return userModel.toEntity();
  }

  @override
  Future<UserEntity> getMe() async {
    final userModel = await remote.getMe();
    return userModel.toEntity();
  }

  @override
  Future<String> forgotPassword(Map<String, dynamic> body) async {
    return await remote.forgotPassword(body);
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> body) async {
    return await remote.resetPassword(body);
  }

  @override
Future<String> changePassword({
  required String oldPassword,
  required String newPassword,
}) async {
  return await remote.changePassword({
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

  Future<String?> refreshToken() async {
    final refresh = await storage.read(StorageKeys.refreshToken);
    if (refresh == null) return null;

    final data = await remote.refreshToken(refresh);

    final newAccess = data['accessToken'];
    final newRefresh = data['refreshToken'];

    await storage.write(StorageKeys.token, newAccess);
    await storage.write(StorageKeys.refreshToken, newRefresh);

    return newAccess;
  }
}