import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/faq/domain/repository/course_faq_repository.dart';
import '../entities/course_faq_entity.dart';

class GetCourseFaqUseCase {
  final CourseFaqRepository repository;

  GetCourseFaqUseCase(this.repository);

  Future<Either<Failure, CourseFaqEntity>> call({
    required String courseId,
    required String faqId,
  }) {
    return repository.getCourseFaq(courseId: courseId, faqId: faqId);
  }
}