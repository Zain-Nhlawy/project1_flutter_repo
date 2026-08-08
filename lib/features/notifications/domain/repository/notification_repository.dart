import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> registerFcmToken({
    required String token,
    required String deviceModel,
  });
}
