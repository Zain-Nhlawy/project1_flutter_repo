import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/faq/domain/repository/course_faq_repository.dart';

class DeleteCourseFaqUseCase {
  final CourseFaqRepository repository;

  DeleteCourseFaqUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String courseId,
    required String faqId,
  }) {
    return repository.deleteCourseFaq(courseId: courseId, faqId: faqId);
  }
}
