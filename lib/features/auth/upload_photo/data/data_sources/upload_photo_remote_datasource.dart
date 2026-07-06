import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';

class UploadPhotoRemoteDataSource {
  final DioClient dioClient;

  UploadPhotoRemoteDataSource(this.dioClient);

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

  Future<String> uploadPhoto(File file) async {
    final contentType = _getContentType(file);

    final res = await dioClient.dio.post(
      '/users/upload-url',
      data: {
        "fileName": file.path.split('/').last,
        "contentType": contentType,
        "isPublic": true,
        "folder": "users",
      },
      options: Options(
        extra: {'noAuth': true},
      ),
    );

    final data = res.data['data'];

    final uploadUrl = data['uploadUrl'];
    final cdnUrl = data['cdnUrl'];

    await Dio().put(
      uploadUrl,
      data: await file.readAsBytes(),
      options: Options(
        headers: {
          'x-ms-blob-type': 'BlockBlob',
          'Content-Type': contentType,
        },
      ),
    );

    return cdnUrl;
  }
}