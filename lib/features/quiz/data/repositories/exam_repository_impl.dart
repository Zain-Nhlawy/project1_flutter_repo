import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/data_sources/exam_remote_data_source.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/data/models/paginated_exams.dart';
import 'package:project1/features/quiz/domain/repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSource remoteDataSource;

  ExamRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ExamModel>> createExam({
    required String sectionId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
    required int passingScore,
  }) async {
    try {
      final result = await remoteDataSource.createExam(
        sectionId: sectionId,
        title: title,
        numberOfQuestions: numberOfQuestions,
        durationMinutes: durationMinutes,
        passingScore: passingScore,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedExams>> getExams({
    required String sectionId,
    String? cursor,
  }) async {
    try {
      final result = await remoteDataSource.getExams(
        sectionId: sectionId,
        cursor: cursor,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExamModel>> getExam({
    required String sectionId,
    required String examId,
  }) async {
    try {
      final result = await remoteDataSource.getExam(
        sectionId: sectionId,
        examId: examId,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExamModel>> updateExam({
    required String sectionId,
    required String examId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
    required int passingScore,
  }) async {
    try {
      final result = await remoteDataSource.updateExam(
        sectionId: sectionId,
        examId: examId,
        title: title,
        numberOfQuestions: numberOfQuestions,
        durationMinutes: durationMinutes,
        passingScore: passingScore,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExam({
    required String sectionId,
    required String examId,
  }) async {
    try {
      await remoteDataSource.deleteExam(sectionId: sectionId, examId: examId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}