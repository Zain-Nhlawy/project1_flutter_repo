import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_answers.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_questions.dart';

class DiscussionRemoteDataSource {
  final DioClient dioClient;

  DiscussionRemoteDataSource(this.dioClient);

  Future<DiscussionQuestionModel> createQuestion({
    required String lessonId,
    required String content,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/lessons/$lessonId/discussionQuestions',
        data: {'content': content},
      );

      print('🟢 CREATE QUESTION RESPONSE: ${res.data}');

      final data = res.data as Map<String, dynamic>;
      return DiscussionQuestionModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('🔴 CREATE QUESTION ERROR: ${e.response?.data}');
      throw mapDioException(e);
    }
  }

  Future<PaginatedDiscussionQuestions> getQuestions({
    required String lessonId,
    String? cursor,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/lessons/$lessonId/discussionQuestions/cursor',
        queryParameters: cursor != null ? {'cursor': cursor} : null,
      );

      print('🟢 GET QUESTIONS RESPONSE: ${res.data}');

      return PaginatedDiscussionQuestions.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('🔴 GET QUESTIONS ERROR: ${e.response?.data}');
      throw mapDioException(e);
    }
  }

  Future<DiscussionQuestionModel> getQuestion({
    required String lessonId,
    required String questionId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/lessons/$lessonId/discussionQuestions/$questionId',
      );

      print('🟢 GET QUESTION RESPONSE: ${res.data}');

      final data = res.data as Map<String, dynamic>;
      return DiscussionQuestionModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('🔴 GET QUESTION ERROR: ${e.response?.data}');
      throw mapDioException(e);
    }
  }

  Future<DiscussionAnswerModel> createAnswer({
    required String questionId,
    required String content,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/discussionQuestions/$questionId/answers',
        data: {'content': content},
      );

      print('🟢 CREATE ANSWER RESPONSE: ${res.data}');

      final data = res.data as Map<String, dynamic>;
      return DiscussionAnswerModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('🔴 CREATE ANSWER ERROR: ${e.response?.data}');
      throw mapDioException(e);
    }
  }

  Future<PaginatedDiscussionAnswers> getAnswers({
    required String questionId,
    String? cursor,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/discussionQuestions/$questionId/answers/cursor',
        queryParameters: cursor != null ? {'cursor': cursor} : null,
      );

      print('🟢 GET ANSWERS RESPONSE: ${res.data}');

      return PaginatedDiscussionAnswers.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('🔴 GET ANSWERS ERROR: ${e.response?.data}');
      throw mapDioException(e);
    }
  }

  Future<DiscussionAnswerModel> getAnswer({
    required String questionId,
    required String answerId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/discussionQuestions/$questionId/answers/$answerId',
      );

      print('🟢 GET ANSWER RESPONSE: ${res.data}');

      final data = res.data as Map<String, dynamic>;
      return DiscussionAnswerModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('🔴 GET ANSWER ERROR: ${e.response?.data}');
      throw mapDioException(e);
    }
  }
}