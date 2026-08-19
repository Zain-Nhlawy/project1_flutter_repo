import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/department/data/models/department_member_model.dart';
import 'package:project1/features/department/domain/repository/department_member_repository.dart';

class DepartmentMemberUseCase {
  final DepartmentMemberRepository repository;

  DepartmentMemberUseCase({required this.repository});

  Future<Either<String, List<DepartmentMemberModel>>> getDepartmentMembers(
    String departmentId,
    String demoId,
  ) async {
    return await repository.getDepartmentMembers(departmentId, demoId);
  }
  Future<Either<String, void>> addDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
    String jobTitle,
  ) async {
    return await repository.addDepartmentMember(departmentId, demoId, demoMemberId, jobTitle);
  }
  Future<Either<String, void>> removeDepartmentMember(
    String departmentId,
    String demoId,
    String departmentMemberId,
  ) async {
    return await repository.removeDepartmentMember(departmentId, demoId, departmentMemberId);
  }
  Future<Either<String, List<MembersModel>>> searchDemoMembers(
    String departmentId,
    String demoId,
    String query,
  ) async {
    return await repository.searchDemoMembers(departmentId, demoId, query);
  }
}
