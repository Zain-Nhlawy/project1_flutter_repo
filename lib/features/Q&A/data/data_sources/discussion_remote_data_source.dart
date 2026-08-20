import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/Q&A/data/models/discussion_answer_model.dart';
import 'package:project1/features/Q&A/data/models/discussion_question_model.dart';
import 'package:project1/features/Q&A/data/models/paginated_discussion_answers.dart';
import 'package:project1/features/Q&A/data/models/paginated_discussion_questions.dart';

class DiscussionRemoteDataSource {
  final DioClient dioClient;

  DiscussionRemoteDataSource(this.dioClient);

  Future<DiscussionQuestionModel> createQuestion({
    required String lessonId,
    required String content,
    required String demoId,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/lessons/$lessonId/discussionQuestions',
        data: {'content': content},
        options: Options(
          headers: {
            'x-demo-id': demoId,
          },
        ),
      );

      final data = res.data as Map<String, dynamic>;

      return DiscussionQuestionModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<PaginatedDiscussionQuestions> getQuestions({
    required String lessonId,
    required String demoId,
    String? cursor,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/lessons/$lessonId/discussionQuestions/cursor',
        queryParameters: cursor != null ? {'cursor': cursor} : null,
        options: Options(
          headers: {
            'x-demo-id': demoId,
          },
        ),
      );

      return PaginatedDiscussionQuestions.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<DiscussionQuestionModel> getQuestion({
    required String lessonId,
    required String questionId,
    required String demoId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/lessons/$lessonId/discussionQuestions/$questionId',
        options: Options(
          headers: {
            'x-demo-id': demoId,
          },
        ),
      );

      final data = res.data as Map<String, dynamic>;

      return DiscussionQuestionModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<DiscussionAnswerModel> createAnswer({
    required String questionId,
    required String content,
    required String demoId,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/discussionQuestions/$questionId/answers',
        data: {'content': content},
        options: Options(
          headers: {
            'x-demo-id': demoId,
          },
        ),
      );

      final data = res.data as Map<String, dynamic>;

      return DiscussionAnswerModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<PaginatedDiscussionAnswers> getAnswers({
    required String questionId,
    required String demoId,
    String? cursor,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/discussionQuestions/$questionId/answers/cursor',
        queryParameters: cursor != null ? {'cursor': cursor} : null,
        options: Options(
          headers: {
            'x-demo-id': demoId,
          },
        ),
      );

      return PaginatedDiscussionAnswers.fromJson(
        res.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<DiscussionAnswerModel> getAnswer({
    required String questionId,
    required String answerId,
    required String demoId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/discussionQuestions/$questionId/answers/$answerId',
        options: Options(
          headers: {
            'x-demo-id': demoId,
          },
        ),
      );

      final data = res.data as Map<String, dynamic>;

      return DiscussionAnswerModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<DiscussionQuestionModel> updateQuestion({
  required String lessonId,
  required String questionId,
  required String content,
  required String demoId,
}) async {
  try {
    final res = await dioClient.dio.patch(
      '/lessons/$lessonId/discussionQuestions/$questionId',
      data: {
        'content': content,
      },
      options: Options(
        headers: {
          'x-demo-id': demoId,
        },
      ),
    );


    final data = res.data as Map<String, dynamic>;

    return DiscussionQuestionModel.fromJson(
      data['data'] as Map<String, dynamic>,
    );
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}

Future<void> deleteQuestion({
  required String lessonId,
  required String questionId,
  required String demoId,
}) async {
  try {
    await dioClient.dio.delete(
      '/lessons/$lessonId/discussionQuestions/$questionId',
      options: Options(
        headers: {
          'x-demo-id': demoId,
        },
      ),
    );

  } on DioException catch (e) {
    throw mapDioException(e);
  }
}

Future<DiscussionAnswerModel> updateAnswer({
  required String questionId,
  required String answerId,
  required String content,
  required String demoId,
}) async {
  try {
    final res = await dioClient.dio.patch(
      '/discussionQuestions/$questionId/answers/$answerId',
      data: {
        'content': content,
      },
      options: Options(
        headers: {
          'x-demo-id': demoId,
        },
      ),
    );

    final data = res.data as Map<String, dynamic>;

    return DiscussionAnswerModel.fromJson(
      data['data'] as Map<String, dynamic>,
    );
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}

Future<void> deleteAnswer({
  required String questionId,
  required String answerId,
  required String demoId,
}) async {
  try {
    await dioClient.dio.delete(
      '/discussionQuestions/$questionId/answers/$answerId',
      options: Options(
        headers: {
          'x-demo-id': demoId,
        },
      ),
    );

  } on DioException catch (e) {
    throw mapDioException(e);
  }
}
}
