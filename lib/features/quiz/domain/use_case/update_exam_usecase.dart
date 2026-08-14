import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/domain/repositories/exam_repository.dart';

class UpdateExamUseCase {
  final ExamRepository repository;

  UpdateExamUseCase(this.repository);

  Future<Either<Failure, ExamModel>> call({
    required String sectionId,
    required String examId,
    required String title,
    required int numberOfQuestions,
    required int durationMinutes,
    required int passingScore,
  }) {
    return repository.updateExam(
      sectionId: sectionId,
      examId: examId,
      title: title,
      numberOfQuestions: numberOfQuestions,
      durationMinutes: durationMinutes,
      passingScore: passingScore,
    );
  }
}