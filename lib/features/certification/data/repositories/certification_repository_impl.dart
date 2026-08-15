import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/certification/data/data_sources/certification_remote_data_source.dart';
import 'package:project1/features/certification/data/models/certification_model.dart';
import 'package:project1/features/certification/domain/repositories/certification_repository.dart';

class CertificationRepositoryImpl implements CertificationRepository {
  final CertificationRemoteDataSource remoteDataSource;

  CertificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedCertifications>> getMyCertifications({
    String? cursor,
  }) async {
    try {
      final result = await remoteDataSource.getMyCertifications(
        cursor: cursor,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CertificationModel>> getCertificationById({
    required String certificationId,
  }) async {
    try {
      final result = await remoteDataSource.getCertificationById(
        certificationId: certificationId,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}