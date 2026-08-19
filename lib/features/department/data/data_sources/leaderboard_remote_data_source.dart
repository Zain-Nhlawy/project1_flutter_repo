import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/department/data/models/leaderboard_member_model.dart';

abstract class LeaderboardRemoteDataSource {
  Future<List<LeaderboardMemberModel>> getLeaderboard({
    required String departmentId,
    required String demoId,
  });
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final Dio dio;

  LeaderboardRemoteDataSourceImpl(DioClient dioClient, {required this.dio});

  @override
  Future<List<LeaderboardMemberModel>> getLeaderboard({
    required String departmentId,
    required String demoId,
  }) async {
    try {
      final response = await dio.get(
        '/departments/leaderboard',
        options: Options(
          headers: {
            'x-demo-id': demoId,
            'x-department-id': departmentId,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        return dataList
            .map((json) => LeaderboardMemberModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load leaderboard');
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
