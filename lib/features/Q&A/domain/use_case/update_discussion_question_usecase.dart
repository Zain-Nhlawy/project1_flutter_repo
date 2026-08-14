import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class UpdateDiscussionQuestionUseCase {
  final DiscussionRepository repository;

  UpdateDiscussionQuestionUseCase(this.repository);

  Future<Either<Failure, DiscussionQuestionModel>> call({
    required String lessonId,
    required String questionId,
    required String content,
    required String demoId,
  }) {
    return repository.updateQuestion(
      lessonId: lessonId,
      questionId: questionId,
      content: content,
      demoId: demoId,
    );
  }
}