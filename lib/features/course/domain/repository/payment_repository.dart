import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../entities/checkout_session_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, CheckoutSessionEntity>> checkoutCourse({
    required String demoId,
    required String courseId,
  });
}