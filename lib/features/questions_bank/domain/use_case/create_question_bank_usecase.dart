import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/questions_bank/data/models/question_bank_model.dart';
import 'package:project1/features/questions_bank/data/models/question_choice_model.dart';
import 'package:project1/features/questions_bank/domain/repository/question_bank_repository.dart';

class CreateQuestionBankUseCase {
  final QuestionBankRepository repository;

  CreateQuestionBankUseCase(this.repository);

  Future<Either<Failure, QuestionBankModel>> call({
    required String sectionId,
    required String question,
    required List<QuestionChoiceModel> choices,
  }) {
    return repository.createQuestionBank(
      sectionId: sectionId,
      question: question,
      choices: choices,
    );
  }
}