import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';

abstract class LessonVideoUploadRepository {
  Future<Either<Failure, Map<String, dynamic>>> generateUploadUrl({
    required String sectionId,
    required String fileName,
  });

  Future<Either<Failure, void>> uploadVideo({
    required String uploadUrl,
    required File file,
    required String contentType,
    required void Function(double progress) onProgress,
  });
}
