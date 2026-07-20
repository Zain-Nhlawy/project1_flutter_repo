import 'package:dartz/dartz.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/department/data/data_sources/department_data_source.dart';
import 'package:project1/features/department/data/models/department_model.dart';
import 'package:project1/features/department/domain/repository/department_repository.dart';

class DepartmentRepositoryImplement implements DepartmentRepository {
  final DepartmentRemoteDataSource remoteDataSource;

  DepartmentRepositoryImplement(
    DioClient dioClient, {
    required this.remoteDataSource,
  });

  @override
  Future<Either<String, List<DepartmentModel>>> getDepartment(
    String demoId,
  ) async {
    try {
      final result = await remoteDataSource.getDepartment(demoId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
