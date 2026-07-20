import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/upload_photo/data/data_sources/upload_photo_remote_datasource.dart';
import 'package:project1/features/auth/upload_photo/domain/repository/upload_photo_repository.dart';

class UploadPhotoRepositoryImpl implements UploadPhotoRepository {
  final UploadPhotoRemoteDataSource remoteDataSource;

  UploadPhotoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> uploadPhoto(File file) async {
    try {
      final result = await remoteDataSource.uploadPhoto(file);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
