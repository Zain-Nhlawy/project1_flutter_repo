import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/questions_bank/data/models/paginated_question_banks.dart';
import 'package:project1/features/questions_bank/data/models/question_bank_model.dart';
import 'package:project1/features/questions_bank/data/models/question_choice_model.dart';

abstract class QuestionBankRepository {
  Future<Either<Failure, QuestionBankModel>> createQuestionBank({
    required String sectionId,
    required String question,
    required List<QuestionChoiceModel> choices,
  });

  Future<Either<Failure, PaginatedQuestionBanks>> getQuestionBanks({
    required String sectionId,
    String? cursor,
  });

  Future<Either<Failure, QuestionBankModel>> getQuestionBank({
    required String sectionId,
    required String questionBankId,
  });

  Future<Either<Failure, void>> deleteQuestionBank({
    required String sectionId,
    required String questionBankId,
  });
}