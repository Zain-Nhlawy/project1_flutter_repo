import 'package:dartz/dartz.dart';

import 'package:project1/features/demo/data/data_sources/demo_payment_data_source.dart';
import 'package:project1/features/demo/domain/repository/demo_payment_repository.dart'; 

class DemoPaymentRepositoryImpl implements DemoPaymentRepository {
  final DemoPaymentDataSource demoPaymentDataSource;
  
  DemoPaymentRepositoryImpl({required this.demoPaymentDataSource});

  @override
  Future<Either<String, String>> requestPayment(String demoId, String plan) async {
    try {
      final result = await demoPaymentDataSource.requestPayment(demoId, plan);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> confirmPayment(String sessionId) async {
    try {
      final result = await demoPaymentDataSource.confirmPayment(sessionId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}