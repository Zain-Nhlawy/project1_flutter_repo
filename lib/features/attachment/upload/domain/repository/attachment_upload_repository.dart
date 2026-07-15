import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/upload/domain/entities/attachment_upload_url_entity.dart';

abstract class AttachmentUploadRepository {
  Future<Either<Failure, AttachmentUploadUrlEntity>> generateUploadUrl({
    required String lessonId,
    required String fileName,
  });

  Future<Either<Failure, void>> uploadFile({
    required String uploadUrl,
    required File file,
    required String contentType,
    required void Function(double progress) onProgress,
  });
}