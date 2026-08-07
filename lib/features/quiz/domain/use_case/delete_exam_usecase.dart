import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/domain/repositories/exam_repository.dart';

class DeleteExamUseCase {
  final ExamRepository repository;

  DeleteExamUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String sectionId,
    required String examId,
  }) {
    return repository.deleteExam(sectionId: sectionId, examId: examId);
  }
}