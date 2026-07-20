import 'package:dartz/dartz.dart';
import 'package:project1/features/department/data/models/department_model.dart';

abstract class DepartmentRepository {
  Future<Either<String, List<DepartmentModel>>> getDepartments(String demoId);
}
