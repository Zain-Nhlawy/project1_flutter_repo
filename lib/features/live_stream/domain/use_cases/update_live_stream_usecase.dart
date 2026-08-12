import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/repository/live_stream_repository.dart';

class UpdateLiveStreamUseCase {
  final LiveStreamRepository repository;

  UpdateLiveStreamUseCase(this.repository);

  Future<Either<Failure, LiveStreamEntity>> call({
    required String id,
    required String departmentId,
    String? demoId,
    String? title,
    String? description,
    String? scheduledAt,
  }) {
    return repository.updateLiveStream(
      id: id,
      departmentId: departmentId,
      demoId: demoId,
      title: title,
      description: description,
      scheduledAt: scheduledAt,
    );
  }
}
