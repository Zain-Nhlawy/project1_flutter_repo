import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/department/data/models/department_model.dart';

abstract class DepartmentRemoteDataSource {
  Future<List<DepartmentModel>> getDepartment(String demoId);
  Future<void> createDepartment(DepartmentModel department, String demoId);
  Future<void> deleteDepartment(String departmentId, String demoId);
  Future<void> updateDepartment(
    String departmentId,
    DepartmentModel department,
    String demoId,
  );
}

class DepartmentRemoteDataSourcImpl implements DepartmentRemoteDataSource {
  final Dio dio;

  DepartmentRemoteDataSourcImpl(DioClient dioClient, {required this.dio});
  @override
  Future<List<DepartmentModel>> getDepartment(String demoId) async {
    try {
      final response = await dio.get(
        '/departments',
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => DepartmentModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> createDepartment(
    DepartmentModel department,
    String demoId,
  ) async {
    try {
      final response = await dio.post(
        '/departments',
        data: department.toJson(),
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
@override
  Future<void> deleteDepartment(String departmentId, String demoId) async {
    try {
      final response = await dio.delete(
        '/departments/$departmentId',
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> updateDepartment(
    String departmentId,
    DepartmentModel department,
    String demoId,
  ) async {
    try {
      final response = await dio.patch(
        '/departments/$departmentId',
        data: department.toJson(),
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
