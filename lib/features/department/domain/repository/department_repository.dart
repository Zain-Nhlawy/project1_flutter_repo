import 'package:dartz/dartz.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';

abstract class DepartmentRepository {
  Future<Either<String, List<DepartmentEntity>>> getDepartment(String demoId);
  
  Future<Either<String, void>> createDepartment(
    DepartmentEntity department,
    String demoId,
  );

  
  Future<Either<String, void>> deleteDepartment(
    String departmentId,
    String demoId,
  );


  Future<Either<String, void>> updateDepartment(
    String departmentId,
    DepartmentEntity department,
    String demoId,
  );
}
