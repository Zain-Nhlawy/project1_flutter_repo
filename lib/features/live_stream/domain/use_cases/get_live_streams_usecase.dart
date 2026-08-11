import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/repository/live_stream_repository.dart';

class GetLiveStreamsUseCase {
  final LiveStreamRepository repository;

  GetLiveStreamsUseCase(this.repository);

  Future<Either<Failure, List<LiveStreamEntity>>> call({
    required String departmentId,
    String? demoId,
    String? cursor,
    int? limit,
  }) {
    return repository.getLiveStreams(
      departmentId: departmentId,
      demoId: demoId,
      cursor: cursor,
      limit: limit,
    );
  }
}
