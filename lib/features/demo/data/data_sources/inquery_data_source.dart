import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/features/demo/data/models/inquiry_model.dart';

abstract class InquiryDataSource {
    Future<List<InquiryModel>> getInquiries(String demoId);
}

class InquiryDataSourceImpl implements InquiryDataSource {
  final Dio dio;
  InquiryDataSourceImpl({required this.dio});

@override
Future<List<InquiryModel>> getInquiries(String demoId) async {
    try {
        final response = await dio.get(
            '/inquiries',
            options: Options(headers: {'x-demo-id': demoId}),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
            final List<dynamic> dataList = response.data['data'];
            return dataList.map((json) => InquiryModel.fromJson(json)).toList();
        } else {
            throw Exception(response.data['message']);
        }
    } on DioException catch (e) {
        throw mapDioException(e);
    }
  }
}