import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'api.dart';
import '../storage/storage_keys.dart';

class DioClient extends Api {
  final AppSecureStorage storage;
  final Future<Map<String, dynamic>?> Function() refreshToken;

  DioClient({
    required this.storage,
    required this.refreshToken,
  }) : super() {
    dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

    dio.interceptors.clear();
    bool isRefreshing = false;
    Future<void> handleRefresh() async {
      if (isRefreshing) return;
      isRefreshing = true;
      try {
        final data = await refreshToken();
        if (data != null) {
          final newAccess = data['accessToken'];
          final newRefresh = data['refreshToken'];
          if (newAccess != null) {
            await storage.write(StorageKeys.token, newAccess);
          }
          if (newRefresh != null) {
            await storage.write(StorageKeys.refreshToken, newRefresh);
          }
        }
      } finally {
        isRefreshing = false;
      }
    }
    bool shouldRefresh(String? token) {
      if (token == null) return true;
      try {
        return JwtDecoder.isExpired(token) ||
            JwtDecoder.getRemainingTime(token).inSeconds < 60;
      } catch (_) {
        return true;
      }
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.addAll({
            'User-Agent': 'Flutter-Mobile-App',
            'X-Platform': 'mobile',
            'isWeb': 'false',
            'Accept': 'application/json',
          });
          final noAuth = options.extra['noAuth'] == true;
          if (!noAuth) {
            final token = await storage.read(StorageKeys.token);
            if (shouldRefresh(token)) {
              await handleRefresh();
            }
            final updatedToken = await storage.read(StorageKeys.token);
            if (updatedToken != null) {
              options.headers['Authorization'] =
                  'Bearer $updatedToken';
            }
          }

          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          final is401 = error.response?.statusCode == 401;
          final retried = error.requestOptions.extra['retried'] == true;
          final noAuth = error.requestOptions.extra['noAuth'] == true;
          if (!is401 || retried || noAuth) {
            return handler.next(error);
          }
          try {
            await handleRefresh();
            final newToken = await storage.read(StorageKeys.token);
            if (newToken == null) {
              return handler.next(error);
            }
            final request = error.requestOptions;
            final response = await dio.fetch(
              request.copyWith(
                headers: {
                  ...request.headers,
                  'Authorization': 'Bearer $newToken',
                },
                extra: {
                  ...request.extra,
                  'retried': true,
                },
              ),
            );

            return handler.resolve(response);
          } catch (_) {
            return handler.next(error);
          }
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}