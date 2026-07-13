import 'package:dio/dio.dart';
import 'package:project1/features/demo/shared/models/search_user_model.dart';
import 'package:project1/features/demo/shared/models/user_model.dart';

abstract class DemoUsersRemoteDataSource {
  Future<List<MembersModel>> getDemoUsers(String demoId);
  Future<List<SearchUserModel>> searchDemoUsers(String query);
}

class DemoUsersRemoteDataSourceImpl implements DemoUsersRemoteDataSource {
  final Dio dio;

  DemoUsersRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MembersModel>> getDemoUsers(String demoId) async {
    try {
      final response = await dio.get('/demos/$demoId/members');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => MembersModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<SearchUserModel>> searchDemoUsers(String query) async {
    try {
      final response = await dio.get(
        '/users/cursor',
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => SearchUserModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
