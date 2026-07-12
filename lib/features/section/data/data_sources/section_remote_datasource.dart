import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/section/data/models/section_model.dart';

class SectionRemoteDataSource {
  final DioClient dioClient;

  SectionRemoteDataSource(this.dioClient);

  Future<SectionModel> createSection({
    required String courseId,
    required String title,
    required int order,
  }) async {
    try {
      final res = await dioClient.dio.post(
        '/courses/$courseId/sections',
        data: {
          'title': title,
          'order': order,
        },
      );
      return SectionModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<SectionModel> getSection({
    required String courseId,
    required String sectionId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/courses/$courseId/sections/$sectionId',
      );
      return SectionModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<SectionModel> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  }) async {
    try {
      final res = await dioClient.dio.patch(
        '/courses/$courseId/sections/$sectionId',
        data: {
          'title': title,
          'order': order,
        },
      );
      return SectionModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteSection({
    required String courseId,
    required String sectionId,
  }) async {
    try {
      await dioClient.dio.delete(
        '/courses/$courseId/sections/$sectionId',
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<List<SectionModel>> getSections({
    required String courseId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/courses/$courseId/sections/cursor',
      );

      final List<dynamic>? data = res.data['data'];

      if (data == null) {
        throw const ServerException('Failed to load sections.');
      }

      return data.map((e) => SectionModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}