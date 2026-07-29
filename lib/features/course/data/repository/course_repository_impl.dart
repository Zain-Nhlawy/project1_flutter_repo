import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/data/data_sources/course_remote_datasource.dart';
import 'package:project1/features/course/data/models/course_model.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl(this.remoteDataSource);

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  CourseModel _toModel(CourseEntity course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      visibility: course.visibility,
      price: course.price,
      imagePath: course.imagePath,
      demoId: course.demoId,
      tagIds: course.tagIds,
      demo: course.demo,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      sectionsCount: course.sectionsCount,
      totalLessons: course.totalLessons,
      totalDuration: course.totalDuration,
    );
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTags() {
    return _handle(() => remoteDataSource.getTags());
  }

  @override
  Future<Either<Failure, CourseEntity>> createCourse(CourseEntity course) {
    return _handle(() => remoteDataSource.createCourse(_toModel(course)));
  }

  @override
Future<Either<Failure, List<CourseEntity>>> getCourses({
  String? search,
  List<String>? tagIds,
}) {
  return _handle(
    () async {
      final courses = await remoteDataSource.getCourses(
        search: search,
        tagIds: tagIds,
      );
      return courses
          .map<CourseEntity>((course) => course)
          .toList();
    },
  );
}

  @override
  Future<Either<Failure, CourseEntity>> getCourse(String courseId) {
    return _handle(() => remoteDataSource.getCourse(courseId));
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getDemoCourses(String demoId) {
    return _handle(() => remoteDataSource.getDemoCourses(demoId));
  }

  @override
  Future<Either<Failure, CourseEntity>> getDemoCourse({
    required String demoId,
    required String assetId,
  }) {
    return _handle(
      () => remoteDataSource.getDemoCourse(demoId: demoId, assetId: assetId),
    );
  }

  @override
  Future<Either<Failure, CourseEntity>> updateCourse(
    String courseId,
    CourseEntity course,
  ) {
    return _handle(
      () => remoteDataSource.updateCourse(
        courseId: courseId,
        course: _toModel(course),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteCourse(String courseId) {
    return _handle(() => remoteDataSource.deleteCourse(courseId));
  }

  @override
  Future<Either<Failure, CourseEntity>> publishCourse(String courseId) {
    return _handle(() => remoteDataSource.publishCourse(courseId));
  }
}
