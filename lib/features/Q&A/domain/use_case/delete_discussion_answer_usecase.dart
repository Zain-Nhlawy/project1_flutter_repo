import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class DeleteDiscussionAnswerUseCase {
  final DiscussionRepository repository;

  DeleteDiscussionAnswerUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String questionId,
    required String answerId,
    required String demoId,
  }) {
    return repository.deleteAnswer(
      questionId: questionId,
      answerId: answerId,
      demoId: demoId,
    );
  }
}