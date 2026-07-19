import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/faq/domain/repository/course_faq_repository.dart';
import '../entities/course_faq_entity.dart';

class GetCourseFaqsUseCase {
  final CourseFaqRepository repository;

  GetCourseFaqsUseCase(this.repository);

  Future<Either<Failure, List<CourseFaqEntity>>> call({
    required String courseId,
    String? cursor,
  }) {
    return repository.getCourseFaqs(courseId: courseId, cursor: cursor);
  }
}