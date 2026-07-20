import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponse>> call(Map<String, dynamic> body) {
    return repository.login(body);
  }
}
