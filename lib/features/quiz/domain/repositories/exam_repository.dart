import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/data/models/paginated_exams.dart';

abstract class ExamRepository {
  Future<Either<Failure, ExamModel>> createExam({
    required String sectionId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
    required int passingScore,
  });

  Future<Either<Failure, PaginatedExams>> getExams({
    required String sectionId,
    String? cursor,
  });

  Future<Either<Failure, ExamModel>> getExam({
    required String sectionId,
    required String examId,
  });

  Future<Either<Failure, ExamModel>> updateExam({
    required String sectionId,
    required String examId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
    required int passingScore,
  });

  Future<Either<Failure, void>> deleteExam({
    required String sectionId,
    required String examId,
  });
}