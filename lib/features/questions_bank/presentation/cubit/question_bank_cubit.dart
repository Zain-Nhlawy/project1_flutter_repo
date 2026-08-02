import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/questions_bank/data/models/question_choice_model.dart';
import 'package:project1/features/questions_bank/domain/use_case/create_question_bank_usecase.dart';
import 'package:project1/features/questions_bank/domain/use_case/delete_question_bank_usecase.dart';
import 'package:project1/features/questions_bank/domain/use_case/get_question_banks_usecase.dart';
import 'package:project1/features/questions_bank/presentation/cubit/question_bank_state.dart';

class QuestionBankCubit extends Cubit<QuestionBankState> {
  final GetQuestionBanksUseCase getQuestionBanksUseCase;
  final CreateQuestionBankUseCase createQuestionBankUseCase;
  final DeleteQuestionBankUseCase deleteQuestionBankUseCase;

  QuestionBankCubit({
    required this.getQuestionBanksUseCase,
    required this.createQuestionBankUseCase,
    required this.deleteQuestionBankUseCase,
  }) : super(const QuestionBankInitial());

  Future<void> fetchQuestionBanks({required String sectionId}) async {
    emit(const QuestionBankLoading());

    final result = await getQuestionBanksUseCase(sectionId: sectionId);

    result.fold(
      (failure) => emit(QuestionBankError(failure.message)),
      (data) => emit(
        QuestionBankLoaded(
          questions: data.data,
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      ),
    );
  }

  Future<void> loadMore({required String sectionId}) async {
    final currentState = state;
    if (currentState is! QuestionBankLoaded) return;
    if (!currentState.hasNextPage || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getQuestionBanksUseCase(
      sectionId: sectionId,
      cursor: currentState.endCursor,
    );

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (data) => emit(
        currentState.copyWith(
          questions: [...currentState.questions, ...data.data],
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<bool> createQuestionBank({
    required String sectionId,
    required String question,
    required List<QuestionChoiceModel> choices,
  }) async {
    final result = await createQuestionBankUseCase(
      sectionId: sectionId,
      question: question,
      choices: choices,
    );

    return result.fold(
      (failure) => false,
      (newQuestion) {
        final currentState = state;
        if (currentState is QuestionBankLoaded) {
          emit(
            currentState.copyWith(
              questions: [newQuestion, ...currentState.questions],
            ),
          );
        }
        return true;
      },
    );
  }

  Future<bool> deleteQuestionBank({
    required String sectionId,
    required String questionBankId,
  }) async {
    final result = await deleteQuestionBankUseCase(
      sectionId: sectionId,
      questionBankId: questionBankId,
    );

    return result.fold(
      (failure) => false,
      (_) {
        final currentState = state;
        if (currentState is QuestionBankLoaded) {
          emit(
            currentState.copyWith(
              questions: currentState.questions
                  .where((q) => q.id != questionBankId)
                  .toList(),
            ),
          );
        }
        return true;
      },
    );
  }
}