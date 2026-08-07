import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/data/models/paginated_exams.dart';

class ExamRemoteDataSource {
  final DioClient dioClient;

  ExamRemoteDataSource(this.dioClient);

  Future<ExamModel> createExam({
    required String sectionId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/sections/$sectionId/exams',
        data: {
          'title': title,
          'numberOfQuestions': numberOfQuestions,
          'durationMinutes': durationMinutes,
        },
      );
      final data = res.data as Map<String, dynamic>;
      return ExamModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<PaginatedExams> getExams({
    required String sectionId,
    String? cursor,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/sections/$sectionId/exams/cursor',
        queryParameters: cursor != null ? {'cursor': cursor} : null,
      );
      return PaginatedExams.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<ExamModel> getExam({
    required String sectionId,
    required String examId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/sections/$sectionId/exams/$examId',
      );
      final data = res.data as Map<String, dynamic>;
      return ExamModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<ExamModel> updateExam({
    required String sectionId,
    required String examId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
  }) async {
    try {
      final res = await dioClient.dio.patch(
        '/sections/$sectionId/exams/$examId',
        data: {
          'title': title,
          'numberOfQuestions': numberOfQuestions,
          'durationMinutes': durationMinutes,
        },
      );
      final data = res.data as Map<String, dynamic>;
      return ExamModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteExam({
    required String sectionId,
    required String examId,
  }) async {
    try {
      await dioClient.dio.delete(
        '/sections/$sectionId/exams/$examId',
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}