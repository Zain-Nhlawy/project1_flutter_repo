import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/data/data_sources/auth_remote_datasource.dart';
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
  Future<UserEntity> login(Map<String, dynamic> body) async {
    final data = await remote.login(body);

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    await storage.write(StorageKeys.token, accessToken);
    await storage.write(StorageKeys.refreshToken, refreshToken);

    return UserEntity(
      id: data['id']?.toString() ?? '',
      firstName: data['firstName']?.toString() ?? '',
      lastName: data['lastName']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      role: data['role']?.toString() ?? 'USER',
      isEmailVerified: data['isEmailVerified'] ?? false,
    );
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