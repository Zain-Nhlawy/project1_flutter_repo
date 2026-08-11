import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_token_entity.dart';

abstract class LiveStreamRepository {
  Future<Either<Failure, List<LiveStreamEntity>>> getLiveStreams({
    required String departmentId,
    String? demoId,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, LiveStreamEntity>> getLiveStreamDetails(
    String id, {
    required String departmentId,
    String? demoId,
  });

  Future<Either<Failure, LiveStreamEntity>> createLiveStream({
    required String title,
    required String description,
    required String scheduledAt,
    required String departmentId,
    String? demoId,
  });

  Future<Either<Failure, LiveStreamEntity>> updateLiveStream({
    required String id,
    required String departmentId,
    String? demoId,
    String? title,
    String? description,
    String? scheduledAt,
  });

  Future<Either<Failure, LiveStreamEntity>> startLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  });

  Future<Either<Failure, LiveStreamEntity>> endLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  });

  Future<Either<Failure, LiveStreamTokenEntity>> getLiveStreamToken(
    String id, {
    required String departmentId,
    String? demoId,
  });
}
