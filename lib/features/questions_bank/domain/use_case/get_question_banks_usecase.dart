import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/questions_bank/data/models/paginated_question_banks.dart';
import 'package:project1/features/questions_bank/domain/repository/question_bank_repository.dart';

class GetQuestionBanksUseCase {
  final QuestionBankRepository repository;

  GetQuestionBanksUseCase(this.repository);

  Future<Either<Failure, PaginatedQuestionBanks>> call({
    required String sectionId,
    String? cursor,
  }) {
    return repository.getQuestionBanks(sectionId: sectionId, cursor: cursor);
  }
}