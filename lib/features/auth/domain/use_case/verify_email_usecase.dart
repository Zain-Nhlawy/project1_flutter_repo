import 'package:project1/features/auth/domain/repository/auth_repository.dart';


class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<String> call(String token) {
    return repository.verifyEmail(token);
  }
}