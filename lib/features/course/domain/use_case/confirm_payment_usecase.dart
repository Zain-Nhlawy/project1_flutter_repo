import 'package:dartz/dartz.dart';
import 'package:project1/features/course/domain/repository/payment_repository.dart';
import '../../../../core/errors/failures.dart';

class ConfirmPaymentUseCase {
  final PaymentRepository repository;

  ConfirmPaymentUseCase(this.repository);

  Future<Either<Failure, String>> call({required String sessionId}) {
    return repository.confirmPayment(sessionId: sessionId);
  }
}