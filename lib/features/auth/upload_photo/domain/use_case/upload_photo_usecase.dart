import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/upload_photo/domain/repository/upload_photo_repository.dart';

class UploadPhotoUseCase {
  final UploadPhotoRepository repository;

  UploadPhotoUseCase(this.repository);

  Future<Either<Failure, String>> call(File file) {
    return repository.uploadPhoto(file);
  }
}
