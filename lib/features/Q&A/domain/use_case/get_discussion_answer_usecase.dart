import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class GetDiscussionAnswerUseCase {
  final DiscussionRepository repository;

  GetDiscussionAnswerUseCase(this.repository);

  Future<Either<Failure, DiscussionAnswerModel>> call({
    required String questionId,
    required String answerId,
    required String demoId,
  }) {
    return repository.getAnswer(
      questionId: questionId,
      answerId: answerId,
      demoId: demoId,
    );
  }
}