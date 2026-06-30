import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class Verify2FAUseCase {
  final AuthRepository repository;

  Verify2FAUseCase(this.repository);

  Future<UserEntity> call({
    required String twoFactorToken,
    required String tfaCode,
  }) {
    return repository.verify2FA(
      twoFactorToken: twoFactorToken,
      tfaCode: tfaCode,
    );
  }
}