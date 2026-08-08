import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/answer_submission_model.dart';
import 'package:project1/features/quiz/data/models/submit_exam_attempt_result_model.dart';
import 'package:project1/features/quiz/domain/repositories/exam_attempt_repository.dart';

class SubmitExamAttemptUseCase {
  final ExamAttemptRepository repository;

  SubmitExamAttemptUseCase(this.repository);

  Future<Either<Failure, SubmitExamAttemptResultModel>> call({
    required String examId,
    required String demoId,
    required List<AnswerSubmissionModel> answers,
  }) {
    return repository.submitExamAttempt(examId: examId, answers: answers, demoId: demoId);
  }
}