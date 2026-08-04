import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/data/data_sources/payment_remote_data_source.dart';
import 'package:project1/features/course/domain/repository/payment_repository.dart';
import '../../domain/entities/checkout_session_entity.dart';


class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CheckoutSessionEntity>> checkoutCourse({
    required String demoId,
    required String courseId,
  }) {
    return _handle(
      () => remoteDataSource.checkoutCourse(demoId: demoId, courseId: courseId),
    );
  }

  @override
  Future<Either<Failure, String>> confirmPayment({
    required String sessionId,
  }) {
    return _handle(
      () => remoteDataSource.confirmPayment(sessionId),
    );
  }

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}