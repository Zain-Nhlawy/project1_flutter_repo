import '../repository/auth_repository.dart';

class ResendVerificationEmailUseCase {
  final AuthRepository repository;

  ResendVerificationEmailUseCase(this.repository);

  Future<String> call(String email) {
    return repository.resendVerificationEmail(email);
  }
}