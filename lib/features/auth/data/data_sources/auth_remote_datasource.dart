import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/auth/data/models/user_model.dart';

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

  Future<UserModel> login(Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/authentication/sign-in',
      data: body
      );
    return UserModel.fromJson(res.data['data']['user']);
  }

  Future<UserModel> googleLogin(String idToken) async {
    final res = await dioClient.dio.post(
      '/authentication/google/mobile',
      data: {'idToken': idToken},
    );
    return UserModel.fromJson(res.data['data']['user']);
  }

  Future<UserModel> getMe() async {
  final res = await dioClient.dio.get(
    '/users/me'
    );
  return UserModel.fromJson(res.data['data']['user']);
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