import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'api.dart';
import '../storage/storage_keys.dart';

class DioClient extends Api {
  final AppSecureStorage storage;
  final Future<Map<String, dynamic>?> Function() refreshToken;
  Future<void>? _refreshFuture;

  DioClient({required this.storage, required this.refreshToken}) : super() {
    dio.interceptors.clear();

    Future<void> doRefresh() async {
      print('🟢 Starting refresh...');
      try {
        final storedRefresh = await storage.read(StorageKeys.refreshToken);
        print('🟢 Refresh response: $storedRefresh');
        if (storedRefresh == null || storedRefresh.isEmpty) return;

        final data = await refreshToken();
        if (data != null) {
          final newAccess = data['accessToken'];
          final newRefresh = data['refreshToken'];
          if (newAccess != null)
            await storage.write(StorageKeys.token, newAccess);
          if (newRefresh != null)
            await storage.write(StorageKeys.refreshToken, newRefresh);
        }
      } catch (e) {
        print('🔴 Refresh failed: $e');
        await storage.delete(StorageKeys.token);
        await storage.delete(StorageKeys.refreshToken);
        rethrow;
      } finally {
        _refreshFuture = null;
      }
    }

    Future<void> handleRefresh() {
      if (_refreshFuture != null) {
        print(
          '🟡 handleRefresh() -> reusing EXISTING refresh future (race avoided)',
        );
      } else {
        print('🟡 handleRefresh() -> starting NEW refresh future');
      }
      return _refreshFuture ??= doRefresh();
    }

    bool shouldRefresh(String? token) {
      if (token == null || token.isEmpty) return false;
      try {
        final expired = JwtDecoder.isExpired(token);
        final remaining = JwtDecoder.getRemainingTime(token).inSeconds;
        final result = expired || remaining < 60;
        print(
          '🟣 shouldRefresh: expired=$expired, remaining=${remaining}s, result=$result',
        );
        return result;
      } catch (e) {
        print('❌ shouldRefresh EXCEPTION: $e');
        return false;
      }
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('➡️ REQUEST: ${options.method} ${options.path}');
          options.headers.addAll({
            'User-Agent': 'Flutter-Mobile-App',
            'X-Platform': 'mobile',
            'isWeb': 'false',
            'Accept': 'application/json',
          });
          final noAuth = options.extra['noAuth'] == true;
          if (!noAuth) {
            final token = await storage.read(StorageKeys.token);
            print(
              '➡️ [${options.path}] current access token = ${token == null ? "NULL" : "present (len=${token.length})"}',
            );
            if (token != null && token.isNotEmpty) {
              if (shouldRefresh(token)) {
                print(
                  '⚠️ [${options.path}] Token needs refresh, calling handleRefresh()',
                );
                await handleRefresh();
              }
              final updatedToken = await storage.read(StorageKeys.token);
              if (updatedToken != null && updatedToken.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $updatedToken';
              }
            }
          } else {
            print('➡️ [${options.path}] noAuth=true, skipping token logic');
          }
          print('➡️ Headers:');
          options.headers.forEach((key, value) {
            print('   $key: $value');
          });
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          print(
            '🔴 ERROR: ${error.requestOptions.path} -> status=${error.response?.statusCode}',
          );
          print('🔴 Response body: ${error.response?.data}');

          final is401 = error.response?.statusCode == 401;
          final retried = error.requestOptions.extra['retried'] == true;
          final noAuth = error.requestOptions.extra['noAuth'] == true;

          final responseData = error.response?.data;

          String? errorType;
          if (responseData is Map<String, dynamic>) {
            errorType = responseData['error']?.toString();
          }

          final isTokenAuthError = errorType == 'UnauthorizedException';

          print(
            '🔴 [${error.requestOptions.path}] '
            'is401=$is401, '
            'errorType=$errorType, '
            'isTokenAuthError=$isTokenAuthError, '
            'retried=$retried, '
            'noAuth=$noAuth',
          );

          if (!is401 || !isTokenAuthError || retried || noAuth) {
            return handler.next(error);
          }

          try {
            print(
              '🔁 [${error.requestOptions.path}] Attempting refresh + retry...',
            );

            await handleRefresh();

            final newToken = await storage.read(StorageKeys.token);

            if (newToken == null || newToken.isEmpty) {
              print('🔴 No new token after refresh');
              return handler.next(error);
            }

            final request = error.requestOptions;

            final response = await dio.fetch(
              request.copyWith(
                headers: {
                  ...request.headers,
                  'Authorization': 'Bearer $newToken',
                },
                extra: {...request.extra, 'retried': true},
              ),
            );

            return handler.resolve(response);
          } catch (e) {
            print('❌ Retry failed: $e');
            return handler.next(error);
          }
        },
      ),
    );
  }
}
