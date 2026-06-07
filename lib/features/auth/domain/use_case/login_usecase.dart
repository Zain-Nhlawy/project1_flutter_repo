import 'package:project1/features/auth/domain/repository/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(Map<String, dynamic> body) async {
    final user = await repository.login(body);
    if (!user.isEmailVerified) {
      throw Exception('Please verify your email first');
    }
    return user;
  }
}