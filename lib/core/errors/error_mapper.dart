import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Exception exception) {
  switch (exception) {
    case ServerException():
      return ServerFailure(exception.message);

    case NetworkException():
      return NetworkFailure(exception.message);

    case UnauthorizedException():
      return UnauthorizedFailure(exception.message);

    case CacheException():
      return CacheFailure(exception.message);

    case NotFoundException():
      return NotFoundFailure(exception.message);

    case BadRequestException():
      return BadRequestFailure(
        exception.message,
        errors: exception.errors,
    );

    default:
      return const UnknownFailure();
  }
}