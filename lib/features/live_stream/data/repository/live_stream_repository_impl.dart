import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/live_stream/data/data_sources/live_stream_remote_data_source.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_token_entity.dart';
import 'package:project1/features/live_stream/domain/repository/live_stream_repository.dart';

class LiveStreamRepositoryImpl implements LiveStreamRepository {
  final LiveStreamRemoteDataSource remoteDataSource;

  LiveStreamRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<LiveStreamEntity>>> getLiveStreams({
    required String departmentId,
    String? demoId,
    String? cursor,
    int? limit,
  }) async {
    try {
      final result = await remoteDataSource.getLiveStreams(
        departmentId: departmentId,
        demoId: demoId,
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> getLiveStreamDetails(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final result = await remoteDataSource.getLiveStreamDetails(
        id,
        departmentId: departmentId,
        demoId: demoId,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> createLiveStream({
    required String title,
    required String description,
    required String scheduledAt,
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final result = await remoteDataSource.createLiveStream(
        title: title,
        description: description,
        scheduledAt: scheduledAt,
        departmentId: departmentId,
        demoId: demoId,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> updateLiveStream({
    required String id,
    required String departmentId,
    String? demoId,
    String? title,
    String? description,
    String? scheduledAt,
  }) async {
    try {
      final result = await remoteDataSource.updateLiveStream(
        id: id,
        departmentId: departmentId,
        demoId: demoId,
        title: title,
        description: description,
        scheduledAt: scheduledAt,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> startLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final result = await remoteDataSource.startLiveStream(
        id,
        departmentId: departmentId,
        demoId: demoId,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> endLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final result = await remoteDataSource.endLiveStream(
        id,
        departmentId: departmentId,
        demoId: demoId,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiveStreamTokenEntity>> getLiveStreamToken(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final result = await remoteDataSource.getLiveStreamToken(
        id,
        departmentId: departmentId,
        demoId: demoId,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
