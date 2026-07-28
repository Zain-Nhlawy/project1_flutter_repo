import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/data/data_sources/department_course_remote_data_source.dart';
import 'package:project1/features/course/domain/entities/department_course_entity.dart';
import 'package:project1/features/course/domain/repository/department_course_repository.dart';

class DepartmentCourseRepositoryImpl implements DepartmentCourseRepository {
  final DepartmentCourseRemoteDataSource remoteDataSource;

  DepartmentCourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DepartmentCourseEntity>> createDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String assetId,
  }) {
    return _handle(
      () => remoteDataSource.createDepartmentCourse(
        demoId: demoId,
        departmentId: departmentId,
        assetId: assetId,
      ),
    );
  }

  @override
  Future<Either<Failure, List<DepartmentCourseEntity>>> getDepartmentCourses({
    required String demoId,
    required String departmentId,
    String? cursor,
  }) {
    return _handle(
      () => remoteDataSource.getDepartmentCourses(
        demoId: demoId,
        departmentId: departmentId,
        cursor: cursor,
      ),
    );
  }

  @override
  Future<Either<Failure, DepartmentCourseEntity>> getDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  }) {
    return _handle(
      () => remoteDataSource.getDepartmentCourse(
        demoId: demoId,
        departmentId: departmentId,
        departmentCourseId: departmentCourseId,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  }) {
    return _handle(
      () => remoteDataSource.deleteDepartmentCourse(
        demoId: demoId,
        departmentId: departmentId,
        departmentCourseId: departmentCourseId,
      ),
    );
  }

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}