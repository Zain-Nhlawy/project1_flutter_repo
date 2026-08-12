import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/quiz/domain/use_case/create_exam_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/delete_exam_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/get_exams_usecase.dart';
import 'package:project1/features/quiz/domain/use_case/update_exam_usecase.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final GetExamsUseCase getExamsUseCase;
  final CreateExamUseCase createExamUseCase;
  final UpdateExamUseCase updateExamUseCase;
  final DeleteExamUseCase deleteExamUseCase;

  ExamCubit({
    required this.getExamsUseCase,
    required this.createExamUseCase,
    required this.updateExamUseCase,
    required this.deleteExamUseCase,
  }) : super(const ExamInitial());

  Future<dynamic> fetchExams({required String sectionId}) async {
  emit(const ExamLoading());
  final result = await getExamsUseCase(sectionId: sectionId);
  return result.fold(
    (failure) {
      emit(ExamError(failure.message));
      return null;
    },
    (data) {
      emit(
        ExamLoaded(
          exams: data.data,
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      );
      return data;
    },
  );
}

  Future<bool> createExam({
    required String sectionId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
    required int passingScore,
  }) async {
    final result = await createExamUseCase(
      sectionId: sectionId,
      title: title,
      numberOfQuestions: numberOfQuestions,
      durationMinutes: durationMinutes,
      passingScore: passingScore,
    );

    return result.fold(
      (failure) => false,
      (newExam) {
        final currentState = state;
        if (currentState is ExamLoaded) {
          emit(
            currentState.copyWith(exams: [newExam, ...currentState.exams]),
          );
        }
        return true;
      },
    );
  }

  Future<bool> updateExam({
    required String sectionId,
    required String examId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
    required int passingScore,
  }) async {
    final result = await updateExamUseCase(
      sectionId: sectionId,
      examId: examId,
      title: title,
      numberOfQuestions: numberOfQuestions,
      durationMinutes: durationMinutes,
      passingScore: passingScore,
    );

    return result.fold(
      (failure) => false,
      (updatedExam) {
        final currentState = state;
        if (currentState is ExamLoaded) {
          emit(
            currentState.copyWith(
              exams: currentState.exams
                  .map((e) => e.id == updatedExam.id ? updatedExam : e)
                  .toList(),
            ),
          );
        }
        return true;
      },
    );
  }

  Future<bool> deleteExam({
    required String sectionId,
    required String examId,
  }) async {
    final result = await deleteExamUseCase(
      sectionId: sectionId,
      examId: examId,
    );

    return result.fold(
      (failure) => false,
      (_) {
        final currentState = state;
        if (currentState is ExamLoaded) {
          emit(
            currentState.copyWith(
              exams:
                  currentState.exams.where((e) => e.id != examId).toList(),
            ),
          );
        }
        return true;
      },
    );
  }
}