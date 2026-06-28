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
        "contentType": "image/jpeg",
        "isPublic": true,
        "folder": "users",
      },
    );
    return res.data['data'];
  }

  Future<void> uploadFile(
    String uploadUrl,
    Map<String, dynamic> fields,
    File file,
  ) async {
    final formData = FormData.fromMap({
      ...fields,
      "file": await MultipartFile.fromFile(file.path),
    });
    await Dio().post(
      uploadUrl,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
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