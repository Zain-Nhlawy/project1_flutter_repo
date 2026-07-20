import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class TurnOff2FAUseCase {
  final AuthRepository repository;

  TurnOff2FAUseCase(this.repository);

  Future<Either<Failure, String>> call() {
    return repository.turnOff2FA();
  }
}
