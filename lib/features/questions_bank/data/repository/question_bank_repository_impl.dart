import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/questions_bank/data/data_sources/question_bank_remote_data_source.dart';
import 'package:project1/features/questions_bank/data/models/paginated_question_banks.dart';
import 'package:project1/features/questions_bank/data/models/question_bank_model.dart';
import 'package:project1/features/questions_bank/data/models/question_choice_model.dart';
import 'package:project1/features/questions_bank/domain/repository/question_bank_repository.dart';

class QuestionBankRepositoryImpl implements QuestionBankRepository {
  final QuestionBankRemoteDataSource remoteDataSource;

  QuestionBankRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, QuestionBankModel>> createQuestionBank({
    required String sectionId,
    required String question,
    required List<QuestionChoiceModel> choices,
  }) async {
    try {
      final result = await remoteDataSource.createQuestionBank(
        sectionId: sectionId,
        question: question,
        choices: choices,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedQuestionBanks>> getQuestionBanks({
    required String sectionId,
    String? cursor,
  }) async {
    try {
      final result = await remoteDataSource.getQuestionBanks(
        sectionId: sectionId,
        cursor: cursor,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, QuestionBankModel>> getQuestionBank({
    required String sectionId,
    required String questionBankId,
  }) async {
    try {
      final result = await remoteDataSource.getQuestionBank(
        sectionId: sectionId,
        questionBankId: questionBankId,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuestionBank({
    required String sectionId,
    required String questionBankId,
  }) async {
    try {
      await remoteDataSource.deleteQuestionBank(
        sectionId: sectionId,
        questionBankId: questionBankId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}