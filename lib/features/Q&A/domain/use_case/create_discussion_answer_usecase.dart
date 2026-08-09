import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class CreateDiscussionAnswerUseCase {
  final DiscussionRepository repository;

  CreateDiscussionAnswerUseCase(this.repository);

  Future<Either<Failure, DiscussionAnswerModel>> call({
    required String questionId,
    required String content,
  }) {
    return repository.createAnswer(
      questionId: questionId,
      content: content,
    );
  }
}