import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/Q&A/data/models/discussion_answer_model.dart';
import 'package:project1/features/Q&A/domain/repositories/discussion_repository.dart';

class UpdateDiscussionAnswerUseCase {
  final DiscussionRepository repository;

  UpdateDiscussionAnswerUseCase(this.repository);

  Future<Either<Failure, DiscussionAnswerModel>> call({
    required String questionId,
    required String answerId,
    required String content,
    required String demoId,
  }) {
    return repository.updateAnswer(
      questionId: questionId,
      answerId: answerId,
      content: content,
      demoId: demoId,
    );
  }
}
