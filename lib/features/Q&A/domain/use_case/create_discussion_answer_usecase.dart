import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/Q&A/data/models/discussion_answer_model.dart';
import 'package:project1/features/Q&A/domain/repositories/discussion_repository.dart';

class CreateDiscussionAnswerUseCase {
  final DiscussionRepository repository;

  CreateDiscussionAnswerUseCase(this.repository);

  Future<Either<Failure, DiscussionAnswerModel>> call({
    required String questionId,
    required String content,
    required String demoId,
  }) {
    return repository.createAnswer(
      questionId: questionId,
      content: content,
      demoId: demoId,
    );
  }
}
