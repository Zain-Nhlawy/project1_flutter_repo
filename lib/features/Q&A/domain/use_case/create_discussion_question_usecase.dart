import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class CreateDiscussionQuestionUseCase {
  final DiscussionRepository repository;

  CreateDiscussionQuestionUseCase(this.repository);

  Future<Either<Failure, DiscussionQuestionModel>> call({
    required String lessonId,
    required String content,
    required String demoId,
  }) {
    return repository.createQuestion(
      lessonId: lessonId,
      content: content,
      demoId: demoId,
    );
  }
}