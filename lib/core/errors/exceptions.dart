/// Base Exception
abstract class AppException implements Exception {
  final String message;
  final List<String>? errors;

  const AppException(this.message, {this.errors});

  @override
  String toString() => message;
}

/// Server
class ServerException extends AppException {
  const ServerException(super.message, {super.errors});
}

/// Network
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Unauthorized
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

/// Cache
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

/// Not Found
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

///Bad Request
class BadRequestException extends AppException {
  const BadRequestException(super.message, {super.errors});
}

/// Unknown
class UnknownException extends AppException {
  const UnknownException([super.message = 'Unexpected error']);
}
