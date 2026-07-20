import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/attachment/upload/data/data_sources/attachment_upload_remote_data_source.dart';
import 'package:project1/features/attachment/upload/data/models/attachment_upload_url_model.dart';
import 'package:project1/features/attachment/upload/domain/entities/attachment_upload_url_entity.dart';
import 'package:project1/features/attachment/upload/domain/repository/attachment_upload_repository.dart';

class AttachmentUploadRepositoryImpl implements AttachmentUploadRepository {
  final AttachmentUploadRemoteDataSource remoteDataSource;
  final DioClient dioClient;

  AttachmentUploadRepositoryImpl(this.remoteDataSource, this.dioClient);

  @override
  Future<Either<Failure, AttachmentUploadUrlEntity>> generateUploadUrl({
    required String lessonId,
    required String fileName,
  }) async {
    try {
      final mapData = await remoteDataSource.generateUploadUrl(
        lessonId: lessonId,
        fileName: fileName,
      );

      final entity = AttachmentUploadUrlModel.fromJson(mapData);

      return Right(entity);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadFile({
    required String uploadUrl,
    required File file,
    required String contentType,
    required void Function(double progress) onProgress,
  }) async {
    try {
      await remoteDataSource.uploadFile(
        uploadUrl: uploadUrl,
        file: file,
        contentType: contentType,
        onProgress: onProgress,
      );

      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure('Failed to upload attachment: ${e.toString()}'),
      );
    }
  }
}
