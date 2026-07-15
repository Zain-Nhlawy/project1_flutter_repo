import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';

class AttachmentUploadRemoteDataSource {
  final DioClient dioClient;

  AttachmentUploadRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> generateUploadUrl({
    required String lessonId,
    required String fileName,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/lessons/$lessonId/attachments/upload-url',
        data: {
          'files': [fileName],
        },
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to get upload URL.');
      }

      final Map<String, dynamic> first =
          data is List ? Map<String, dynamic>.from(data.first) : Map<String, dynamic>.from(data);

      return first;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> uploadFile({
  required String uploadUrl,
  required File file,
  required String contentType,
  required void Function(double progress) onProgress,
}) async {
  final bytes = await file.readAsBytes();

  final dio = Dio(); 

  await dio.put(
    uploadUrl,
    data: bytes,
    options: Options(
      headers: {
        'x-ms-blob-type': 'BlockBlob',
        'Content-Type': contentType,
        'Content-Length': bytes.length, 
      },
    ),
    onSendProgress: (sent, total) {
      if (total > 0) {
        onProgress(sent / total);
      }
    },
  );
}
}