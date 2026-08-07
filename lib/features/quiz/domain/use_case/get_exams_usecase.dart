import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/paginated_exams.dart';
import 'package:project1/features/quiz/domain/repositories/exam_repository.dart';

class GetExamsUseCase {
  final ExamRepository repository;

  GetExamsUseCase(this.repository);

  Future<Either<Failure, PaginatedExams>> call({
    required String sectionId,
    String? cursor,
  }) {
    return repository.getExams(sectionId: sectionId, cursor: cursor);
  }
}