import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/answer_submission_model.dart';
import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';
import 'package:project1/features/quiz/data/models/generated_exam_model.dart';
import 'package:project1/features/quiz/data/models/paginated_exam_attempts.dart';
import 'package:project1/features/quiz/data/models/submit_exam_attempt_result_model.dart';

abstract class ExamAttemptRepository {
  Future<Either<Failure, GeneratedExamModel>> generateExamAttempt({
    required String examId,
  });

  Future<Either<Failure, SubmitExamAttemptResultModel>> submitExamAttempt({
    required String examId,
    required String demoId,
    required List<AnswerSubmissionModel> answers,
  });

  Future<Either<Failure, PaginatedExamAttempts>> getExamAttempts({
    String? cursor,
  });

  Future<Either<Failure, ExamAttemptModel>> getExamAttempt({
    required String attemptId,
  });

  Future<Either<Failure, void>> deleteExamAttempt({
    required String attemptId,
  });
}