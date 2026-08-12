import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/q&a/data/data_sources/discussion_remote_data_source.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_answers.dart';
import 'package:project1/features/q&a/data/models/paginated_discussion_questions.dart';
import 'package:project1/features/q&a/domain/repositories/discussion_repository.dart';

class DiscussionRepositoryImpl implements DiscussionRepository {
  final DiscussionRemoteDataSource remoteDataSource;

  DiscussionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DiscussionQuestionModel>> createQuestion({
    required String lessonId,
    required String content,
    required String demoId,
  }) async {
    try {
      final result = await remoteDataSource.createQuestion(
        lessonId: lessonId,
        content: content,
        demoId: demoId,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedDiscussionQuestions>> getQuestions({
    required String lessonId,
    required String demoId,
    String? cursor,
  }) async {
    try {
      final result = await remoteDataSource.getQuestions(
        lessonId: lessonId,
        demoId: demoId,
        cursor: cursor,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DiscussionQuestionModel>> getQuestion({
    required String lessonId,
    required String questionId,
    required String demoId,
  }) async {
    try {
      final result = await remoteDataSource.getQuestion(
        lessonId: lessonId,
        questionId: questionId,
        demoId: demoId,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DiscussionAnswerModel>> createAnswer({
    required String questionId,
    required String content,
    required String demoId,
  }) async {
    try {
      final result = await remoteDataSource.createAnswer(
        questionId: questionId,
        content: content,
        demoId: demoId,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedDiscussionAnswers>> getAnswers({
    required String questionId,
    required String demoId,
    String? cursor,
  }) async {
    try {
      final result = await remoteDataSource.getAnswers(
        questionId: questionId,
        demoId: demoId,
        cursor: cursor,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DiscussionAnswerModel>> getAnswer({
    required String questionId,
    required String answerId,
    required String demoId,
  }) async {
    try {
      final result = await remoteDataSource.getAnswer(
        questionId: questionId,
        answerId: answerId,
        demoId: demoId,
      );

      return Right(result);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
Future<Either<Failure, DiscussionQuestionModel>> updateQuestion({
  required String lessonId,
  required String questionId,
  required String content,
  required String demoId,
}) async {
  try {
    final result = await remoteDataSource.updateQuestion(
      lessonId: lessonId,
      questionId: questionId,
      content: content,
      demoId: demoId,
    );

    return Right(result);
  } on Exception catch (e) {
    return Left(mapExceptionToFailure(e));
  }
}

@override
Future<Either<Failure, void>> deleteQuestion({
  required String lessonId,
  required String questionId,
  required String demoId,
}) async {
  try {
    await remoteDataSource.deleteQuestion(
      lessonId: lessonId,
      questionId: questionId,
      demoId: demoId,
    );

    return const Right(null);
  } on Exception catch (e) {
    return Left(mapExceptionToFailure(e));
  }
}

@override
Future<Either<Failure, DiscussionAnswerModel>> updateAnswer({
  required String questionId,
  required String answerId,
  required String content,
  required String demoId,
}) async {
  try {
    final result = await remoteDataSource.updateAnswer(
      questionId: questionId,
      answerId: answerId,
      content: content,
      demoId: demoId,
    );

    return Right(result);
  } on Exception catch (e) {
    return Left(mapExceptionToFailure(e));
  }
}

@override
Future<Either<Failure, void>> deleteAnswer({
  required String questionId,
  required String answerId,
  required String demoId,
}) async {
  try {
    await remoteDataSource.deleteAnswer(
      questionId: questionId,
      answerId: answerId,
      demoId: demoId,
    );

    return const Right(null);
  } on Exception catch (e) {
    return Left(mapExceptionToFailure(e));
  }
}
}