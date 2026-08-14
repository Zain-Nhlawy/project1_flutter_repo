import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class DeleteDiscussionQuestionUseCase {
  final DiscussionRepository repository;

  DeleteDiscussionQuestionUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String lessonId,
    required String questionId,
    required String demoId,
  }) {
    return repository.deleteQuestion(
      lessonId: lessonId,
      questionId: questionId,
      demoId: demoId,
    );
  }
}