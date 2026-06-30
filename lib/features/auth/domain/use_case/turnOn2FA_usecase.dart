import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class TurnOn2FAUseCase {
  final AuthRepository repository;

  TurnOn2FAUseCase(this.repository);

  Future<String> call({
    required String tfaCode,
  }) {
    return repository.turnOn2FA(tfaCode: tfaCode);
  }
}