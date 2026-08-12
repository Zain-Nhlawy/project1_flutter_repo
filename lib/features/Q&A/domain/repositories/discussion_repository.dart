import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_answers.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_questions.dart';

abstract class DiscussionRepository {
  Future<Either<Failure, DiscussionQuestionModel>> createQuestion({
    required String lessonId,
    required String content,
    required String demoId,
  });

  Future<Either<Failure, PaginatedDiscussionQuestions>> getQuestions({
    required String lessonId,
    required String demoId,
    String? cursor,
  });

  Future<Either<Failure, DiscussionQuestionModel>> getQuestion({
    required String lessonId,
    required String questionId,
    required String demoId,
  });

  Future<Either<Failure, DiscussionAnswerModel>> createAnswer({
    required String questionId,
    required String content,
    required String demoId,
  });

  Future<Either<Failure, PaginatedDiscussionAnswers>> getAnswers({
    required String questionId,
    required String demoId,
    String? cursor,
  });

  Future<Either<Failure, DiscussionAnswerModel>> getAnswer({
    required String questionId,
    required String answerId,
    required String demoId,
  });

  Future<Either<Failure, DiscussionQuestionModel>> updateQuestion({
  required String lessonId,
  required String questionId,
  required String content,
  required String demoId,
});

Future<Either<Failure, void>> deleteQuestion({
  required String lessonId,
  required String questionId,
  required String demoId,
});

Future<Either<Failure, DiscussionAnswerModel>> updateAnswer({
  required String questionId,
  required String answerId,
  required String content,
  required String demoId,
});

Future<Either<Failure, void>> deleteAnswer({
  required String questionId,
  required String answerId,
  required String demoId,
});
}