import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';

abstract class RagRepository {
  Future<Either<Failure, dynamic>> askQuestion({
    required String courseId,
    required String question,
  });

  Future<Either<Failure, dynamic>> generateTopicQuiz({
    required String courseId,
    required String topic,
    required int questionCount,
  });

  Future<Either<Failure, dynamic>> generateRandomQuiz({
    required String courseId,
    required int questionCount,
  });
}