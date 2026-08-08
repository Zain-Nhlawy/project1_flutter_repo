import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';

abstract class ExamAttemptReviewState {
  const ExamAttemptReviewState();
}

class ExamAttemptReviewInitial extends ExamAttemptReviewState {
  const ExamAttemptReviewInitial();
}

class ExamAttemptReviewLoading extends ExamAttemptReviewState {
  const ExamAttemptReviewLoading();
}

class ExamAttemptReviewError extends ExamAttemptReviewState {
  final String message;

  const ExamAttemptReviewError(this.message);
}

class ExamAttemptReviewLoaded extends ExamAttemptReviewState {
  final ExamAttemptModel attempt;

  const ExamAttemptReviewLoaded(this.attempt);
}