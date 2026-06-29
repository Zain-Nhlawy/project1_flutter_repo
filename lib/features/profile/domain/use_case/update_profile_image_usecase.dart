import 'dart:io';
import 'package:project1/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  Future<void> call(File file, String userId) {
    return repository.updateProfileImage(file, userId);
  }
}