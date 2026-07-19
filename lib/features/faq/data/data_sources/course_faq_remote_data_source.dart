import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/course_faq_model.dart';

class CourseFaqRemoteDataSource {
  final DioClient dioClient;

  CourseFaqRemoteDataSource(this.dioClient);

  Future<CourseFaqModel> createCourseFaq({
    required String courseId,
    required String question,
    required String answer,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/courses/$courseId/courseFaqs',
        data: {
          'question': question,
          'answer': answer,
        },
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to create course FAQ.');
      }

      return CourseFaqModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<CourseFaqModel> getCourseFaq({
    required String courseId,
    required String faqId,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/courses/$courseId/courseFaqs/$faqId',
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to fetch course FAQ.');
      }

      return CourseFaqModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<List<CourseFaqModel>> getCourseFaqs({
    required String courseId,
    String? cursor,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/courses/$courseId/courseFaqs/cursor',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
        },
      );

      final data = response.data['data'] as List<dynamic>?;
      if (data == null) {
        throw const ServerException('Unable to fetch course FAQs.');
      }

      return data
          .map((e) => CourseFaqModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteCourseFaq({
    required String courseId,
    required String faqId,
  }) async {
    try {
      await dioClient.dio.delete(
        '/courses/$courseId/courseFaqs/$faqId',
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}