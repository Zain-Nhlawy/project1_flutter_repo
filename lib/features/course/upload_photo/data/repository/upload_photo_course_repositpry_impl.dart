import 'dart:io';
import 'package:project1/features/course/upload_photo/data/data_sources/upload_photo_course_remote_datasource.dart';
import 'package:project1/features/course/upload_photo/domain/repository/upload_photo_course_repository.dart';


class UploadPhotoCourseRepositoryImpl implements UploadPhotoCourseRepository {
  final UploadPhotoCourseRemoteDataSource remoteDataSource;

  UploadPhotoCourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> uploadPhoto(File file) {
    return remoteDataSource.uploadPhoto(file);
  }
}