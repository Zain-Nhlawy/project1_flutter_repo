import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/rag/domain/repositories/rag_repository.dart';

class GenerateRandomQuizUseCase {
  final RagRepository repository;
  GenerateRandomQuizUseCase(this.repository);

  Future<Either<Failure, dynamic>> call({
    required String courseId,
    required int questionCount,
  }) {
    return repository.generateRandomQuiz(
      courseId: courseId,
      questionCount: questionCount,
    );
  }
}