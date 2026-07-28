import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/department/data/models/roadmap_model.dart';

abstract class RoadmapRemoteDataSource {
  Future<RoadmapModel> createRoadmap(
    String departmentId,
    String demoId,
    String title,
  );
}

class RoadmapRemoteDataSourceImpl implements RoadmapRemoteDataSource {
  final Dio dio;

  RoadmapRemoteDataSourceImpl(DioClient dioClient, {required this.dio});

  @override
  Future<RoadmapModel> createRoadmap(
    String departmentId,
    String demoId,
    String title,
  ) async {
    try {
      final response = await dio.post(
        '/departments/generate-roadmap',
        data: {'title': title},
        options: Options(
          headers: {'x-demo-id': demoId, 'x-department-id': departmentId},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic resData = response.data;
        dynamic targetData = resData;

        if (resData is Map<String, dynamic> && resData.containsKey('data')) {
          targetData = resData['data'];
        }

        if (targetData is Map<String, dynamic>) {
          return RoadmapModel.fromJson(targetData);
        } else if (targetData is List) {
          final steps = targetData
              .whereType<Map<String, dynamic>>()
              .map((json) => RoadmapStepModel.fromJson(json))
              .toList();

          return RoadmapModel(
            title: title,
            description: '',
            duration: '',
            difficulty: '',
            prerequisites: [],
            careerOutcomes: [],
            steps: steps,
          );
        } else {
          throw Exception(
            'Unexpected data payload format received from server.',
          );
        }
      } else {
        final errorMsg = response.data is Map ? response.data['message'] : null;
        throw Exception(errorMsg ?? 'Failed to generate roadmap');
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
