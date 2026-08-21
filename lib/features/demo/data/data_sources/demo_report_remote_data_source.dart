import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/features/demo/data/models/demo_report_model.dart';

abstract class DemoReportRemoteDataSource {
  Future<DemoOwnerReportModel> getOwnerReport(String demoId);
}

class DemoReportRemoteDataSourceImpl implements DemoReportRemoteDataSource {
  final Dio dio;

  DemoReportRemoteDataSourceImpl({required this.dio});

  @override
  Future<DemoOwnerReportModel> getOwnerReport(String demoId) async {
    try {
      final response = await dio.get(
        '/reports/demo-owner',
        options: Options(headers: {'x-demo-id': demoId}),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw Exception(
          'Demo report request failed with status $statusCode: '
          '${response.data}',
        );
      }

      final body = response.data;
      if (body is! Map) {
        throw Exception('Invalid demo report response: $body');
      }

      final data = body['data'];
      if (data is! Map) {
        throw Exception('Demo report response is missing its data object.');
      }

      return DemoOwnerReportModel.fromJson(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }
}
