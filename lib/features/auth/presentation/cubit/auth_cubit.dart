import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/login_usecase.dart';
import 'package:project1/features/auth/domain/use_case/logout_usecase.dart';
import 'package:project1/features/auth/domain/use_case/register_usecase.dart';
import 'package:project1/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/verify_email_usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.verifyEmailUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial());

  Future<void> register(Map<String, dynamic> body) async {
    emit(AuthLoading());
    try {
      final res = await registerUseCase(body);
      emit(RegisterSuccess(res));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(Map<String, dynamic> body) async {
  emit(AuthLoading());
  try {
    final user = await loginUseCase(body);
    if (!user.isEmailVerified) {
      emit(AuthError("Please verify your email first"));
      return;
    }
    emit(LoginSuccess(user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

Future<void> forgotPassword(Map<String, dynamic> body) async {
    emit(AuthLoading());
    try {
      final message = await forgotPasswordUseCase(body);
      emit(ForgotPasswordSuccess(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(Map<String, dynamic> body) async {
    emit(AuthLoading());
    try {
      final message = await resetPasswordUseCase(body);
      emit(ResetPasswordSuccess(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyEmail(String token) async {
  emit(AuthLoading());

  try {
    final message = await verifyEmailUseCase(token);
    emit(VerifyEmailSuccess(message));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}
}