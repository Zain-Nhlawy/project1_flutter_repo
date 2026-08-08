import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/quiz/data/models/answer_submission_model.dart';
import 'package:project1/features/quiz/domain/use_case/generate_exam_attempt_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/submit_exam_attempt_usecase.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_taking_state.dart';

class ExamTakingCubit extends Cubit<ExamTakingState> {
  final GenerateExamAttemptUseCase generateExamAttemptUseCase;
  final SubmitExamAttemptUseCase submitExamAttemptUseCase;

  Timer? _timer;

  ExamTakingCubit({
    required this.generateExamAttemptUseCase,
    required this.submitExamAttemptUseCase,
  }) : super(const ExamTakingInitial());

  Future<void> startExam({
    required String examId,
    required String demoId,
  }) async {
    emit(const ExamTakingLoading());

    final result = await generateExamAttemptUseCase(
      examId: examId,
    );

    result.fold(
      (failure) {
        emit(
          ExamTakingError(failure.message),
        );
      },
      (exam) {
        emit(
          ExamTakingInProgress(
            exam: exam,
            selectedAnswers: const {},
            currentQuestionIndex: 0,
            remainingSeconds: exam.durationMinutes * 60,
            isSubmitting: false,
          ),
        );

        _startTimer(
          examId: examId,
          demoId: demoId,
        );
      },
    );
  }

  void _startTimer({
    required String examId,
    required String demoId,
  }) {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final currentState = state;

        if (currentState is! ExamTakingInProgress) {
          _timer?.cancel();
          return;
        }

        if (currentState.isSubmitting) {
          _timer?.cancel();
          return;
        }

        if (currentState.remainingSeconds <= 1) {
          _timer?.cancel();

          emit(
            currentState.copyWith(
              remainingSeconds: 0,
            ),
          );

          submitExam(
            examId: examId,
            demoId: demoId,
          );

          return;
        }

        emit(
          currentState.copyWith(
            remainingSeconds:
                currentState.remainingSeconds - 1,
          ),
        );
      },
    );
  }

  void toggleAnswer({
    required String questionId,
    required String choiceId,
  }) {
    final currentState = state;

    if (currentState is! ExamTakingInProgress) {
      return;
    }

    if (currentState.isSubmitting) {
      return;
    }

    final updatedAnswers =
        <String, Set<String>>{
      ...currentState.selectedAnswers,
    };

    final currentQuestionAnswers =
        <String>{
      ...(updatedAnswers[questionId] ?? <String>{}),
    };

    if (currentQuestionAnswers.contains(choiceId)) {
      currentQuestionAnswers.remove(choiceId);
    } else {
      currentQuestionAnswers.add(choiceId);
    }

    if (currentQuestionAnswers.isEmpty) {
      updatedAnswers.remove(questionId);
    } else {
      updatedAnswers[questionId] =
          currentQuestionAnswers;
    }

    emit(
      currentState.copyWith(
        selectedAnswers: updatedAnswers,
      ),
    );
  }

  void nextQuestion() {
    final currentState = state;

    if (currentState is! ExamTakingInProgress) {
      return;
    }

    if (currentState.isSubmitting) {
      return;
    }

    final currentIndex =
        currentState.currentQuestionIndex;

    final lastIndex =
        currentState.exam.questions.length - 1;

    if (currentIndex >= lastIndex) {
      return;
    }

    emit(
      currentState.copyWith(
        currentQuestionIndex: currentIndex + 1,
      ),
    );
  }

  void previousQuestion() {
    final currentState = state;

    if (currentState is! ExamTakingInProgress) {
      return;
    }

    if (currentState.isSubmitting) {
      return;
    }

    if (currentState.currentQuestionIndex <= 0) {
      return;
    }

    emit(
      currentState.copyWith(
        currentQuestionIndex:
            currentState.currentQuestionIndex - 1,
      ),
    );
  }

  Future<void> submitExam({
    required String examId,
    required String demoId,
  }) async {
    final currentState = state;

    if (currentState is! ExamTakingInProgress) {
      return;
    }

    if (currentState.isSubmitting) {
      return;
    }

    _timer?.cancel();

    emit(
      currentState.copyWith(
        isSubmitting: true,
      ),
    );

    final answers =
        currentState.selectedAnswers.entries
            .map(
              (entry) => AnswerSubmissionModel(
                questionId: entry.key,
                selectedChoiceIds:
                    entry.value.toList(),
              ),
            )
            .toList();

    final result = await submitExamAttemptUseCase(
      examId: examId,
      demoId: demoId,
      answers: answers,
    );

    result.fold(
      (failure) {
        emit(
          ExamTakingError(
            failure.message,
          ),
        );
      },
      (submitResult) {
        emit(
          ExamTakingSubmitted(
            submitResult,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}