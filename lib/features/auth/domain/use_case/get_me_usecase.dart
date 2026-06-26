import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository repository;
  GetMeUseCase(this.repository);
  Future<UserEntity> call() {
    return repository.getMe();
  }
}