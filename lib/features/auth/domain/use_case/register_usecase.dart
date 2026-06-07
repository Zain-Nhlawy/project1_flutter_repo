import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<String> call(Map<String, dynamic> body) {
    return repository.register(body);
  }
}