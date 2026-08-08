import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/data_sources/exam_attempt_remote_data_source.dart';
import 'package:project1/features/quiz/data/models/answer_submission_model.dart';
import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';
import 'package:project1/features/quiz/data/models/generated_exam_model.dart';
import 'package:project1/features/quiz/data/models/paginated_exam_attempts.dart';
import 'package:project1/features/quiz/data/models/submit_exam_attempt_result_model.dart';
import 'package:project1/features/quiz/domain/repositories/exam_attempt_repository.dart';

class ExamAttemptRepositoryImpl implements ExamAttemptRepository {
  final ExamAttemptRemoteDataSource remoteDataSource;

  ExamAttemptRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, GeneratedExamModel>> generateExamAttempt({
    required String examId,
  }) async {
    try {
      final result =
          await remoteDataSource.generateExamAttempt(examId: examId);
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SubmitExamAttemptResultModel>> submitExamAttempt({
    required String examId,
    required String demoId,
    required List<AnswerSubmissionModel> answers,
  }) async {
    try {
      final result = await remoteDataSource.submitExamAttempt(
        examId: examId,
        demoId: demoId,
        answers: answers,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedExamAttempts>> getExamAttempts({
    String? cursor,
  }) async {
    try {
      final result = await remoteDataSource.getExamAttempts(cursor: cursor);
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExamAttemptModel>> getExamAttempt({
    required String attemptId,
  }) async {
    try {
      final result =
          await remoteDataSource.getExamAttempt(attemptId: attemptId);
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExamAttempt({
    required String attemptId,
  }) async {
    try {
      await remoteDataSource.deleteExamAttempt(attemptId: attemptId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}