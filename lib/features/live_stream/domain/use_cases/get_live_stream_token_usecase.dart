import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_token_entity.dart';
import 'package:project1/features/live_stream/domain/repository/live_stream_repository.dart';

class GetLiveStreamTokenUseCase {
  final LiveStreamRepository repository;

  GetLiveStreamTokenUseCase(this.repository);

  Future<Either<Failure, LiveStreamTokenEntity>> call(
    String id, {
    required String departmentId,
    String? demoId,
  }) {
    return repository.getLiveStreamToken(
      id,
      departmentId: departmentId,
      demoId: demoId,
    );
  }
}
