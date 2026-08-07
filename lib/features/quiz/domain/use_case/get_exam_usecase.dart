import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/domain/repositories/exam_repository.dart';

class GetExamUseCase {
  final ExamRepository repository;

  GetExamUseCase(this.repository);

  Future<Either<Failure, ExamModel>> call({
    required String sectionId,
    required String examId,
  }) {
    return repository.getExam(sectionId: sectionId, examId: examId);
  }
}