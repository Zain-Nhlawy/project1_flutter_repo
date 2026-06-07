import 'package:project1/features/auth/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;
  RegisterSuccess(this.message);
}

class LoginSuccess extends AuthState {
  final dynamic user;
  LoginSuccess(this.user);
}

class VerifyEmailSuccess extends AuthState {
  final String message;
  VerifyEmailSuccess(this.message);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}