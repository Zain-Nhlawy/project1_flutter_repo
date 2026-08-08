import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/quiz/domain/use_case/get_exam_attempt_usecase.dart';
import 'exam_attempt_review_state.dart';

class ExamAttemptReviewCubit extends Cubit<ExamAttemptReviewState> {
  final GetExamAttemptUseCase getExamAttemptUseCase;

  ExamAttemptReviewCubit({
    required this.getExamAttemptUseCase,
  }) : super(const ExamAttemptReviewInitial());

  Future<void> getExamAttempt(String attemptId) async {
    emit(const ExamAttemptReviewLoading());

    final result = await getExamAttemptUseCase(
      attemptId: attemptId,
    );

    result.fold(
      (failure) => emit(
        ExamAttemptReviewError(failure.message),
      ),
      (data) => emit(
        ExamAttemptReviewLoaded(data),
      ),
    );
  }
}