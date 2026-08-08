import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/quiz/domain/use_case/delete_exam_attempt_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/get_exam_attempts_usecase.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_attempts_history_state.dart';

class ExamAttemptsHistoryCubit extends Cubit<ExamAttemptsHistoryState> {
  final GetExamAttemptsUseCase getExamAttemptsUseCase;
  final DeleteExamAttemptUseCase deleteExamAttemptUseCase;

  ExamAttemptsHistoryCubit({
    required this.getExamAttemptsUseCase,
    required this.deleteExamAttemptUseCase,
  }) : super(const ExamAttemptsHistoryInitial());

  Future<void> fetchAttempts() async {
    emit(const ExamAttemptsHistoryLoading());

    final result = await getExamAttemptsUseCase();

    result.fold(
      (failure) => emit(ExamAttemptsHistoryError(failure.message)),
      (data) => emit(
        ExamAttemptsHistoryLoaded(
          attempts: data.data,
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ExamAttemptsHistoryLoaded) return;
    if (!currentState.hasNextPage || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getExamAttemptsUseCase(cursor: currentState.endCursor);

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (data) => emit(
        currentState.copyWith(
          attempts: [...currentState.attempts, ...data.data],
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<bool> deleteAttempt({required String attemptId}) async {
    final result = await deleteExamAttemptUseCase(attemptId: attemptId);

    return result.fold(
      (failure) => false,
      (_) {
        final currentState = state;
        if (currentState is ExamAttemptsHistoryLoaded) {
          emit(
            currentState.copyWith(
              attempts: currentState.attempts
                  .where((a) => a.id != attemptId)
                  .toList(),
            ),
          );
        }
        return true;
      },
    );
  }
}