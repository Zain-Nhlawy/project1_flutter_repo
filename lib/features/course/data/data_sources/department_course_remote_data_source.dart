import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/department_course_model.dart';

class DepartmentCourseRemoteDataSource {
  final DioClient dioClient;

  DepartmentCourseRemoteDataSource(this.dioClient);

  Future<DepartmentCourseModel> createDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String assetId,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/departmentCourses',
        data: {'assetId': assetId},
        options: Options(
          headers: {
            'x-demo-id': demoId,
            'x-department-id': departmentId,
          },
        ),
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to create department course.');
      }

      return DepartmentCourseModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<List<DepartmentCourseModel>> getDepartmentCourses({
    required String demoId,
    required String departmentId,
    String? cursor,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/departmentCourses/cursor',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
        },
        options: Options(
          headers: {
            'x-demo-id': demoId,
            'x-department-id': departmentId,
          },
        ),
      );

      final data = response.data['data'] as List<dynamic>?;
      if (data == null) {
        throw const ServerException('Unable to fetch department courses.');
      }

      return data
          .map((e) => DepartmentCourseModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<DepartmentCourseModel> getDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/departmentCourses/$departmentCourseId',
        options: Options(
          headers: {
            'x-demo-id': demoId,
            'x-department-id': departmentId,
          },
        ),
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to fetch department course.');
      }

      return DepartmentCourseModel.fromJson(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  }) async {
    try {
      await dioClient.dio.delete(
        '/departmentCourses/$departmentCourseId',
        options: Options(
          headers: {
            'x-demo-id': demoId,
            'x-department-id': departmentId,
          },
        ),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}