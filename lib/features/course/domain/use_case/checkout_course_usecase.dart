import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/repository/payment_repository.dart';
import '../entities/checkout_session_entity.dart';

class CheckoutCourseUseCase {
  final PaymentRepository repository;

  CheckoutCourseUseCase(this.repository);

  Future<Either<Failure, CheckoutSessionEntity>> call({
    required String demoId,
    required String courseId,
  }) {
    return repository.checkoutCourse(demoId: demoId, courseId: courseId);
  }
}