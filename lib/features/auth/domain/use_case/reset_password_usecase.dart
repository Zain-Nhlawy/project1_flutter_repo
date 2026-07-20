import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(Map<String, dynamic> body) {
    return repository.resetPassword(body);
  }
}
