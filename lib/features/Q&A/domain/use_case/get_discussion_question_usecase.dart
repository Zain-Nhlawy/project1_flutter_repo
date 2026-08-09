import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class GetDiscussionQuestionUseCase {
  final DiscussionRepository repository;

  GetDiscussionQuestionUseCase(this.repository);

  Future<Either<Failure, DiscussionQuestionModel>> call({
    required String lessonId,
    required String questionId,
  }) {
    return repository.getQuestion(
      lessonId: lessonId,
      questionId: questionId,
    );
  }
}