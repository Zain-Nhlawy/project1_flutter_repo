import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';

abstract class DemoPaymentDataSource {
  Future<String> requestPayment(String demoId, String plan);
  Future<String> confirmPayment(String sessionId);
}

class DemoPaymentDataSourceImpl implements DemoPaymentDataSource {
  final Dio dio;

  DemoPaymentDataSourceImpl(DioClient dioClient, {required this.dio});

  @override
  Future<String> requestPayment(String demoId, String plan) async {
    final response = await dio.post(
      '/payments/checkout/demo',
      data: {'demoId': demoId, 'plan': plan},
    );

    final statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode >= 300) {
      throw Exception(
        'Payment request failed with status $statusCode: ${response.data}',
      );
    }

    var body = response.data;

    if (body is String) {
      throw Exception(
        'Expected JSON object but got a raw String response. '
        'Check your DioClient responseType / Content-Type header. Raw body: $body',
      );
    }

    if (body is! Map) {
      throw Exception(
        'Unexpected response type: ${body.runtimeType}. Raw body: $body',
      );
    }

    final data = body['data'];
    if (data is! Map) {
      throw Exception(
        'Missing or invalid "data" field in response. Full body: $body',
      );
    }

    final url = data['url'];
    if (url is! String || url.isEmpty) {
      throw Exception(
        'Missing or invalid "url" field inside "data". Full body: $body',
      );
    }

    return url;
  }

  @override
  Future<String> confirmPayment(String sessionId) async {
    final response = await dio.get(
      '/payments/checkout/status',
      queryParameters: {'session_id': sessionId},
    );

    final statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode >= 300) {
      throw Exception(
        'Payment confirmation failed with status $statusCode: ${response.data}',
      );
    }

    var body = response.data;

    if (body is String) {
      throw Exception(
        'Expected JSON object but got a raw String response. '
        'Check your DioClient responseType / Content-Type header. Raw body: $body',
      );
    }

    if (body is! Map) {
      throw Exception(
        'Unexpected response type: ${body.runtimeType}. Raw body: $body',
      );
    }

    final data = body['data'];
    if (data is! Map) {
      throw Exception(
        'Missing or invalid "data" field in response. Full body: $body',
      );
    }

    final status = data['status'];
    if (status is! String || status.isEmpty) {
      throw Exception(
        'Missing or invalid "status" field inside "data". Full body: $body',
      );
    }

    return status;
  }
}