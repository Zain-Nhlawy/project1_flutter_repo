import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/upload_video/data/data_sources/lesson_video_upload_remote_datasource.dart';
import 'package:project1/features/lesson/upload_video/domain/repository/lesson_video_upload_repository.dart';

class LessonVideoUploadRepositoryImpl
    implements LessonVideoUploadRepository {
  final LessonVideoUploadRemoteDataSource remoteDataSource;

  LessonVideoUploadRepositoryImpl(this.remoteDataSource);

  Future<Either<Failure, T>> _handle<T>(
    Future<T> Function() call,
  ) async {
    try {
      return Right(await call());
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> generateUploadUrl({
    required String sectionId,
    required String fileName,
  }) {
    return _handle(
      () => remoteDataSource.generateUploadUrl(
        sectionId: sectionId,
        fileName: fileName,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> uploadVideo({
    required String uploadUrl,
    required File file,
    required String contentType,
    required void Function(double progress) onProgress,
  }) {
    return _handle(
      () => remoteDataSource.uploadVideo(
        uploadUrl: uploadUrl,
        file: file,
        contentType: contentType,
        onProgress: onProgress,
      ),
    );
  }
}