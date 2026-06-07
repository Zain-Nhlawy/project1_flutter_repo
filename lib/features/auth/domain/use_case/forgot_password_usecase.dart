import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<String> call(Map<String, dynamic> body) {
    return repository.forgotPassword(body);
  }
}