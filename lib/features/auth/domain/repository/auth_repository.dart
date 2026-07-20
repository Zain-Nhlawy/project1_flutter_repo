import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/data/models/login_response_model.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> register(Map<String, dynamic> body);
  Future<Either<Failure, String>> verifyEmail(String token);
  Future<Either<Failure, String>> resendVerificationEmail(String email);
  Future<Either<Failure, LoginResponse>> login(Map<String, dynamic> body);
  Future<Either<Failure, UserEntity>> getMe();
  Future<Either<Failure, String>> forgotPassword(Map<String, dynamic> body);
  Future<Either<Failure, String>> resetPassword(Map<String, dynamic> body);
  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<Either<Failure, LoginResponse>> googleLogin(String idToken);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, LoginResponse>> verify2FA({
    required String twoFactorToken,
    required String tfaCode,
  });
  Future<Either<Failure, String>> generate2FA({
    required String email,
    required String password,
  });
  Future<Either<Failure, String>> turnOn2FA({required String tfaCode});
  Future<Either<Failure, String>> turnOff2FA();
}
