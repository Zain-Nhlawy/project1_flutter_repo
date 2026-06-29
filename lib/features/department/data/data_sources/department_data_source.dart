import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/department/data/models/department_model.dart';

abstract class DepartmentRemoteDataSource {
  Future<List<DepartmentModel>> getDepartment(String demoId);
}

 class DepartmentRemoteDataSourcImpl implements DepartmentRemoteDataSource {
  final Dio dio;

  DepartmentRemoteDataSourcImpl(DioClient dioClient, {required this.dio});
    @override
  Future<List<DepartmentModel>> getDepartment(String demoId) async {
    try {
      final response = await dio.get('/demos/$demoId/departments');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => DepartmentModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
