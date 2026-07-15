import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/network/dio_client.dart';


class LessonVideoUploadRemoteDataSource {
  final DioClient dioClient;

  final Dio _blobDio = Dio();

  LessonVideoUploadRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> generateUploadUrl({
  required String sectionId,
  required String fileName,
  })async {
    try {
      final response = await dioClient.dio.post(
        '/sections/$sectionId/lessons/upload-url',
        data: {
          'fileName': fileName,
        },
      );

      final data = response.data['data'];

      if (data == null) {
        throw const ServerException(
          'Unable to generate upload url',
        );
      }

      return Map<String, dynamic>.from(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> uploadVideo({
    required String uploadUrl,
    required File file,
    required String contentType,
    required Function(double) onProgress,
  }) async {
    try {
      final length = await file.length();

      await _blobDio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            'x-ms-blob-type': 'BlockBlob',
            'Content-Type': contentType,
            'Content-Length': length,
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
  
}