import 'dart:io';
import 'package:project1/features/profile/data/data_sources/profile_remote_datasource.dart';
import 'package:project1/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<void> updateProfileImage(File file, String userId) async {
    final res = await remote.getUploadUrl(file);
    final uploadUrl = res['uploadUrl'];
    final fields = Map<String, dynamic>.from(res['fields']);
    final cdnUrl = res['cdnUrl'];
    await remote.uploadFile(uploadUrl, fields, file);
    await remote.updateProfileImage(userId, cdnUrl);
  }
}