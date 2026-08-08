import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/quiz/data/models/answer_submission_model.dart';
import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';
import 'package:project1/features/quiz/data/models/generated_exam_model.dart';
import 'package:project1/features/quiz/data/models/paginated_exam_attempts.dart';
import 'package:project1/features/quiz/data/models/submit_exam_attempt_result_model.dart';

class ExamAttemptRemoteDataSource {
  final DioClient dioClient;

  ExamAttemptRemoteDataSource(this.dioClient);

  Future<GeneratedExamModel> generateExamAttempt({
    required String examId,
  }) async {
    try {
      final res = await dioClient.dio.get('/examAttempts/generate/$examId');
      final data = res.data as Map<String, dynamic>;
      return GeneratedExamModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<SubmitExamAttemptResultModel> submitExamAttempt({
    required String examId,
    required String demoId,
    required List<AnswerSubmissionModel> answers,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/examAttempts',
        data: {
          'examId': examId,
          'answers': answers.map((a) => a.toJson()).toList(),
        },
          options: Options(
          headers: {
            'x-demo-id': demoId,
          },
        ),
      );
      final data = res.data as Map<String, dynamic>;
      return SubmitExamAttemptResultModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<PaginatedExamAttempts> getExamAttempts({String? cursor}) async {
    try {
      final res = await dioClient.dio.get(
        '/examAttempts/cursor',
        queryParameters: cursor != null ? {'cursor': cursor} : null,
      );
      return PaginatedExamAttempts.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<ExamAttemptModel> getExamAttempt({required String attemptId}) async {
    try {
      final res = await dioClient.dio.get('/examAttempts/$attemptId');
      final data = res.data as Map<String, dynamic>;
      return ExamAttemptModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteExamAttempt({required String attemptId}) async {
    try {
      await dioClient.dio.delete('/examAttempts/$attemptId');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}