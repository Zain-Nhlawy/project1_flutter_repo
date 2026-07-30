import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/department/data/models/department_member_model.dart';

abstract class DepartmentMemberState {}
class DepartmentMemberInitial extends DepartmentMemberState {}
class DepartmentMemberLoading extends DepartmentMemberState {}
class DepartmentMemberLoaded extends DepartmentMemberState {
  final List<DepartmentMemberModel> departmentMembers;

  DepartmentMemberLoaded(this.departmentMembers);
}
class DepartmentMemberError extends DepartmentMemberState {
  final String error;

  DepartmentMemberError(this.error);
}

class DepartmentMemberSearchLoading extends DepartmentMemberState {}
class DepartmentMemberSearchLoaded extends DepartmentMemberState {
  final List<MembersModel> searchResults;

  DepartmentMemberSearchLoaded(this.searchResults);
}
class DepartmentMemberSearchError extends DepartmentMemberState {
  final String error;

  DepartmentMemberSearchError(this.error);
}