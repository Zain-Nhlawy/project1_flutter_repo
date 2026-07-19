import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../entities/course_faq_entity.dart';

abstract class CourseFaqRepository {
  Future<Either<Failure, CourseFaqEntity>> createCourseFaq({
    required String courseId,
    required String question,
    required String answer,
  });

  Future<Either<Failure, CourseFaqEntity>> getCourseFaq({
    required String courseId,
    required String faqId,
  });

  Future<Either<Failure, List<CourseFaqEntity>>> getCourseFaqs({
    required String courseId,
    String? cursor,
  });

  Future<Either<Failure, void>> deleteCourseFaq({
    required String courseId,
    required String faqId,
  });
}