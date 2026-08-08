import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/features/demo/data/models/inquiry_model.dart';

abstract class InquiryDataSource {
  Future<List<InquiryModel>> getInquiriesForOwner(String demoId);
  Future<List<InquiryModel>> getInquiriesForMember(String demoId);
  Future<InquiryModel> getInquiryById(String inquiryId, String demoId);
  Future<bool> deleteInquiry(String inquiryId, String demoId);
  Future<bool> createInquiry(String subject, String message, String demoId);
  Future<bool> updateInquiry(
    String inquiryId,
    String subject,
    String message,
    String demoId,
  );
  Future<bool> replyForInquiry(String inquiryId, String message, String demoId);
}

class InquiryDataSourceImpl implements InquiryDataSource {
  final Dio dio;
  InquiryDataSourceImpl({required this.dio});

  @override
  Future<List<InquiryModel>> getInquiriesForOwner(String demoId) async {
    try {
      final response = await dio.get(
        '/inquiries/cursor',
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

  @override
  Future<List<InquiryModel>> getInquiriesForMember(String demoId) async {
    try {
      final response = await dio.get(
        '/inquiries/cursor/me',
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

  @override
  Future<InquiryModel> getInquiryById(String inquiryId, String demoId) async {
    try {
      final response = await dio.get(
        '/inquiries/$inquiryId',
        options: Options(headers: {'x-demo-id': demoId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return InquiryModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<bool> deleteInquiry(String inquiryId, String demoId) async {
    try {
      final response = await dio.delete(
        '/inquiries/$inquiryId',
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
  Future<bool> createInquiry(
    String subject,
    String message,
    String demoId,
  ) async {
    try {
      final response = await dio.post(
        '/inquiries',
        data: {'subject': subject, 'message': message},
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
  Future<bool> updateInquiry(
    String inquiryId,
    String subject,
    String message,
    String demoId,
  ) async {
    try {
      final response = await dio.put(
        '/inquiries/$inquiryId',
        data: {'subject': subject, 'message': message, 'status': 'pending'},
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
  Future<bool> replyForInquiry(
    String inquiryId,
    String message,
    String demoId,
  ) async {
    try {
      final response = await dio.post(
        '/inquiries/$inquiryId/inquiryReplies',
        data: {'message': message},
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
}
