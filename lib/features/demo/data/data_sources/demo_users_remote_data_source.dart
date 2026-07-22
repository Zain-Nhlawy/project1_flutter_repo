import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/features/demo/data/models/invitation_model.dart';
import 'package:project1/features/demo/data/models/search_user_model.dart';
import 'package:project1/features/demo/data/models/user_model.dart';

abstract class DemoUsersRemoteDataSource {
  Future<List<MembersModel>> getDemoUsers(String demoId);
  Future<List<SearchUserModel>> searchDemoUsers(String query);
  Future<bool> removeUserFromDemo(String demoId, String userId);
  Future<bool> sendInvitation(String demoId, String userId);
  Future<List<InvitationModel>> getReceivedInvitations();
  Future<void> acceptInvitation(String invitationId);
  Future<void> rejectInvitation(String invitationId);
}

class DemoUsersRemoteDataSourceImpl implements DemoUsersRemoteDataSource {
  final Dio dio;

  DemoUsersRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MembersModel>> getDemoUsers(String demoId) async {
    try {
      final response = await dio.get(
        '/members',
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => MembersModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
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
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<bool> removeUserFromDemo(String demoId, String userId) async {
    try {
      final response = await dio.delete(
        '/members/$userId',
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<bool> sendInvitation(String demoId, String userId) async {
    try {
      final response = await dio.post(
        '/invitations',
        data: {'receiverId': userId, 'role': "MEMBER"},
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('user_already_invited');
      }
      throw mapDioException(e);
    }
  }

  @override
  Future<List<InvitationModel>> getReceivedInvitations() async {
    try {
      final response = await dio.get('/invitations/cursor');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => InvitationModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    try {
      final response = await dio.post('/invitations/$invitationId/accept');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> rejectInvitation(String invitationId) async {
    try {
      final response = await dio.post('/invitations/$invitationId/reject');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
