import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource(this.dioClient);

  Future<String> register(Map<String, dynamic> body) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/sign-up',
        data: body,
        options: Options(extra: {'noAuth': true}),
      );
      return res.data['message'] ?? 'Registration completed successfully.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> verifyEmail(String token) async {
    try {
      final res = await dioClient.dio.get(
        '/authentication/verify-email',
        queryParameters: {'token': token},
        options: Options(extra: {'noAuth': true}),
      );
      return res.data['message'] ?? 'Email verified successfully.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> resendVerificationEmail(String email) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/resend-verification-email',
        data: {'email': email},
        options: Options(extra: {'noAuth': true}),
      );
      return res.data['message'] ?? 'Verification email sent.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<LoginResponse> login(Map<String, dynamic> body) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/sign-in',
        data: body,
        options: Options(extra: {'noAuth': true}),
      );

      final data = res.data?['data'];

      if (data == null) {
        throw const ServerException('Unable to sign in. Please try again.');
      }

      if (data['requires2FA'] == true) {
        return LoginResponse(
          requires2FA: true,
          twoFactorToken: data['twoFactorToken'],
        );
      }

      return LoginResponse(
        user: UserModel.fromJson(data['user']),
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<LoginResponse> googleLogin(String idToken) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/google/mobile',
        data: {'idToken': idToken},
        options: Options(extra: {'noAuth': true}),
      );

      final data = res.data?['data'];

      if (data == null) {
        throw const ServerException('Google sign in failed.');
      }

      return LoginResponse(
        user: UserModel.fromJson(data['user']),
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<UserModel> getMe() async {
    try {
      final res = await dioClient.dio.get('/users/me');
      final data = res.data?['data'];

      if (data == null) {
        throw const ServerException('Unable to load your profile.');
      }

      return UserModel.fromJson(data['user']);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> forgotPassword(Map<String, dynamic> body) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/forgot-password',
        data: body,
        options: Options(extra: {'noAuth': true}),
      );
      return res.data['message'] ?? 'Password reset email sent.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> resetPassword(Map<String, dynamic> body) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/reset-password',
        data: body,
        options: Options(extra: {'noAuth': true}),
      );
      return res.data['message'] ?? 'Password reset successfully.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> changePassword(Map<String, dynamic> body) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/change-password',
        data: body,
      );
      return res.data['message'] ?? 'Password changed successfully.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await dioClient.dio.post('/authentication/sign-out');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/refresh-tokens',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'noAuth': true}),
      );

      final data = res.data?['data'];

      if (data == null) {
        throw const ServerException('Unable to refresh your session.');
      }

      return data;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<LoginResponse> verify2FA({
    required String twoFactorToken,
    required String tfaCode,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/sign-in/2fa',
        data: {
          'twoFactorToken': twoFactorToken,
          'tfaCode': tfaCode,
        },
        options: Options(extra: {'noAuth': true}),
      );

      final data = res.data?['data'];

      if (data == null) {
        throw const ServerException('Two-factor authentication failed.');
      }

      return LoginResponse(
        user: UserModel.fromJson(data['user']),
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> generate2FA({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/2fa/generate',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = res.data?['data'];

      if (data == null) {
        throw const ServerException('Unable to generate QR code.');
      }

      return data['qrCode'];
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> turnOn2FA({required String tfaCode}) async {
    try {
      final res = await dioClient.dio.post(
        '/authentication/2fa/turn-on',
        data: {'tfaCode': tfaCode},
      );
      return res.data['message'] ?? 'Two-factor authentication enabled.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<String> turnOff2FA() async {
    try {
      final res = await dioClient.dio.post('/authentication/2fa/turn-off');
      return res.data['message'] ?? 'Two-factor authentication disabled.';
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}