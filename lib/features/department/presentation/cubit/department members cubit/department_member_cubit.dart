import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/department/domain/repository/department_member_repository.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/deprtment_member_state.dart';

class DepartmentMemberCubit extends Cubit<DepartmentMemberState> {
  final DepartmentMemberRepository _departmentMemberRepository;

  DepartmentMemberCubit(this._departmentMemberRepository)
    : super(DepartmentMemberInitial());

  Future<void> getDepartmentMembers(String departmentId, String demoId) async {
    emit(DepartmentMemberLoading());
    final result = await _departmentMemberRepository.getDepartmentMembers(
      departmentId,
      demoId,
    );
    result.fold(
      (error) => emit(DepartmentMemberError(error)),
      (departmentMembers) => emit(DepartmentMemberLoaded(departmentMembers)),
    );
  }

  Future<void> addDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
    String jobTitle,
  ) async {
    emit(DepartmentMemberLoading());
    final result = await _departmentMemberRepository.addDepartmentMember(
      departmentId,
      demoId,
      demoMemberId,
      jobTitle,
    );
    result.fold(
      (error) => emit(DepartmentMemberError(error)),
      (_) => getDepartmentMembers(departmentId, demoId),
    );
  }

  Future<bool> removeDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
  ) async {
    emit(DepartmentMemberLoading());
    final result = await _departmentMemberRepository.removeDepartmentMember(
      departmentId,
      demoId,
      demoMemberId,
    );
    return result.fold(
      (error) {
        emit(DepartmentMemberError(error));
        return false;
      },
      (_) {
        getDepartmentMembers(departmentId, demoId);
        return true;
      },
    );
  }

  Future<void> searchDemoMembers(
    String departmentId,        
    String demoId,
    String query,
  ) async {
    emit(DepartmentMemberSearchLoading());
    final result = await _departmentMemberRepository.searchDemoMembers(
      departmentId,
      demoId,
      query,
    );
    result.fold(
      (error) => emit(DepartmentMemberSearchError(error)),
      (searchResults) => emit(DepartmentMemberSearchLoaded(searchResults)),
    );
  }
}
