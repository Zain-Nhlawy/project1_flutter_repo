import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class TurnOff2FAUseCase {
  final AuthRepository repository;

  TurnOff2FAUseCase(this.repository);

  Future<String> call() {
    return repository.turnOff2FA();
  }
}