import 'package:dartz/dartz.dart';

abstract class DemoPaymentRepository {
  Future<Either<String, String>> requestPayment(String demoId, String plan);
}
