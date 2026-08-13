import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/domain/use_case/change_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/generate2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/login_usecase.dart';
import 'package:project1/features/auth/domain/use_case/logout_usecase.dart';
import 'package:project1/features/auth/domain/use_case/register_usecase.dart';
import 'package:project1/features/auth/domain/use_case/resend_verification_email_usecase.dart';
import 'package:project1/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:project1/features/auth/domain/use_case/turnOff2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/turnOn2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/verify2FA_usecase.dart';
import 'package:project1/features/auth/domain/use_case/verify_email_usecase.dart';
import 'package:project1/features/auth/domain/use_case/google_login_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/session_cubit.dart';
import 'package:project1/features/auth/upload_photo/domain/use_case/upload_photo_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final ResendVerificationEmailUseCase resendVerificationEmailUseCase;
  final SessionCubit sessionCubit;
  final UploadPhotoUseCase uploadPhotoUseCase;
  final Verify2FAUseCase verify2FAUseCase;
  final Generate2FAUseCase generate2FAUseCase;
  final TurnOn2FAUseCase turnOn2FAUseCase;
  final TurnOff2FAUseCase turnOff2FAUseCase;

  File? imageFile;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.verifyEmailUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.changePasswordUseCase,
    required this.googleLoginUseCase,
    required this.resendVerificationEmailUseCase,
    required this.sessionCubit,
    required this.uploadPhotoUseCase,
    required this.verify2FAUseCase,
    required this.generate2FAUseCase,
    required this.turnOn2FAUseCase,
    required this.turnOff2FAUseCase,
  }) : super(AuthInitial());

  void _emitFailure(Failure failure) {
    emit(AuthError(failure.errors ?? [failure.message]));
  }

  Future<void> register(Map<String, dynamic> body) async {
    emit(AuthLoading());

    String imageUrl = "";

    if (imageFile != null) {
      final uploadResult = await uploadPhotoUseCase(imageFile!);

      final shouldStop = uploadResult.fold(
        (failure) {
          _emitFailure(failure);
          return true;
        },
        (url) {
          imageUrl = url;
          return false;
        },
      );
      if (shouldStop) return;
    }

    final updatedBody = {...body, "imagePath": imageUrl};

    final result = await registerUseCase(updatedBody);

    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(RegisterSuccess(message)),
    );
  }

  Future<void> login(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await loginUseCase(body);
    result.fold((failure) => _emitFailure(failure), (res) async {
      if (res.requires2FA) {
        emit(LoginRequires2FA(res.twoFactorToken!));
        return;
      }
      final user = res.user;
      if (user == null) {
        emit(const AuthError(['Unable to load the signed-in user.']));
        return;
      }
      sessionCubit.startSession(user);
      emit(LoginSuccess(user));
    });
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            "813919457973-59rpuvstsvj6d9el5nlu06q1kr5dps7i.apps.googleusercontent.com",
      );
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        emit(const AuthError(["Google id token not found"]));
        return;
      }
      final result = await googleLoginUseCase(idToken);
      result.fold((failure) => _emitFailure(failure), (res) async {
        final user = res.user;
        if (user == null) {
          emit(const AuthError(['Unable to load the signed-in user.']));
          return;
        }
        sessionCubit.startSession(user);
        emit(LoginSuccess(user));
      });
    } catch (e) {
      emit(AuthError([e.toString()]));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    await sessionCubit.clearSession();
    result.fold((failure) => _emitFailure(failure), (_) => emit(AuthInitial()));
  }

  Future<void> verifyEmail(String token) async {
    emit(AuthLoading());
    final result = await verifyEmailUseCase(token);
    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(VerifyEmailSuccess(message)),
    );
  }

  Future<void> forgotPassword(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase(body);
    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(ForgotPasswordSuccess(message)),
    );
  }

  Future<void> resetPassword(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(body);
    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(ResetPasswordSuccess(message)),
    );
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final result = await changePasswordUseCase(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(AuthChangePasswordSuccess(message)),
    );
  }

  Future<void> resendVerificationEmail(String email) async {
    emit(AuthLoading());
    final result = await resendVerificationEmailUseCase(email);
    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(ResendVerificationEmailSuccess(message)),
    );
  }

  void setImage(File file) {
    imageFile = file;
  }

  Future<void> verify2FA({
    required String twoFactorToken,
    required String tfaCode,
  }) async {
    emit(AuthLoading());
    final result = await verify2FAUseCase(
      twoFactorToken: twoFactorToken,
      tfaCode: tfaCode,
    );
    result.fold((failure) => _emitFailure(failure), (res) async {
      final user = res.user;
      if (user == null) {
        emit(const AuthError(['Unable to load the signed-in user.']));
        return;
      }
      sessionCubit.startSession(user);
      emit(LoginSuccess(user));
    });
  }

  Future<void> generate2FA({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await generate2FAUseCase(email: email, password: password);
    result.fold(
      (failure) => _emitFailure(failure),
      (qrCode) => emit(TwoFAGenerated(qrCode)),
    );
  }

  Future<void> turnOn2FA({required String tfaCode}) async {
    emit(AuthLoading());
    final result = await turnOn2FAUseCase(tfaCode: tfaCode);
    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(TurnOn2FASuccess(message)),
    );
  }

  Future<void> turnOff2FA() async {
    emit(AuthLoading());
    final result = await turnOff2FAUseCase();
    result.fold(
      (failure) => _emitFailure(failure),
      (message) => emit(TurnOff2FASuccess(message)),
    );
  }
}
