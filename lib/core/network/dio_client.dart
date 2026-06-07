import 'package:dio/dio.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'api.dart';
import '../storage/storage_keys.dart';

class DioClient extends Api {
  final AppSecureStorage storage;
  final Future<String?> Function() refreshToken;
  final Future<void> Function() refreshIfNeeded;

  DioClient({
    required this.storage,
    required this.refreshToken,
    required this.refreshIfNeeded,
  }) : super() {
    dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

    dio.interceptors.clear();

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.addAll({
            'User-Agent': 'Flutter-Mobile-App',
            'X-Platform': 'mobile',
            'isWeb': 'false',
            'Accept': 'application/json',
          });

          final noAuth = options.extra['noAuth'] == true;

          if (!noAuth) {
            await refreshIfNeeded();

            final token = await storage.read(StorageKeys.token);

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          final is401 = error.response?.statusCode == 401;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;
          final noAuth = error.requestOptions.extra['noAuth'] == true;

          if (!is401 || alreadyRetried || noAuth) {
            return handler.next(error);
          }

          try {
            final newToken = await refreshToken();

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