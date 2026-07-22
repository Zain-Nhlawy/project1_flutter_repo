import 'package:dartz/dartz.dart';
import 'package:project1/features/department/data/models/department_model.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
import 'package:project1/features/department/domain/repository/department_repository.dart';

class GetDepartmentUseCase {
  final DepartmentRepository repository;
  GetDepartmentUseCase({required this.repository});

  Future<Either<String, List<DepartmentEntity>>> call(String demoId) async {
    return await repository.getDepartment(demoId);
  }


  Future<Either<String, void>> createDepartment(
    DepartmentModel department,
    String demoId,
  ) async {
    return await repository.createDepartment(department, demoId);
  }


  Future<Either<String, void>> deleteDepartment(
    String departmentId,
    String demoId,
  ) async {
    return await repository.deleteDepartment(departmentId, demoId);
  }

  
  Future<Either<String, void>> updateDepartment(
    String departmentId,
    DepartmentModel department,
    String demoId,
  ) async {
    return await repository.updateDepartment(departmentId, department, demoId);
  }
}
