import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class ResendVerificationEmailUseCase {
  final AuthRepository repository;

  ResendVerificationEmailUseCase(this.repository);

  Future<Either<Failure, String>> call(String email) {
    return repository.resendVerificationEmail(email);
  }
}
