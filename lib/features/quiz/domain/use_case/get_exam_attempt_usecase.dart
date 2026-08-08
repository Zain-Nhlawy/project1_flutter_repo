import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';
import 'package:project1/features/quiz/domain/repositories/exam_attempt_repository.dart';

class GetExamAttemptUseCase {
  final ExamAttemptRepository repository;

  GetExamAttemptUseCase(this.repository);

  Future<Either<Failure, ExamAttemptModel>> call({required String attemptId}) {
    return repository.getExamAttempt(attemptId: attemptId);
  }
}