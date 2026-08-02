import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/rag/data/data_sources/rag_remote_data_source.dart';
import 'package:project1/features/rag/domain/repositories/rag_repository.dart';

class RagRepositoryImpl implements RagRepository {
  final RagRemoteDataSource remoteDataSource;

  RagRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, dynamic>> askQuestion({
    required String courseId,
    required String question,
  }) async {
    try {
      final result = await remoteDataSource.askQuestion(
        courseId: courseId,
        question: question,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, dynamic>> generateTopicQuiz({
    required String courseId,
    required String topic,
    required int questionCount,
  }) async {
    try {
      final result = await remoteDataSource.generateTopicQuiz(
        courseId: courseId,
        topic: topic,
        questionCount: questionCount,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, dynamic>> generateRandomQuiz({
    required String courseId,
    required int questionCount,
  }) async {
    try {
      final result = await remoteDataSource.generateRandomQuiz(
        courseId: courseId,
        questionCount: questionCount,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}