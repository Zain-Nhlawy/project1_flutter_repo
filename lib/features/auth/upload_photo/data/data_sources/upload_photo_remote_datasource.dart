import 'dart:io';
import 'package:dio/dio.dart';
import 'package:project1/core/network/dio_client.dart';

class UploadPhotoRemoteDataSource {
  final DioClient dioClient;

  UploadPhotoRemoteDataSource(this.dioClient);

  Future<String> uploadPhoto(File file) async {
  final res = await dioClient.dio.post(
    '/users/upload-url',
    data: {
      "fileName": file.path.split('/').last,
      "contentType": "image/jpeg",
      "isPublic": true,
      "folder": "users",
    },
    options: Options(
      extra: {'noAuth': true},
    ),
  );

  final data = res.data['data'];

  final uploadUrl = data['uploadUrl'];
  final fields = Map<String, dynamic>.from(data['fields']);
  final cdnUrl = data['cdnUrl'];

  final formData = FormData.fromMap({
    ...fields,
    "file": await MultipartFile.fromFile(file.path),
  });

  await Dio().post(
    uploadUrl,
    data: formData,
    options: Options(
      contentType: 'multipart/form-data',
      headers: {
        'Accept': '*/*',
      },
    ),
  );

  return cdnUrl;
}
}