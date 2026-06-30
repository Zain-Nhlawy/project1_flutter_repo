import 'package:dartz/dartz.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
import 'package:project1/features/department/domain/repository/department_repository.dart';

class GetDepartmentUseCase {
  final DepartmentRepository repository;
  GetDepartmentUseCase({required this.repository});

  Future<Either<String, List<DepartmentEntity>>> call(String demoId) async {
    return await repository.getDepartment(demoId);
  }
}
