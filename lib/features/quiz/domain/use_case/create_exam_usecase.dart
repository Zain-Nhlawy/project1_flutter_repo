import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/domain/repositories/exam_repository.dart';

class CreateExamUseCase {
  final ExamRepository repository;

  CreateExamUseCase(this.repository);

  Future<Either<Failure, ExamModel>> call({
    required String sectionId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
  }) {
    return repository.createExam(
      sectionId: sectionId,
      title: title,
      numberOfQuestions: numberOfQuestions,
      durationMinutes: durationMinutes,
    );
  }
}