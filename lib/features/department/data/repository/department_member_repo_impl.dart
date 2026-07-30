import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/department/data/data_sources/department_member_datasource.dart';
import 'package:project1/features/department/data/models/department_member_model.dart';
import 'package:project1/features/department/domain/repository/department_member_repository.dart';

class DepartmentMemberRepositoryImpl implements DepartmentMemberRepository {
  final DepartmentMemberDataSource dataSource;

  DepartmentMemberRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, List<DepartmentMemberModel>>> getDepartmentMembers(
    String departmentId,
    String demoId,
  ) async {
    try {
      final result = await dataSource.getDepartmentMembers(departmentId, demoId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
  @override
  Future<Either<String, void>> addDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
    String jobTitle,
  ) async {
    try {
      final result = await dataSource.addDepartmentMember(departmentId, demoId, demoMemberId, jobTitle);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
  @override
  Future<Either<String, void>> removeDepartmentMember(
    String departmentId,
    String demoId,
    String demoMemberId,
  ) async {
    try {
      final result = await dataSource.removeDepartmentMember(departmentId, demoId, demoMemberId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
  @override
  Future<Either<String, List<MembersModel>>> searchDemoMembers(
    String departmentId,
    String demoId,
    String query,
  ) async {
    try {
      final result = await dataSource.searchDemoMembers(departmentId, demoId, query);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}