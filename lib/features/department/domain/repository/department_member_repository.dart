import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/department/data/models/department_member_model.dart';

abstract class DepartmentMemberRepository {
  Future<Either<String, List<DepartmentMemberModel>>> getDepartmentMembers(
    String departmentId,
    String demoId,
  );
  Future<Either<String, void>> addDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
    String jobTitle,
  );
  Future<Either<String, void>> removeDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
  );
  Future<Either<String, List<MembersModel>>> searchDemoMembers(
    String departmentId,
    String demoId,
    String query,
  );
}
