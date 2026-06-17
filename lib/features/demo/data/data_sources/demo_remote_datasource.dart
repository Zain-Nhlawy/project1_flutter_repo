import 'package:dio/dio.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';

abstract class DemoRemoteDataSource {
  Future<List<DemoModel>> getDemos();
}

class DemoRemoteDataSourceImpl implements DemoRemoteDataSource {
  final Dio dio;

  DemoRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<DemoModel>> getDemos() async {
    try {
      final response = await dio.get('/admin/demos');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((json) => DemoModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}