import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, void>> updateProfileImage(File file, String userId);
}
