import 'package:project1/features/quiz/data/models/exam_model.dart';

abstract class ExamState  {
  const ExamState();
}

class ExamInitial extends ExamState {
  const ExamInitial();
}

class ExamLoading extends ExamState {
  const ExamLoading();
}

class ExamError extends ExamState {
  final String message;

  const ExamError(this.message);
}

class ExamLoaded extends ExamState {
  final List<ExamModel> exams;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMore;

  const ExamLoaded({
    required this.exams,
    required this.hasNextPage,
    required this.endCursor,
    this.isLoadingMore = false,
  });

  ExamLoaded copyWith({
    List<ExamModel>? exams,
    bool? hasNextPage,
    String? endCursor,
    bool? isLoadingMore,
  }) {
    return ExamLoaded(
      exams: exams ?? this.exams,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor ?? this.endCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}