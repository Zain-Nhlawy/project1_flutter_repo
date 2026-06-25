import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<UserEntity> call(String idToken) {
    return repository.googleLogin(idToken);
  }
}