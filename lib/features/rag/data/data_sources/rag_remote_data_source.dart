import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/rag/data/models/ask_answer_model.dart';
import 'package:project1/features/rag/data/models/quiz_response_model.dart';

class RagRemoteDataSource {
  final DioClient dioClient;

  RagRemoteDataSource(this.dioClient);

  Future<AskAnswerModel> askQuestion({
    required String courseId,
    required String question,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/courses/$courseId/ask',
        data: {'question': question},
      );
      print('🟢 [RAG - ask] RAW RESPONSE: ${res.data}');
      return AskAnswerModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print(
        '🔴 [RAG - ask] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
      );
      throw mapDioException(e);
    }
  }


  Future<QuizResponseModel> generateTopicQuiz({
    required String courseId,
    required String topic,
    required int questionCount,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/courses/$courseId/quiz/generate',
        data: {
          'topic': topic,
          'questionCount': questionCount,
        },
      );
      print('🟢 [RAG - quiz/generate] RAW RESPONSE: ${res.data}');
      return QuizResponseModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print(
        '🔴 [RAG - quiz/generate] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
      );
      throw mapDioException(e);
    }
  }

  Future<QuizResponseModel> generateRandomQuiz({
    required String courseId,
    required int questionCount,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/courses/$courseId/random-quiz/generate',
        data: {'questionCount': questionCount},
      );
      print('🟢 [RAG - random-quiz/generate] RAW RESPONSE: ${res.data}');
      return QuizResponseModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print(
        '🔴 [RAG - random-quiz/generate] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
      );
      throw mapDioException(e);
    }
  }
}