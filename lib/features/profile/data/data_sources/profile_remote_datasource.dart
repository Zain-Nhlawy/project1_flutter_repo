import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';

class ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getUploadUrl(File file) async {
    try {
      final res = await dioClient.dio.post(
        '/users/upload-url',
        data: {
          "fileName": file.path.split('/').last,
          "contentType": _getContentType(file),
          "isPublic": true,
          "folder": "users",
        },
      );

      return res.data['data'];
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  String _getContentType(File file) {
    final ext = file.path.split('.').last.toLowerCase();

    switch (ext) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  Future<void> uploadFile(
    String uploadUrl,
    File file,
  ) async {
    try {
      await Dio().put(
        uploadUrl,
        data: await file.readAsBytes(),
        options: Options(
          headers: {
            "x-ms-blob-type": "BlockBlob",
            "Content-Type": _getContentType(file),
          },
        ),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> updateProfileImage(
    String userId,
    String url,
  ) async {
    try {
      await dioClient.dio.patch(
        '/users/$userId',
        data: {
          "imagePath": url,
        },
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}