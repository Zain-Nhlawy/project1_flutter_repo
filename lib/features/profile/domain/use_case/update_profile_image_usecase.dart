import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  Future<Either<Failure, void>> call(
    File file,
    String userId,
  ) {
    return repository.updateProfileImage(file, userId);
  }
}