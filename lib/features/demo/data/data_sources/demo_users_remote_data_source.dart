import 'package:dio/dio.dart';
import 'package:project1/core/shared/models/user_model.dart';


abstract class DemoUsersRemoteDataSource {
  Future<List<MembersModel>> getDemoUsers(String demoId);
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
}