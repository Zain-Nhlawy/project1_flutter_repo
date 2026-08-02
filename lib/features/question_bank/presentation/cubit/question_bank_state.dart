import 'package:project1/features/question_bank/data/models/question_bank_model.dart';

abstract class QuestionBankState {
  const QuestionBankState();
}

class QuestionBankInitial extends QuestionBankState {
  const QuestionBankInitial();
}

class QuestionBankLoading extends QuestionBankState {
  const QuestionBankLoading();
}

class QuestionBankLoaded extends QuestionBankState {
  final List<QuestionBankModel> questions;
  final bool hasNextPage;
  final String? endCursor;
  final bool isLoadingMore;

  const QuestionBankLoaded({
    required this.questions,
    required this.hasNextPage,
    required this.endCursor,
    this.isLoadingMore = false,
  });

  QuestionBankLoaded copyWith({
    List<QuestionBankModel>? questions,
    bool? hasNextPage,
    String? endCursor,
    bool? isLoadingMore,
  }) {
    return QuestionBankLoaded(
      questions: questions ?? this.questions,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor ?? this.endCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class QuestionBankError extends QuestionBankState {
  final String message;
  const QuestionBankError(this.message);
}