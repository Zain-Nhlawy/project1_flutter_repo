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
  });

  Future<Either<Failure, PaginatedDiscussionQuestions>> getQuestions({
    required String lessonId,
    String? cursor,
  });

  Future<Either<Failure, DiscussionQuestionModel>> getQuestion({
    required String lessonId,
    required String questionId,
  });

  Future<Either<Failure, DiscussionAnswerModel>> createAnswer({
    required String questionId,
    required String content,
  });

  Future<Either<Failure, PaginatedDiscussionAnswers>> getAnswers({
    required String questionId,
    String? cursor,
  });

  Future<Either<Failure, DiscussionAnswerModel>> getAnswer({
    required String questionId,
    required String answerId,
  });
}