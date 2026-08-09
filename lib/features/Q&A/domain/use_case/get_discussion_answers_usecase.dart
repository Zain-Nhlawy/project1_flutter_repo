import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_answers.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class GetDiscussionAnswersUseCase {
  final DiscussionRepository repository;

  GetDiscussionAnswersUseCase(this.repository);

  Future<Either<Failure, PaginatedDiscussionAnswers>> call({
    required String questionId,
    String? cursor,
  }) {
    return repository.getAnswers(
      questionId: questionId,
      cursor: cursor,
    );
  }
}