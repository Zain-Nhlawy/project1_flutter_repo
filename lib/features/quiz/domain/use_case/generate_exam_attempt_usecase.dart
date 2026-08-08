import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/generated_exam_model.dart';
import 'package:project1/features/quiz/domain/repositories/exam_attempt_repository.dart';

class GenerateExamAttemptUseCase {
  final ExamAttemptRepository repository;

  GenerateExamAttemptUseCase(this.repository);

  Future<Either<Failure, GeneratedExamModel>> call({required String examId}) {
    return repository.generateExamAttempt(examId: examId);
  }
}