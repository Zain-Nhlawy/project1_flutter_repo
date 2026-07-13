import 'package:dio/dio.dart';
import 'exceptions.dart';

AppException mapDioException(DioException exception) {
  switch (exception.type) {

    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkException(
        'No internet connection. Please try again.',
      );


    case DioExceptionType.badCertificate:
      return const ServerException(
        'Could not verify server identity.',
      );


    case DioExceptionType.cancel:
      return const UnknownException(
        'Request was cancelled.',
      );


    case DioExceptionType.badResponse:

      final statusCode = exception.response?.statusCode;
      final data = exception.response?.data;

      final rawMessage =
          data is Map ? data['message'] : null;


      String message = 'Unexpected server error.';
      List<String>? errors;


      if (rawMessage is List) {
        errors = List<String>.from(rawMessage);
        message = errors.first;
      }

      else if (rawMessage != null) {
        message = rawMessage.toString();
      }


      switch (statusCode) {

        case 400:
          return ServerException(
            message,
            errors: errors,
          );


        case 401:
          return UnauthorizedException(
            message,
          );


        case 403:
          return UnauthorizedException(
            message,
          );


        case 404:
          return NotFoundException(
            message,
          );


        case 500:
        case 502:
        case 503:
          return ServerException(
            message,
          );


        default:
          return ServerException(
            message,
          );
      }


    case DioExceptionType.unknown:
    default:
      return UnknownException(
        exception.message ?? 'Unexpected error.',
      );
  }
}