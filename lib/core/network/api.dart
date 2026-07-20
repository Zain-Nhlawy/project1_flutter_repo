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
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );
  }
}
