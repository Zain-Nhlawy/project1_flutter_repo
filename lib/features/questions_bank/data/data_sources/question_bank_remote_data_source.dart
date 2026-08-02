import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/questions_bank/data/models/paginated_question_banks.dart';
import 'package:project1/features/questions_bank/data/models/question_bank_model.dart';
import 'package:project1/features/questions_bank/data/models/question_choice_model.dart';

class QuestionBankRemoteDataSource {
  final DioClient dioClient;

  QuestionBankRemoteDataSource(this.dioClient);

  Future<QuestionBankModel> createQuestionBank({
    required String sectionId,
    required String question,
    required List<QuestionChoiceModel> choices,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/sections/$sectionId/questionsBank',
        data: {
          'question': question,
          'choices': choices.map((c) => c.toRequestJson()).toList(),
        },
      );
      final data = res.data as Map<String, dynamic>;
      return QuestionBankModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<PaginatedQuestionBanks> getQuestionBanks({
    required String sectionId,
    String? cursor,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/sections/$sectionId/questionsBank/cursor',
        queryParameters: cursor != null ? {'cursor': cursor} : null,
      );
      return PaginatedQuestionBanks.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<QuestionBankModel> getQuestionBank({
    required String sectionId,
    required String questionBankId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/sections/$sectionId/questionsBank/$questionBankId',
      );
      final data = res.data as Map<String, dynamic>;
      return QuestionBankModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteQuestionBank({
    required String sectionId,
    required String questionBankId,
  }) async {
    try {
      await dioClient.dio.delete(
        '/sections/$sectionId/questionsBank/$questionBankId',
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}