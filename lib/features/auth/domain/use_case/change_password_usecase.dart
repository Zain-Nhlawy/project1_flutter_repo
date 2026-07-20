import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String oldPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
