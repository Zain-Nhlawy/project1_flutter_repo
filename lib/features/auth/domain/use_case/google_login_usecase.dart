import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<LoginResponse> call(String idToken) {
    return repository.googleLogin(idToken);
  }
}