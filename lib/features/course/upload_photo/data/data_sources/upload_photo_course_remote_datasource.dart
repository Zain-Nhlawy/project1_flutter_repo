import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';

class UploadPhotoCourseRemoteDataSource {
  final DioClient dioClient;

  UploadPhotoCourseRemoteDataSource(this.dioClient);

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
      '/courses/upload-url',
      data: {
        "fileName": file.path.split('/').last,
      },
    );

    final data = res.data['data'];

    final uploadUrl = data['uploadUrl'];
    final cdnUrl = data['cdnUrl'];
    final isPublic = data['isPublic'] ?? true;

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

    if (isPublic) {
      return cdnUrl;
    }

    return data['fileKey'];
  }
}