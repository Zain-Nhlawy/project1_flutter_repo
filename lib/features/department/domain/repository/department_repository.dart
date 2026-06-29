import 'package:dartz/dartz.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';

abstract class DepartmentRepository {
  Future<Either<String, List<DepartmentEntity>>> getDepartment(String demoId);
}