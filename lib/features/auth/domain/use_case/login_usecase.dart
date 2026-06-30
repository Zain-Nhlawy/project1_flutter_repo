import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponse> call(Map<String, dynamic> body) async {
    return await repository.login(body);
  }
}