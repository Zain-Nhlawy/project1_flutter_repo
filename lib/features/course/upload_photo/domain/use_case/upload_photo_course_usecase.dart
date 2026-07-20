import 'dart:io';
import 'package:project1/features/course/upload_photo/domain/repository/upload_photo_course_repository.dart';

class UploadPhotoCourseUseCase {
  final UploadPhotoCourseRepository repository;

  UploadPhotoCourseUseCase(this.repository);

  Future<String> call(File file) {
    return repository.uploadPhoto(file);
  }
}
