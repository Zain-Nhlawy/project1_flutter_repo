import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/core/storage/storage_keys.dart';

import '../../helpers/auth_test_fakes.dart';

void main() {
  setUpAll(() {
    dotenv.loadFromString(envString: 'BASE_URL=https://example.test');
  });

  test('uses a refresh token when the access token is missing', () async {
    final storage = FakeSecureStorage({
      StorageKeys.refreshToken: 'old-refresh-token',
    });
    final adapter = RecordingAdapter();
    var refreshCount = 0;
    final client = DioClient(
      storage: storage,
      refreshToken: () async {
        refreshCount++;
        return {
          'accessToken': 'new-access-token',
          'refreshToken': 'new-refresh-token',
        };
      },
    );
    client.dio.httpClientAdapter = adapter;

    await client.dio.get('/protected');

    expect(refreshCount, 1);
    expect(
      adapter.lastRequest?.headers['Authorization'],
      'Bearer new-access-token',
    );
    expect(storage.values[StorageKeys.token], 'new-access-token');
    expect(storage.values[StorageKeys.refreshToken], 'new-refresh-token');
  });

  test('does not delete credentials for a refresh network failure', () async {
    final storage = FakeSecureStorage({
      StorageKeys.token: 'invalid-access-token',
      StorageKeys.refreshToken: 'stored-refresh-token',
    });
    final client = DioClient(
      storage: storage,
      refreshToken: () async {
        final options = RequestOptions(path: '/authentication/refresh-tokens');
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
        );
      },
    );
    client.dio.httpClientAdapter = RecordingAdapter();

    await expectLater(client.dio.get('/protected'), throwsA(isA<Object>()));

    expect(storage.values[StorageKeys.token], 'invalid-access-token');
    expect(storage.values[StorageKeys.refreshToken], 'stored-refresh-token');
  });

  test('clears credentials when the refresh token is rejected', () async {
    final storage = FakeSecureStorage({
      StorageKeys.token: 'invalid-access-token',
      StorageKeys.refreshToken: 'rejected-refresh-token',
    });
    var expirationNotifications = 0;
    final client = DioClient(
      storage: storage,
      refreshToken: () async {
        final options = RequestOptions(path: '/authentication/refresh-tokens');
        throw DioException.badResponse(
          statusCode: 401,
          requestOptions: options,
          response: Response<void>(requestOptions: options, statusCode: 401),
        );
      },
      onSessionExpired: () async {
        expirationNotifications++;
      },
    );
    client.dio.httpClientAdapter = RecordingAdapter();

    await expectLater(client.dio.get('/protected'), throwsA(isA<Object>()));

    expect(storage.values[StorageKeys.token], isNull);
    expect(storage.values[StorageKeys.refreshToken], isNull);
    expect(expirationNotifications, 1);
  });
}

class RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
