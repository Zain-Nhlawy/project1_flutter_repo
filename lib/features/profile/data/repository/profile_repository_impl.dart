import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/profile/data/data_sources/profile_remote_datasource.dart';
import 'package:project1/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, void>> updateProfileImage(
    File file,
    String userId,
  ) async {
    try {
      final res = await remote.getUploadUrl(file);

      final uploadUrl = res['uploadUrl'];
      final cdnUrl = res['cdnUrl'];

      await remote.uploadFile(uploadUrl, file);

      await remote.updateProfileImage(userId, cdnUrl);

      return const Right(null);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
