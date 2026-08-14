import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/certification/data/models/certification_model.dart';
import 'package:project1/features/certification/domain/repositories/certification_repository.dart';

class GetCertificationByIdUseCase {
  final CertificationRepository repository;

  GetCertificationByIdUseCase(this.repository);

  Future<Either<Failure, CertificationModel>> call({
    required String certificationId,
  }) {
    return repository.getCertificationById(certificationId: certificationId);
  }
}