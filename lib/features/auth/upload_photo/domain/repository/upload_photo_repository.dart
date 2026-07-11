import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';

abstract class UploadPhotoRepository {
  Future<Either<Failure, String>> uploadPhoto(File file);
}