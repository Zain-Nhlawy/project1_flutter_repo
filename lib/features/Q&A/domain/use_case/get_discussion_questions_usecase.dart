import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_questions.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class GetDiscussionQuestionsUseCase {
  final DiscussionRepository repository;

  GetDiscussionQuestionsUseCase(this.repository);

  Future<Either<Failure, PaginatedDiscussionQuestions>> call({
    required String lessonId,
    String? cursor,
  }) {
    return repository.getQuestions(
      lessonId: lessonId,
      cursor: cursor,
    );
  }
}