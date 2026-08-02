import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/question_bank/data/models/question_bank_model.dart';
import 'package:project1/features/question_bank/domain/repository/question_bank_repository.dart';

class GetQuestionBankUseCase {
  final QuestionBankRepository repository;

  GetQuestionBankUseCase(this.repository);

  Future<Either<Failure, QuestionBankModel>> call({
    required String sectionId,
    required String questionBankId,
  }) {
    return repository.getQuestionBank(
      sectionId: sectionId,
      questionBankId: questionBankId,
    );
  }
}