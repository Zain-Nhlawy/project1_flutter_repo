// import 'package:dio/dio.dart';
// import 'package:project1/core/errors/dio_exception_mapper.dart';
// import 'package:project1/core/network/dio_client.dart';
// import 'package:project1/features/rag/data/models/ask_answer_model.dart';
// import 'package:project1/features/rag/data/models/quiz_response_model.dart';

// class RagRemoteDataSource {
//   final DioClient dioClient;

//   RagRemoteDataSource(this.dioClient);

//   Future<AskAnswerModel> askQuestion({
//     required String courseId,
//     required String question,
//   }) async {
//     try {
//       final res = await dioClient.dio.post(
//         '/courses/$courseId/ask',
//         data: {'question': question},
//       );
//       print('🟢 [RAG - ask] RAW RESPONSE: ${res.data}');
//       return AskAnswerModel.fromJson(res.data as Map<String, dynamic>);
//     } on DioException catch (e) {
//       print(
//         '🔴 [RAG - ask] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
//       );
//       throw mapDioException(e);
//     }
//   }


//   Future<QuizResponseModel> generateTopicQuiz({
//     required String courseId,
//     required String topic,
//     required int questionCount,
//   }) async {
//     try {
//       final res = await dioClient.dio.post(
//         '/courses/$courseId/quiz/generate',
//         data: {
//           'topic': topic,
//           'questionCount': questionCount,
//         },
//       );
//       print('🟢 [RAG - quiz/generate] RAW RESPONSE: ${res.data}');
//       return QuizResponseModel.fromJson(res.data as Map<String, dynamic>);
//     } on DioException catch (e) {
//       print(
//         '🔴 [RAG - quiz/generate] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
//       );
//       throw mapDioException(e);
//     }
//   }

//   Future<QuizResponseModel> generateRandomQuiz({
//     required String courseId,
//     required int questionCount,
//   }) async {
//     try {
//       final res = await dioClient.dio.post(
//         '/courses/$courseId/random-quiz/generate',
//         data: {'questionCount': questionCount},
//       );
//       print('🟢 [RAG - random-quiz/generate] RAW RESPONSE: ${res.data}');
//       return QuizResponseModel.fromJson(res.data as Map<String, dynamic>);
//     } on DioException catch (e) {
//       print(
//         '🔴 [RAG - random-quiz/generate] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
//       );
//       throw mapDioException(e);
//     }
//   }
// }


import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/rag/data/models/ask_answer_model.dart';
import 'package:project1/features/rag/data/models/quiz_question_model.dart';
import 'package:project1/features/rag/data/models/quiz_response_model.dart';

class RagRemoteDataSource {
  final DioClient dioClient;

  RagRemoteDataSource(this.dioClient);

  static const int _maxQuestionsPerRequest = 3;

  List<int> _splitCount(int totalCount) {
    final chunks = <int>[];
    var remaining = totalCount;
    while (remaining > 0) {
      final chunk = remaining >= _maxQuestionsPerRequest
          ? _maxQuestionsPerRequest
          : remaining;
      chunks.add(chunk);
      remaining -= chunk;
    }
    return chunks;
  }

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
    final chunks = _splitCount(questionCount);
    final allQuestions = <QuizQuestionModel>[];
    QuizResponseModel? lastResponse;

    for (final chunkCount in chunks) {
      try {
        final res = await dioClient.dio.post(
          '/courses/$courseId/quiz/generate',
          data: {
            'topic': topic,
            'questionCount': chunkCount,
          },
        );

        print('🟢 [RAG - quiz/generate] chunk=$chunkCount RAW RESPONSE: ${res.data}');

        final chunkResponse = QuizResponseModel.fromJson(res.data as Map<String, dynamic>);
        allQuestions.addAll(chunkResponse.questions);
        lastResponse = chunkResponse;
      } on DioException catch (e) {
        print(
          '🔴 [RAG - quiz/generate] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
        );
        throw mapDioException(e);
      }
    }

    return QuizResponseModel(
      success: lastResponse?.success ?? true,
      message: lastResponse?.message ?? 'Quiz generated successfully',
      questions: allQuestions,
      timestamp: DateTime.now(),
    );
  }

  Future<QuizResponseModel> generateRandomQuiz({
    required String courseId,
    required int questionCount,
  }) async {
    final chunks = _splitCount(questionCount);
    final allQuestions = <QuizQuestionModel>[];
    QuizResponseModel? lastResponse;

    for (final chunkCount in chunks) {
      try {
        final res = await dioClient.dio.post(
          '/courses/$courseId/random-quiz/generate',
          data: {'questionCount': chunkCount},
        );

        print('🟢 [RAG - random-quiz/generate] chunk=$chunkCount RAW RESPONSE: ${res.data}');

        final chunkResponse = QuizResponseModel.fromJson(res.data as Map<String, dynamic>);
        allQuestions.addAll(chunkResponse.questions);
        lastResponse = chunkResponse;
      } on DioException catch (e) {
        print(
          '🔴 [RAG - random-quiz/generate] type=${e.type} | statusCode=${e.response?.statusCode} | data=${e.response?.data}',
        );
        throw mapDioException(e);
      }
    }

    return QuizResponseModel(
      success: lastResponse?.success ?? true,
      message: lastResponse?.message ?? 'Random quiz generated successfully',
      questions: allQuestions,
      timestamp: DateTime.now(),
    );
  }
}