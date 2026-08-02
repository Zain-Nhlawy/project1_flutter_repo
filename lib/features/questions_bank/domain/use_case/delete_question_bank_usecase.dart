import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/questions_bank/domain/repository/question_bank_repository.dart';

class DeleteQuestionBankUseCase {
  final QuestionBankRepository repository;

  DeleteQuestionBankUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String sectionId,
    required String questionBankId,
  }) {
    return repository.deleteQuestionBank(
      sectionId: sectionId,
      questionBankId: questionBankId,
    );
  }
}