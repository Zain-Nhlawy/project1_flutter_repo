import 'package:project1/features/auth/data/models/user_model.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class RegisterSuccess extends AuthState {
  final String message;

  const RegisterSuccess(this.message);
}

class LoginSuccess extends AuthState {
  final dynamic user;

  const LoginSuccess(this.user);
}

class VerifyEmailSuccess extends AuthState {
  final String message;

  const VerifyEmailSuccess(this.message);
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess(this.message);
}

class ResetPasswordSuccess extends AuthState {
  final String message;
  const ResetPasswordSuccess(this.message);

}

class AuthChangePasswordSuccess extends AuthState {
  final String message;

  AuthChangePasswordSuccess(this.message);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}