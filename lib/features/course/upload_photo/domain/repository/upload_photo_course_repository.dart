import 'dart:io';

abstract class UploadPhotoCourseRepository {
  Future<String> uploadPhoto(File file);
}