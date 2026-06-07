import 'package:dio/dio.dart';
import 'package:project1/core/di/service_locator.dart';


class Api {
  late Dio dio;

  Api() {
    dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        validateStatus: (status) => status != null && status < 500,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );
  }

  String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timed out. Please check your internet.";

        case DioExceptionType.sendTimeout:
          return "Send timeout. Request took too long to leave the device.";

        case DioExceptionType.receiveTimeout:
          return "Receive timeout. Server took too long to respond.";

        case DioExceptionType.badCertificate:
          return "Bad certificate. Server identity could not be verified.";

        case DioExceptionType.connectionError:
          return "Network connection failed. Details: ${error.error ?? error.message}";

        case DioExceptionType.unknown:
          return "Unexpected error: ${error.error ?? 'Unknown system error'}";

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final data = error.response?.data;
          if (data is Map && data.containsKey('message')) {
            return "خطأ من السيرفر ($statusCode): ${data['message']}";
          }
          return "Server error ($statusCode): ${data ?? 'Unknown error'}";

        case DioExceptionType.cancel:
          return "Request was cancelled.";
      }
    }

    return "Unknown error occurred";
  }
}