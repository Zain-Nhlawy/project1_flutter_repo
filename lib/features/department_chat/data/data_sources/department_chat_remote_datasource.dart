import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import '../models/department_message_model.dart';

abstract class DepartmentChatRemoteDataSource {
  Future<Map<String, dynamic>> requestAttachmentUpload({
    required String departmentId,
    required String demoId,
    required String fileName,
  });

  Future<void> uploadAttachmentFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String mimeType,
    required void Function(double progress) onProgress,
  });

  Future<Map<String, dynamic>> getMessagesHistory({
    required String departmentId,
    required String demoId,
    String? cursor,
    int take = 15,
  });
}

class DepartmentChatRemoteDataSourceImpl
    implements DepartmentChatRemoteDataSource {
  final Dio dio;
  final Dio uploadDio;

  DepartmentChatRemoteDataSourceImpl({required this.dio, Dio? uploadDio})
    : uploadDio = uploadDio ?? Dio();

  @override
  Future<Map<String, dynamic>> requestAttachmentUpload({
    required String departmentId,
    required String demoId,
    required String fileName,
  }) async {
    try {
      final response = await dio.post(
        '/departmentMessages/upload-url',
        data: {'fileName': fileName},
        options: Options(
          headers: {'x-demo-id': demoId, 'x-department-id': departmentId},
        ),
      );

      final responseData = response.data;
      final data = responseData is Map<String, dynamic>
          ? responseData['data']
          : null;
      if (data is! Map) {
        throw const ServerException('Unable to get attachment upload URL.');
      }

      return Map<String, dynamic>.from(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> uploadAttachmentFile({
    required String uploadUrl,
    required Uint8List bytes,
    required String mimeType,
    required void Function(double progress) onProgress,
  }) async {
    try {
      await uploadDio.put(
        uploadUrl,
        data: bytes,
        options: Options(
          headers: {
            'x-ms-blob-type': 'BlockBlob',
            'Content-Type': mimeType,
            'Content-Length': bytes.length,
          },
        ),
        onSendProgress: (sent, total) {
          if (total > 0) {
            onProgress(sent / total);
          }
        },
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getMessagesHistory({
    required String departmentId,
    required String demoId,
    String? cursor,
    int take = 15,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'take': take,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
      };

      final response = await dio.get(
        '/departmentMessages/cursor',
        queryParameters: queryParams,
        options: Options(
          headers: {'x-demo-id': demoId, 'x-department-id': departmentId},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final rawList = data['data'] as List<dynamic>? ?? [];
        final messages = rawList
            .map(
              (json) =>
                  DepartmentMessageModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        final meta = data['meta'] as Map<String, dynamic>? ?? {};
        final hasNextPage = meta['hasNextPage'] == true;
        final endCursor = meta['endCursor']?.toString();

        return {
          'messages': messages,
          'hasNextPage': hasNextPage,
          'endCursor': endCursor,
        };
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load message history',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
