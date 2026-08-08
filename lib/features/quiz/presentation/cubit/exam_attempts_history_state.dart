import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';

abstract class ExamAttemptsHistoryState {
  const ExamAttemptsHistoryState();
}

class ExamAttemptsHistoryInitial extends ExamAttemptsHistoryState {
  const ExamAttemptsHistoryInitial();
}

class ExamAttemptsHistoryLoading extends ExamAttemptsHistoryState {
  const ExamAttemptsHistoryLoading();
}

class ExamAttemptsHistoryError extends ExamAttemptsHistoryState {
  final String message;

  const ExamAttemptsHistoryError(this.message);
}

class ExamAttemptsHistoryLoaded extends ExamAttemptsHistoryState {
  final List<ExamAttemptModel> attempts;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMore;

  const ExamAttemptsHistoryLoaded({
    required this.attempts,
    required this.hasNextPage,
    required this.endCursor,
    this.isLoadingMore = false,
  });

  ExamAttemptsHistoryLoaded copyWith({
    List<ExamAttemptModel>? attempts,
    bool? hasNextPage,
    String? endCursor,
    bool? isLoadingMore,
  }) {
    return ExamAttemptsHistoryLoaded(
      attempts: attempts ?? this.attempts,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor ?? this.endCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
