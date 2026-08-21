import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/domain/repository/demo_payment_repository.dart';

class DemoPaymentUseCase {
  final DemoPaymentRepository repository;

  DemoPaymentUseCase(this.repository);

  Future<Either<String, String>> requestPayment(String demoId, String plan) {
    return repository.requestPayment(demoId, plan);
  }

  Future<Either<String, String>> confirmPayment(String sessionId) {
    return repository.confirmPayment(sessionId);
  }

  Future<Either<String, String>> manageSubscription(String demoId) {
    return repository.manageSubscription(demoId);
  }
}
