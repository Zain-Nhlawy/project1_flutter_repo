import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/department/data/models/department_member_model.dart';

abstract class DepartmentMemberDataSource {
  Future<List<DepartmentMemberModel>> getDepartmentMembers(
    String departmentId,
    String demoId,
  );
  Future<void> addDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
    String jobTitle,
  );

  Future<void> removeDepartmentMember(
    String departmentId,
    String demoId,
    String departmentMemberId,
  );
  Future<List<MembersModel>> searchDemoMembers(
    String departmentId,
    String demoId,
    String query,
  );
}

class DepartmentMemberDataSourceImpl implements DepartmentMemberDataSource {
  final Dio dio;

  DepartmentMemberDataSourceImpl(DioClient dioClient, {required this.dio});

  @override
  Future<List<DepartmentMemberModel>> getDepartmentMembers(
    String departmentId,
    String demoId,
  ) async {
    try {
      final response = await dio.get(
        '/departmentMembers',
        options: Options(
          headers: {'x-demo-id': demoId, 'x-department-id': departmentId},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList
            .map((json) => DepartmentMemberModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> addDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
    String jobTitle,
  ) async {

    try {
      final response = await dio.post(
        '/departmentMembers',
        data: {
          'demoMemberId': demoMemberId,
          'jobTitle': jobTitle,
        },
        options: Options(
          headers: {'x-demo-id': demoId, 'x-department-id': departmentId},
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

@override
  Future<void> removeDepartmentMember(
    String departmentId,
    String demoId,
    String departmentMemberId,
  ) async {
    try {
      final response = await dio.delete(
        '/departmentMembers/$departmentMemberId',
        options: Options(
          headers: {'x-demo-id': demoId, 'x-department-id': departmentId},
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

@override
  Future<List<MembersModel>> searchDemoMembers(
    String departmentId,
    String demoId,
    String query,
  ) async {
    try {
      final response = await dio.get(
        '/members',
        queryParameters: query.trim().isNotEmpty ? {'search': query.trim()} : null,
        options: Options(
          headers: {'x-demo-id': demoId},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        final results = dataList
            .map((json) => MembersModel.fromJson(json))
            .toList();

        if (query.trim().isNotEmpty) {
          final q = query.trim().toLowerCase();
          return results.where((m) {
            final name = '${m.firstName} ${m.lastName}'.toLowerCase();
            final email = m.email.toLowerCase();
            return name.contains(q) || email.contains(q);
          }).toList();
        }

        return results;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
