import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/section/data/data_sources/section_remote_datasource.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';

class SectionRepositoryImpl implements SectionRepository {
  final SectionRemoteDataSource remoteDataSource;

  SectionRepositoryImpl(this.remoteDataSource);

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SectionEntity>> createSection({
    required String courseId,
    required String title,
    required int order,
  }) {
    return _handle(
      () => remoteDataSource.createSection(
        courseId: courseId,
        title: title,
        order: order,
      ),
    );
  }

  @override
  Future<Either<Failure, SectionEntity>> getSection({
    required String courseId,
    required String sectionId,
  }) {
    return _handle(
      () =>
          remoteDataSource.getSection(courseId: courseId, sectionId: sectionId),
    );
  }

  @override
  Future<Either<Failure, SectionEntity>> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  }) {
    return _handle(
      () => remoteDataSource.updateSection(
        courseId: courseId,
        sectionId: sectionId,
        title: title,
        order: order,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteSection({
    required String courseId,
    required String sectionId,
  }) {
    return _handle(
      () => remoteDataSource.deleteSection(
        courseId: courseId,
        sectionId: sectionId,
      ),
    );
  }

  @override
  Future<Either<Failure, List<SectionEntity>>> getSections({
    required String courseId,
  }) {
    return _handle(() => remoteDataSource.getSections(courseId: courseId));
  }
}
