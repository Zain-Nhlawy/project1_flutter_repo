import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/rag/domain/repositories/rag_repository.dart';

class AskQuestionUseCase {
  final RagRepository repository;
  AskQuestionUseCase(this.repository);

  Future<Either<Failure, dynamic>> call({
    required String courseId,
    required String question,
  }) {
    return repository.askQuestion(courseId: courseId, question: question);
  }
}