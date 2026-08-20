import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/Q&A/data/models/paginated_discussion_questions.dart';
import 'package:project1/features/Q&A/domain/repositories/discussion_repository.dart';

class GetDiscussionQuestionsUseCase {
  final DiscussionRepository repository;

  GetDiscussionQuestionsUseCase(this.repository);

  Future<Either<Failure, PaginatedDiscussionQuestions>> call({
    required String lessonId,
    required String demoId,
    String? cursor,
  }) {
    return repository.getQuestions(
      lessonId: lessonId,
      demoId: demoId,
      cursor: cursor,
    );
  }
}
