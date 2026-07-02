import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/auth/data/models/login_response_model.dart';
import 'package:project1/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource(this.dioClient);

  Future<String> register(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/sign-up',
      data: body,
    );

    return res.data['message'] ?? '';
  }

  Future<String> verifyEmail(String token) async {
    final res = await dioClient.dio.get(
      '/authentication/verify-email',
      queryParameters: {'token': token},
    );

    return res.data['message'] ?? '';
  }

  Future<String> resendVerificationEmail(String email) async {
    final res = await dioClient.dio.post(
      '/authentication/resend-verification-email',
      data: {'email': email},
    );

    return res.data['message'] ?? 'Success';
  }

  Future<LoginResponse> login(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/sign-in',
      data: body,
    );
    final data = res.data?['data'];
    if (data == null) {
      throw Exception('Invalid login response');
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
  }

  Future<LoginResponse> googleLogin(String idToken) async {
  final res = await dioClient.dio.post(
    '/authentication/google/mobile',
    data: {'idToken': idToken},
    options: Options(extra: {'noAuth': true}),
  );
  final data = res.data?['data'];
  if (data == null) {
    throw Exception('Invalid google login response');
  }
  return LoginResponse(
    user: UserModel.fromJson(data['user']),
    accessToken: data['accessToken'],
    refreshToken: data['refreshToken'],
  );
}

  Future<UserModel> getMe() async {
    final res = await dioClient.dio.get('/users/me');

    final data = res.data?['data'];

    if (data == null) {
      throw Exception('Invalid getMe response');
    }

    return UserModel.fromJson(data['user']);
  }

  Future<String> forgotPassword(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/forgot-password',
      data: body,
    );

    return res.data['message'] ?? '';
  }

  Future<String> resetPassword(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/reset-password',
      data: body,
    );

    return res.data['message'] ?? '';
  }

  Future<String> changePassword(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/change-password',
      data: body,
    );

    return res.data['message'] ?? '';
  }

  Future<void> logout() async {
    await dioClient.dio.post('/authentication/sign-out');
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final res = await dioClient.dio.post(
      '/authentication/refresh-tokens',
      data: {
        "refreshToken": refreshToken,
      },
    );

    final data = res.data?['data'];

    if (data == null) {
      throw Exception('Invalid refresh token response');
    }

    return data;
  }

  Future<LoginResponse> verify2FA({
  required String twoFactorToken,
  required String tfaCode,
}) async {
  final res = await dioClient.dio.post(
    '/authentication/sign-in/2fa',
    data: {
      "twoFactorToken": twoFactorToken,
      "tfaCode": tfaCode,
    },
  );

  final data = res.data?['data'];

  if (data == null) {
    throw Exception('Invalid 2FA response');
  }

  return LoginResponse(
    user: UserModel.fromJson(data['user']),
    accessToken: data['accessToken'],
    refreshToken: data['refreshToken'],
  );
}
  Future<String> generate2FA({
    required String email,
    required String password,
  }) async {
    final res = await dioClient.dio.post(
      "/authentication/2fa/generate",
      data: {
        "email": email,
        "password": password,
      },
    );

    final data = res.data?['data'];

    if (data == null) {
      throw Exception('Invalid generate 2FA response');
    }

    return data["qrCode"];
  }

  Future<String> turnOn2FA({
    required String tfaCode,
  }) async {
    final res = await dioClient.dio.post(
      '/authentication/2fa/turn-on',
      data: {
        "tfaCode": tfaCode,
      },
    );

    return res.data['message'] ?? 'Success';
  }
}