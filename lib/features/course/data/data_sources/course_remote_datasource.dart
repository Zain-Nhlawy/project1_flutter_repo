import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/course/data/models/course_model.dart';
import 'package:project1/features/course/data/models/tag_model.dart';

class CourseRemoteDataSource {
  final DioClient dioClient;

  CourseRemoteDataSource(this.dioClient);

  Future<List<TagModel>> getTags() async {
    try {
      final res = await dioClient.dio.get('/tags');
      final List<dynamic>? data = res.data?['data'];
      if (data == null) {
        throw const ServerException('Failed to load tags.');
      }
      return data.map((tagJson) => TagModel.fromJson(tagJson)).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<CourseModel> createCourse(CourseModel course) async {
    try {
      final res = await dioClient.dio.post(
        '/courses',
        data: course.toJson(),
      );
      return CourseModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<CourseModel> getCourse(String courseId) async {
    try {
      final res = await dioClient.dio.get('/courses/$courseId');
      final data = res.data?['data'];
      if (data == null) {
        throw const ServerException('Failed to load course.');
      }
      return CourseModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<List<CourseModel>> getDemoCourses(String demoId) async {
  try {
    final res = await dioClient.dio.get('/demos/$demoId/assets/cursor');
    final List<dynamic>? data = res.data?['data'];
    if (data == null) {
      throw const ServerException('Failed to load demo courses.');
    }
    return data
        .map((asset) {
          if (asset['course'] == null) return null;
          return CourseModel.fromAssetJson(Map<String, dynamic>.from(asset));
        })
        .whereType<CourseModel>()
        .toList();
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}


  Future<CourseModel> getDemoCourse({
  required String demoId,
  required String assetId,
}) async {
  try {
    final res = await dioClient.dio.get('/demos/$demoId/assets/$assetId');
    final data = res.data?['data'];
    if (data == null) {
      throw const ServerException('Failed to load course.');
    }
    return CourseModel.fromAssetJson(Map<String, dynamic>.from(data));
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}

  Future<CourseModel> updateCourse({
    required String courseId,
    required CourseModel course,
  }) async {
    try {
      final res = await dioClient.dio.patch(
        '/courses/$courseId',
        data: {
          "title": course.title,
          "description": course.description,
          "imagePath": course.imagePath,
          "visibility": course.visibility,
          "price": course.price,
          "tagIds": course.tagIds,
        },
      );
      return CourseModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      await dioClient.dio.delete('/courses/$courseId');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<CourseModel> publishCourse(String courseId) async {
  try {
    final res = await dioClient.dio.post(
      '/courses/$courseId/publish',
    );
    final data = res.data['data'];
    if (data == null) {
      throw const ServerException('Published successfully but no data returned.');
    }

    return CourseModel.fromJson(
      res.data['data'],
    );
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}
}