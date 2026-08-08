import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/domain/repositories/exam_attempt_repository.dart';

class DeleteExamAttemptUseCase {
  final ExamAttemptRepository repository;

  DeleteExamAttemptUseCase(this.repository);

  Future<Either<Failure, void>> call({required String attemptId}) {
    return repository.deleteExamAttempt(attemptId: attemptId);
  }
}