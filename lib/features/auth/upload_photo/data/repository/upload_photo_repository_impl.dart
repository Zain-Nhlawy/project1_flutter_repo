import 'dart:io';
import 'package:project1/features/auth/upload_photo/data/data_sources/upload_photo_remote_datasource.dart';
import 'package:project1/features/auth/upload_photo/domain/repository/upload_photo_repository.dart';

class UploadPhotoRepositoryImpl implements UploadPhotoRepository {
  final UploadPhotoRemoteDataSource remoteDataSource;

  UploadPhotoRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> uploadPhoto(File file) {
    return remoteDataSource.uploadPhoto(file);
  }
}