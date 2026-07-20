import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/lesson/data/models/lesson_model.dart';

class LessonRemoteDataSource {
  final DioClient dioClient;

  LessonRemoteDataSource(this.dioClient);

  Future<LessonModel> createLesson({
    required String sectionId,
    required String title,
    required int order,
    required String videoUrl,
    required String description,
    required int duration,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/sections/$sectionId/lessons',
        data: {
          'title': title,
          'order': order,
          'videoUrl': videoUrl,
          'description': description,
          'duration': duration,
        },
      );

      final data = response.data['data'];

      if (data == null) {
        throw const ServerException('Unable to create lesson.');
      }

      return LessonModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<LessonModel> getLesson({
    required String sectionId,
    required String lessonId,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/sections/$sectionId/lessons/$lessonId',
      );

      return LessonModel.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<List<LessonModel>> getLessons({
    required String sectionId,
    String? cursor,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/sections/$sectionId/lessons/cursor',
        queryParameters: {if (cursor != null) 'cursor': cursor},
      );

      final List list = response.data['data'];

      return list
          .map((e) => LessonModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<LessonModel> updateLesson({
    required String sectionId,
    required String lessonId,
    String? title,
    String? videoUrl,
    String? description,
    int? duration,
    int? order,
  }) async {
    try {
      final response = await dioClient.dio.patch(
        '/sections/$sectionId/lessons/$lessonId',
        data: {
          if (title != null) 'title': title,
          if (videoUrl != null) 'videoUrl': videoUrl,
          if (description != null) 'description': description,
          if (duration != null) 'duration': duration,
          if (order != null) 'order': order,
        },
      );

      final data = response.data['data'];

      if (data == null) {
        throw const ServerException('Unable to update lesson.');
      }

      return LessonModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteLesson({
    required String sectionId,
    required String lessonId,
  }) async {
    try {
      await dioClient.dio.delete('/sections/$sectionId/lessons/$lessonId');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
