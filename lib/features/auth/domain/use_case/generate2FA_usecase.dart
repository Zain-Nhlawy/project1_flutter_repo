import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class Generate2FAUseCase {
  final AuthRepository repository;

  Generate2FAUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String email,
    required String password,
  }) {
    return repository.generate2FA(
      email: email,
      password: password,
    );
  }
}