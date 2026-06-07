import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<String> call(Map<String, dynamic> body) {
    return repository.resetPassword(body);
  }
}