import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/repository/live_stream_repository.dart';

class GetLiveStreamDetailsUseCase {
  final LiveStreamRepository repository;

  GetLiveStreamDetailsUseCase(this.repository);

  Future<Either<Failure, LiveStreamEntity>> call(
    String id, {
    required String departmentId,
    String? demoId,
  }) {
    return repository.getLiveStreamDetails(
      id,
      departmentId: departmentId,
      demoId: demoId,
    );
  }
}
