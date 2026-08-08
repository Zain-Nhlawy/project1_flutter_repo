import 'package:project1/features/quiz/data/models/submit_exam_attempt_result_model.dart';
import 'package:project1/features/quiz/domain/entities/generated_exam_entity.dart';

abstract class ExamTakingState {
  const ExamTakingState();
}

class ExamTakingInitial extends ExamTakingState {
  const ExamTakingInitial();
}

class ExamTakingLoading extends ExamTakingState {
  const ExamTakingLoading();
}

class ExamTakingError extends ExamTakingState {
  final String message;

  const ExamTakingError(this.message);
}

class ExamTakingInProgress extends ExamTakingState {
  final GeneratedExamEntity exam;
  final Map<String, Set<String>> selectedAnswers;
  final int currentQuestionIndex;
  final int remainingSeconds;
  final bool isSubmitting;

  const ExamTakingInProgress({
    required this.exam,
    required this.selectedAnswers,
    required this.currentQuestionIndex,
    required this.remainingSeconds,
    this.isSubmitting = false,
  });

  ExamTakingInProgress copyWith({
    GeneratedExamEntity? exam,
    Map<String, Set<String>>? selectedAnswers,
    int? currentQuestionIndex,
    int? remainingSeconds,
    bool? isSubmitting,
  }) {
    return ExamTakingInProgress(
      exam: exam ?? this.exam,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      currentQuestionIndex:
          currentQuestionIndex ?? this.currentQuestionIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ExamTakingSubmitted extends ExamTakingState {
  final SubmitExamAttemptResultModel result;
  final Map<String, Set<String>> selectedAnswers;

  const ExamTakingSubmitted(
    this.result,
    this.selectedAnswers,
  );
}