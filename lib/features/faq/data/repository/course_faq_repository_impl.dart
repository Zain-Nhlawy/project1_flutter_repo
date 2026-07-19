import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/faq/data/data_sources/course_faq_remote_data_source.dart';
import 'package:project1/features/faq/domain/entities/course_faq_entity.dart';
import 'package:project1/features/faq/domain/repository/course_faq_repository.dart';

class CourseFaqRepositoryImpl implements CourseFaqRepository {
  final CourseFaqRemoteDataSource remoteDataSource;

  CourseFaqRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CourseFaqEntity>> createCourseFaq({
    required String courseId,
    required String question,
    required String answer,
  }) {
    return _handle(
      () => remoteDataSource.createCourseFaq(
        courseId: courseId,
        question: question,
        answer: answer,
      ),
    );
  }

  @override
  Future<Either<Failure, CourseFaqEntity>> getCourseFaq({
    required String courseId,
    required String faqId,
  }) {
    return _handle(
      () => remoteDataSource.getCourseFaq(
        courseId: courseId,
        faqId: faqId,
      ),
    );
  }

  @override
  Future<Either<Failure, List<CourseFaqEntity>>> getCourseFaqs({
    required String courseId,
    String? cursor,
  }) {
    return _handle(
      () => remoteDataSource.getCourseFaqs(
        courseId: courseId,
        cursor: cursor,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteCourseFaq({
    required String courseId,
    required String faqId,
  }) {
    return _handle(
      () => remoteDataSource.deleteCourseFaq(
        courseId: courseId,
        faqId: faqId,
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