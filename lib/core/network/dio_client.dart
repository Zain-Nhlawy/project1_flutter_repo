import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:project1/core/services/app_language_service.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'api.dart';
import '../storage/storage_keys.dart';

class DioClient extends Api {
  final AppSecureStorage storage;
  final AppLanguageService languageService;
  final Future<Map<String, dynamic>?> Function() refreshToken;
  final Future<void> Function()? onSessionExpired;

  Future<void>? _refreshFuture;

  DioClient({
    required this.storage,
    required this.languageService,
    required this.refreshToken,
    this.onSessionExpired,
  }) : super() {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.addAll({
            'User-Agent': 'Flutter-Mobile-App',
            'X-Platform': 'mobile',
            'isWeb': 'false',
            'Accept': 'application/json',
          });
          options.headers['Accept-Language'] = languageService.currentLanguage;

          if (options.extra['noAuth'] != true) {
            final accessToken = await storage.read(StorageKeys.token);
            final storedRefreshToken = await storage.read(
              StorageKeys.refreshToken,
            );
            final canRefresh =
                storedRefreshToken != null && storedRefreshToken.isNotEmpty;
            final needsRefresh =
                accessToken == null ||
                accessToken.isEmpty ||
                _shouldRefresh(accessToken);

            if (canRefresh && needsRefresh) {
              await _handleRefresh();
            }

            final updatedAccessToken = await storage.read(StorageKeys.token);
            if (updatedAccessToken != null && updatedAccessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $updatedAccessToken';
            }
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final wasRetried = error.requestOptions.extra['retried'] == true;
          final skipsAuthentication =
              error.requestOptions.extra['noAuth'] == true;
          final isRefreshRequest = error.requestOptions.path.endsWith(
            '/authentication/refresh-tokens',
          );

          if (!isUnauthorized ||
              wasRetried ||
              skipsAuthentication ||
              isRefreshRequest) {
            handler.next(error);
            return;
          }

          try {
            await _handleRefresh();

            final newAccessToken = await storage.read(StorageKeys.token);
            if (newAccessToken == null || newAccessToken.isEmpty) {
              handler.next(error);
              return;
            }

            final request = error.requestOptions;
            final response = await dio.fetch(
              request.copyWith(
                headers: {
                  ...request.headers,
                  'Authorization': 'Bearer $newAccessToken',
                },
                extra: {...request.extra, 'retried': true},
              ),
            );

            handler.resolve(response);
          } catch (_) {
            handler.next(error);
          }
        },
      ),
    );
  }

  Future<void> _handleRefresh() {
    return _refreshFuture ??= _refreshAccessToken();
  }

  Future<void> _refreshAccessToken() async {
    try {
      final storedRefreshToken = await storage.read(StorageKeys.refreshToken);
      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        await _expireSession();
        throw StateError('No refresh token is available.');
      }

      final data = await refreshToken();
      final newAccessToken = data?['accessToken'];
      final newRefreshToken = data?['refreshToken'];

      if (newAccessToken is! String ||
          newAccessToken.isEmpty ||
          newRefreshToken is! String ||
          newRefreshToken.isEmpty) {
        throw StateError('The token refresh response is incomplete.');
      }

      // Store the rotated refresh token first. If the app is interrupted
      // between writes, the next launch can still obtain a new access token.
      await storage.write(StorageKeys.refreshToken, newRefreshToken);
      await storage.write(StorageKeys.token, newAccessToken);
    } catch (error) {
      if (_isRejectedRefresh(error)) {
        await _expireSession();
      }
      rethrow;
    } finally {
      _refreshFuture = null;
    }
  }

  bool _shouldRefresh(String token) {
    try {
      return JwtDecoder.isExpired(token) ||
          JwtDecoder.getRemainingTime(token).inSeconds < 60;
    } catch (_) {
      return true;
    }
  }

  bool _isRejectedRefresh(Object error) {
    if (error is! DioException) return false;
    final statusCode = error.response?.statusCode;
    return statusCode == 400 || statusCode == 401 || statusCode == 403;
  }

  Future<void> _expireSession() async {
    await storage.delete(StorageKeys.token);
    await storage.delete(StorageKeys.refreshToken);
    await onSessionExpired?.call();
  }
}
