import 'package:project1/core/network/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource(this.dioClient);

  Future<String> register(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/sign-up',
      data: body,
    );

    return res.data['message'];
  }

  Future<String> verifyEmail(String token) async {
    final res = await dioClient.dio.get(
      '/authentication/verify-email',
      queryParameters: {'token': token},
    );
    return res.data['message'];
  }

  Future<String> resendVerificationEmail(String email) async {
  final res = await dioClient.dio.post(
    '/authentication/resend-verification-email',
    data: {'email': email},
  );

  return res.data['message'] ?? 'Success';
}

  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/sign-in',
      data: body,
    );

    final userData = res.data['data']['user'];
    final accessToken = res.data['data']['accessToken'];
    final refreshToken = res.data['data']['refreshToken'];

    return {
      ...userData,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  Future<String> forgotPassword(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/forgot-password',
      data: body,
    );
    return res.data['message'];
  }

  Future<String> resetPassword(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/reset-password',
      data: body,
    );
    return res.data['message'];
  }

  Future<String> changePassword(Map<String, dynamic> body) async {
  final res = await dioClient.dio.post(
    '/authentication/change-password',
    data: body,
  );
  return res.data['message'];
}

Future<Map<String, dynamic>> googleLogin(String idToken) async {
  final res = await dioClient.dio.post(
    '/authentication/google/mobile',
    data: {
      'idToken': idToken,
    },
  );

  final userData = res.data['data']['user'];
  final accessToken = res.data['data']['accessToken'];
  final refreshToken = res.data['data']['refreshToken'];

  return {
    ...userData,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
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

    return res.data['data'];
  }
}