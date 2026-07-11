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
    final res = await dioClient.dio.post(
      '/courses/$courseId/sections',
      data: {
        'title': title,
        'order': order,
      },
    );

    return SectionModel.fromJson(res.data['data']);
  }

  Future<SectionModel> getSection({
    required String courseId,
    required String sectionId,
  }) async {
    final res = await dioClient.dio.get(
      '/courses/$courseId/sections/$sectionId',
    );

    return SectionModel.fromJson(res.data['data']);
  }

  Future<SectionModel> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  }) async {
    final res = await dioClient.dio.patch(
      '/courses/$courseId/sections/$sectionId',
      data: {
        'title': title,
        'order': order,
      },
    );

    return SectionModel.fromJson(res.data['data']);
  }

  Future<void> deleteSection({
    required String courseId,
    required String sectionId,
  }) async {
    await dioClient.dio.delete(
      '/courses/$courseId/sections/$sectionId',
    );
  }

  Future<List<SectionModel>> getSections({
  required String courseId,
}) async {
  final res = await dioClient.dio.get(
    '/courses/$courseId/sections/cursor',
  );

  final List<dynamic>? data = res.data['data'];

  if (data == null) {
    throw Exception('Failed to load sections');
  }

  return data
      .map((e) => SectionModel.fromJson(e))
      .toList();
}
}