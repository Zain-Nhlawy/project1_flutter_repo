import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/presentation/cubit/department_state.dart';
import 'package:project1/features/department/domain/use_case/get_department_use_case.dart';
class DepartmentCubit extends Cubit<DepartmentState> {
  final GetDepartmentUseCase getDepartmentUseCase;

  DepartmentCubit(this.getDepartmentUseCase) : super(DepartmentInitial());

  Future<void> fetchDepartments(String demoId) async {
    emit(DepartmentLoading());

    final result = await getDepartmentUseCase(demoId);

    result.fold(
      (error) => emit(DepartmentError(error)),
      (departments) => emit(DepartmentLoaded(departments)),
    );
  }
}