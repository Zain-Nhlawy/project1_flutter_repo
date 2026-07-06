import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';

class ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getUploadUrl(File file) async {
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
}


  Future<void> updateProfileImage(String userId, String url) async {
    await dioClient.dio.patch(
      '/users/$userId',
      data: {"imagePath": url},
    );
  }
}