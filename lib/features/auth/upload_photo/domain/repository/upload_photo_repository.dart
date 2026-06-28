import 'dart:io';

abstract class UploadPhotoRepository {
  Future<String> uploadPhoto(File file);
}