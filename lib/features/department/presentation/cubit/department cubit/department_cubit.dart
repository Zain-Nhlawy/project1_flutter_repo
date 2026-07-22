import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/department/data/models/department_model.dart';
import 'package:project1/features/department/presentation/cubit/department%20cubit/department_state.dart';
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

  Future<void> createDepartment(
    DepartmentModel department,
    String demoId,
  ) async {
    emit(DepartmentLoading());

    final result = await getDepartmentUseCase.createDepartment(
      department,
      demoId,
    );

    result.fold(
      (error) => emit(DepartmentError(error)),
      (_) => emit(DepartmentCreated()),
    );
  }

  Future<void> deleteDepartment(String departmentId, String demoId) async {
    emit(DepartmentLoading());

    final result = await getDepartmentUseCase.deleteDepartment(
      departmentId,
      demoId,
    );

    result.fold(
      (error) => emit(DepartmentError(error)),
      (_) => emit(DepartmentDeleted()),
    );
  }

  Future<void> updateDepartment(
    String departmentId,
    DepartmentModel department,
    String demoId,
  ) async {
    emit(DepartmentLoading());

    final result = await getDepartmentUseCase.updateDepartment(
      departmentId,
      department,
      demoId,
    );

    result.fold(
      (error) => emit(DepartmentError(error)),
      (_) => emit(DepartmentUpdated()),
    );
  }
}
