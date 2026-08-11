import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/repository/live_stream_repository.dart';

class CreateLiveStreamUseCase {
  final LiveStreamRepository repository;

  CreateLiveStreamUseCase(this.repository);

  Future<Either<Failure, LiveStreamEntity>> call({
    required String title,
    required String description,
    required String scheduledAt,
    required String departmentId,
    String? demoId,
  }) {
    return repository.createLiveStream(
      title: title,
      description: description,
      scheduledAt: scheduledAt,
      departmentId: departmentId,
      demoId: demoId,
    );
  }
}
