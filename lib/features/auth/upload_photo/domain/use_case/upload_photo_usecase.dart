import 'dart:io';
import 'package:project1/features/auth/upload_photo/domain/repository/upload_photo_repository.dart';

class UploadPhotoUseCase {
  final UploadPhotoRepository repository;

  UploadPhotoUseCase(this.repository);

  Future<String> call(File file) {
    return repository.uploadPhoto(file);
  }
}