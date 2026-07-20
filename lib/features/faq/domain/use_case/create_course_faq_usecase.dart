import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/faq/domain/repository/course_faq_repository.dart';
import '../entities/course_faq_entity.dart';

class CreateCourseFaqUseCase {
  final CourseFaqRepository repository;

  CreateCourseFaqUseCase(this.repository);

  Future<Either<Failure, CourseFaqEntity>> call({
    required String courseId,
    required String question,
    required String answer,
  }) {
    return repository.createCourseFaq(
      courseId: courseId,
      question: question,
      answer: answer,
    );
  }
}
