import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/certification/data/models/certification_model.dart';
import 'package:project1/features/certification/domain/repositories/certification_repository.dart';

class GetMyCertificationsUseCase {
  final CertificationRepository repository;

  GetMyCertificationsUseCase(this.repository);

  Future<Either<Failure, PaginatedCertifications>> call({
    String? cursor,
  }) {
    return repository.getMyCertifications(cursor: cursor);
  }
}