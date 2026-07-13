abstract class Failure {
  final String message;
  final List<String>? errors;

  const Failure(
    this.message, {
    this.errors,
  });
}


class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Server error',
  ]);
}


class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection',
  ]);
}


class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Unauthorized',
  ]);
}


class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Cache error',
  ]);
}


class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'Resource not found',
  ]);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(
    super.message, {
    super.errors,
  });
}


class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Unexpected error',
  ]);
}