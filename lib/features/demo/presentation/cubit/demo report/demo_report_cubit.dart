import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/domain/use%20case/get_demo_owner_report_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20report/demo_report_state.dart';

class DemoReportCubit extends Cubit<DemoReportState> {
  final GetDemoOwnerReportUseCase getOwnerReportUseCase;

  DemoReportCubit({required this.getOwnerReportUseCase})
    : super(const DemoReportInitial());

  Future<void> fetchReport(String demoId) async {
    emit(const DemoReportLoading());

    final result = await getOwnerReportUseCase(demoId);
    result.fold(
      (error) => emit(DemoReportError(error)),
      (report) => emit(DemoReportLoaded(report)),
    );
  }
}
