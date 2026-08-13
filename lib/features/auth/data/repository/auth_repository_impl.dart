import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AppSecureStorage storage;

  AuthRepositoryImpl(this.remote, this.storage);

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  Future<void> _saveTokens(LoginResponse res) async {
    if (res.accessToken != null && res.refreshToken != null) {
      await storage.write(StorageKeys.refreshToken, res.refreshToken!);
      await storage.write(StorageKeys.token, res.accessToken!);
    }
  }

  @override
  Future<Either<Failure, String>> register(Map<String, dynamic> body) {
    return _handle(() => remote.register(body));
  }

  @override
  Future<Either<Failure, String>> verifyEmail(String token) {
    return _handle(() => remote.verifyEmail(token));
  }

  @override
  Future<Either<Failure, String>> resendVerificationEmail(String email) {
    return _handle(() => remote.resendVerificationEmail(email));
  }

  @override
  Future<Either<Failure, LoginResponse>> login(
    Map<String, dynamic> body,
  ) async {
    return _handle(() async {
      final res = await remote.login(body);

      if (!res.requires2FA) {
        await _saveTokens(res);
      }

      return res;
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> googleLogin(String idToken) async {
    return _handle(() async {
      final res = await remote.googleLogin(idToken);
      await _saveTokens(res);
      return res;
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() {
    return _handle(() async {
      final userModel = await remote.getMe();
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> forgotPassword(Map<String, dynamic> body) {
    return _handle(() => remote.forgotPassword(body));
  }

  @override
  Future<Either<Failure, String>> resetPassword(Map<String, dynamic> body) {
    return _handle(() => remote.resetPassword(body));
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _handle(
      () => remote.changePassword({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      }),
    );
  }

  @override
  Future<Either<Failure, void>> logout() {
    return _handle(() async {
      try {
        await remote.logout();
      } finally {
        await storage.delete(StorageKeys.token);
        await storage.delete(StorageKeys.refreshToken);
      }
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> verify2FA({
    required String twoFactorToken,
    required String tfaCode,
  }) {
    return _handle(() async {
      final res = await remote.verify2FA(
        twoFactorToken: twoFactorToken,
        tfaCode: tfaCode,
      );

      await _saveTokens(res);

      return res;
    });
  }

  @override
  Future<Either<Failure, String>> generate2FA({
    required String email,
    required String password,
  }) {
    return _handle(() => remote.generate2FA(email: email, password: password));
  }

  @override
  Future<Either<Failure, String>> turnOn2FA({required String tfaCode}) {
    return _handle(() => remote.turnOn2FA(tfaCode: tfaCode));
  }

  @override
  Future<Either<Failure, String>> turnOff2FA() {
    return _handle(() => remote.turnOff2FA());
  }
}
