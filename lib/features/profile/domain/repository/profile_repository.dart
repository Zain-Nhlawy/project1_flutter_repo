import 'dart:io';

abstract class ProfileRepository {
  Future<void> updateProfileImage(File file, String userId);
}