import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/certification/data/models/certification_model.dart';

abstract class CertificationRepository {
  Future<Either<Failure, PaginatedCertifications>> getMyCertifications({
    String? cursor,
  });

  Future<Either<Failure, CertificationModel>> getCertificationById({
    required String certificationId,
  });
}