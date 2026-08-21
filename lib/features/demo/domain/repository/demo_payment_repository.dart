import 'package:dartz/dartz.dart';

abstract class DemoPaymentRepository {
  Future<Either<String, String>> requestPayment(String demoId, String plan);
  Future<Either<String, String>> confirmPayment(String sessionId);
  Future<Either<String, String>> manageSubscription(String demoId);
}
