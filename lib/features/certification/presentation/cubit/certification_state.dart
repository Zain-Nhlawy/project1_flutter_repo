import 'package:project1/features/certification/data/models/certification_model.dart';

abstract class CertificationState {
  const CertificationState();
}

class CertificationInitial extends CertificationState {
  const CertificationInitial();
}

class CertificationLoading extends CertificationState {
  const CertificationLoading();
}

class MyCertificationsLoaded extends CertificationState {
  final List<CertificationModel> certifications;
  final bool hasNextPage;
  final String? endCursor;

  const MyCertificationsLoaded({
    required this.certifications,
    required this.hasNextPage,
    this.endCursor,
  });
}

class CertificationDetailsLoaded extends CertificationState {
  final CertificationModel certification;

  const CertificationDetailsLoaded(this.certification);
}

class CertificationError extends CertificationState {
  final List<String> errors;

  const CertificationError(this.errors);
}