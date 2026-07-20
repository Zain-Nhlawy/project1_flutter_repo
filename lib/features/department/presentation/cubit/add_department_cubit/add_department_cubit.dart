import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/department/data/models/department_model.dart';
import 'package:project1/features/department/domain/use_case/get_department_use_case.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';
import 'add_department_state.dart';

class AddDepartmentCubit extends Cubit<AddDepartmentState> {
  final GetDepartmentUseCase getDepartmentUseCase;

  AddDepartmentCubit(this.getDepartmentUseCase) : super(const AddDepartmentState());

  void nameChanged(String name) {
    emit(state.copyWith(name: name, status: AddDepartmentStatus.initial));
  }

  void descriptionChanged(String description) {
    emit(state.copyWith(description: description, status: AddDepartmentStatus.initial));
  }

  void managerSelected(MembersEntity manager) {
    emit(state.copyWith(selectedManager: manager, status: AddDepartmentStatus.initial));
  }

  Future<void> submit(String demoId) async {
    if (state.name.trim().isEmpty || state.description.trim().isEmpty || state.selectedManager == null) {
      emit(state.copyWith(showValidationErrors: true));
      return;
    }

    emit(state.copyWith(status: AddDepartmentStatus.loading));

    final department = DepartmentModel(
      name: state.name.trim(),
      description: state.description.trim(),
      managerId: state.selectedManager!.memberIdInDemo!,
    );

    final result = await getDepartmentUseCase.createDepartment(department, demoId);

    result.fold(
      (error) => emit(state.copyWith(
        status: AddDepartmentStatus.error,
        errorMessage: error,
      )),
      (_) => emit(state.copyWith(status: AddDepartmentStatus.success)),
    );
  }
}
