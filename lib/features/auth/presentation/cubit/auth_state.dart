abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);
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

class ResendVerificationEmailSuccess extends AuthState {
  final String message;

  const ResendVerificationEmailSuccess(this.message);
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

class TwoFactorRequired extends AuthState {
  final String twoFactorToken;

  const TwoFactorRequired(this.twoFactorToken);
}

class TwoFAGenerated extends AuthState {
  final String qrData;
  const TwoFAGenerated(this.qrData);
}

class TurnOn2FASuccess extends AuthState {
  final String message;

  const TurnOn2FASuccess(this.message);
}
