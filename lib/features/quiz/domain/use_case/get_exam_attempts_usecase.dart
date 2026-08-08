import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/paginated_exam_attempts.dart';
import 'package:project1/features/quiz/domain/repositories/exam_attempt_repository.dart';

class GetExamAttemptsUseCase {
  final ExamAttemptRepository repository;

  GetExamAttemptsUseCase(this.repository);

  Future<Either<Failure, PaginatedExamAttempts>> call({String? cursor}) {
    return repository.getExamAttempts(cursor: cursor);
  }
}