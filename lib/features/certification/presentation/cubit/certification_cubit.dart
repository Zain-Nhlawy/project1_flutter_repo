import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/certification/domain/use_case/get_certification_by_id_usecase.dart';
import 'package:project1/features/certification/domain/use_case/get_my_certifications_usecase.dart';
import 'certification_state.dart';

class CertificationCubit extends Cubit<CertificationState> {
  final GetMyCertificationsUseCase getMyCertificationsUseCase;
  final GetCertificationByIdUseCase getCertificationByIdUseCase;

  CertificationCubit({
    required this.getMyCertificationsUseCase,
    required this.getCertificationByIdUseCase,
  }) : super(const CertificationInitial());

  List<String> _errorsOf(Failure failure) {
    final errors = failure.errors;
    if (errors != null && errors.isNotEmpty) {
      return errors;
    }
    return [failure.message];
  }

  Future<void> fetchMyCertifications({String? cursor}) async {
    emit(const CertificationLoading());

    final result = await getMyCertificationsUseCase(cursor: cursor);

    result.fold(
      (failure) => emit(CertificationError(_errorsOf(failure))),
      (data) => emit(
        MyCertificationsLoaded(
          certifications: data.items,
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      ),
    );
  }

  Future<void> fetchCertificationById(String certificationId) async {
    emit(const CertificationLoading());

    final result = await getCertificationByIdUseCase(
      certificationId: certificationId,
    );

    result.fold(
      (failure) => emit(CertificationError(_errorsOf(failure))),
      (data) => emit(CertificationDetailsLoaded(data)),
    );
  }
}