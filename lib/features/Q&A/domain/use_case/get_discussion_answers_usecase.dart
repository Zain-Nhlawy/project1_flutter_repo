import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/Q&A/data/models/paginated_discussion_answers.dart';
import 'package:project1/features/Q&A/domain/repositories/discussion_repository.dart';

class GetDiscussionAnswersUseCase {
  final DiscussionRepository repository;

  GetDiscussionAnswersUseCase(this.repository);

  Future<Either<Failure, PaginatedDiscussionAnswers>> call({
    required String questionId,
    required String demoId,
    String? cursor,
  }) {
    return repository.getAnswers(
      questionId: questionId,
      demoId: demoId,
      cursor: cursor,
    );
  }
}
