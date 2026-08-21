import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';

abstract class DemoRemoteDataSource {
  Future<List<DemoModel>> getDemos();
  Future<void> addDemo(DemoModel demo);
  
}

class DemoRemoteDataSourceImpl implements DemoRemoteDataSource {
  final Dio dio;

  DemoRemoteDataSourceImpl(DioClient dioClient, {required this.dio});

  @override
  Future<List<DemoModel>> getDemos() async {
    try {
      final response = await dio.get('/demos');

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic dataList = response.data;
        if (dataList is Map && dataList.containsKey('data')) {
          dataList = dataList['data'];
        }
        if (dataList is List) {
          return dataList
              .map((json) => DemoModel.fromJson(Map<String, dynamic>.from(json as Map)))
              .toList();
        }
        return [];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load demos');
      }
    } on DioException catch (e) {
      throw mapDioException(e); 
    }
  }

  @override
  Future<void> addDemo(DemoModel demo) async {
    try {
      final response = await dio.post('/demos', data: demo.toJson());

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
