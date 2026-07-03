import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/features/auth/domain/use_case/google_login_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
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
  final UserCubit userCubit;
  final UploadPhotoUseCase uploadPhotoUseCase;
  File? imageFile;
  final Verify2FAUseCase verify2FAUseCase;
  final Generate2FAUseCase generate2FAUseCase;
  final TurnOn2FAUseCase turnOn2FAUseCase;
  final TurnOff2FAUseCase turnOff2FAUseCase;

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
    required this.userCubit,
    required this.uploadPhotoUseCase,
    required this.verify2FAUseCase,
    required this.generate2FAUseCase,
    required this.turnOn2FAUseCase,
    required this.turnOff2FAUseCase,

  }) : super(AuthInitial());

  Future<void> register(Map<String, dynamic> body) async {
  emit(AuthLoading());
  try {
    String imageUrl = "";
    if (imageFile != null) {
      imageUrl = await uploadPhotoUseCase(imageFile!);
    }
    final updatedBody = {
      ...body,
      "imagePath": imageUrl,
    };
    final res = await registerUseCase(updatedBody);

    emit(RegisterSuccess(res));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

  Future<void> login(Map<String, dynamic> body) async {
  emit(AuthLoading());
  try {
    final res = await loginUseCase(body);
    if (res.requires2FA) {
      emit(LoginRequires2FA(res.twoFactorToken!));
      return;
    }
    await userCubit.getMe();
    emit(LoginSuccess(res.user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
Future<void> loginWithGoogle() async {
  emit(AuthLoading());
  await GoogleSignIn.instance.initialize(
    serverClientId: "813919457973-59rpuvstsvj6d9el5nlu06q1kr5dps7i.apps.googleusercontent.com",
  );
  try {
    final GoogleSignInAccount googleUser =
        await _googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) {
      emit(const AuthError('Google id token not found'));
      return;
    }
    await googleLoginUseCase(idToken);
    await userCubit.getMe();
    emit(LoginSuccess(null)); 
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

  Future<void> changePassword({
  required String oldPassword,
  required String newPassword,
}) async {
  emit(AuthLoading());
  try {
    final message = await changePasswordUseCase(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    emit(AuthChangePasswordSuccess(message));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

Future<void> resendVerificationEmail(String email) async {
  emit(AuthLoading());

  try {
    final message =
        await resendVerificationEmailUseCase(email);

    emit(ResendVerificationEmailSuccess(message));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

void setImage(File file) {
  imageFile = file;
}

Future<void> verify2FA({
  required String twoFactorToken,
  required String tfaCode,
}) async {
  emit(AuthLoading());
  try {
    final res = await verify2FAUseCase(
      twoFactorToken: twoFactorToken,
      tfaCode: tfaCode,
    );
    await userCubit.getMe();
    emit(LoginSuccess(res.user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

Future<void> generate2FA({
  required String email,
  required String password,
}) async {
  emit(AuthLoading());

  try {
    final qrCode = await generate2FAUseCase(
  email: email,
  password: password,
);

emit(TwoFAGenerated(qrCode));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

Future<void> turnOn2FA({
  required String tfaCode,
}) async {
  emit(AuthLoading());

  try {
    final message = await turnOn2FAUseCase(
      tfaCode: tfaCode,
    );

    emit(TurnOn2FASuccess(message));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

Future<void> turnOff2FA() async {
  emit(AuthLoading());

  try {
    final message = await turnOff2FAUseCase();

    emit(TurnOff2FASuccess(message));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}

}