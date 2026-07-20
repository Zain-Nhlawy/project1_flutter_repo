import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class Verify2FAUseCase {
  final AuthRepository repository;

  Verify2FAUseCase(this.repository);

  Future<Either<Failure, LoginResponse>> call({
    required String twoFactorToken,
    required String tfaCode,
  }) {
    return repository.verify2FA(
      twoFactorToken: twoFactorToken,
      tfaCode: tfaCode,
    );
  }
}
