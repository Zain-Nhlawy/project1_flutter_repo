import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/rag/domain/repositories/rag_repository.dart';

class GenerateTopicQuizUseCase {
  final RagRepository repository;
  GenerateTopicQuizUseCase(this.repository);

  Future<Either<Failure, dynamic>> call({
    required String courseId,
    required String topic,
    required int questionCount,
  }) {
    return repository.generateTopicQuiz(
      courseId: courseId,
      topic: topic,
      questionCount: questionCount,
    );
  }
}