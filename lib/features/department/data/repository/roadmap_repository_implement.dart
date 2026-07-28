import 'package:dartz/dartz.dart';
import 'package:project1/features/department/data/data_sources/roadmap_datasource.dart';
import 'package:project1/features/department/domain/entities/roadmap_entity.dart';
import 'package:project1/features/department/domain/repository/roadmap_repository.dart';

class RoadmapRepositoryImpl implements RoadmapRepository {
  final RoadmapRemoteDataSource remoteDataSource;

  RoadmapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<RoadmapStepEntity>>> createRoadmap(
    String departmentId,
    String demoId,
    String title,
  ) async {
    try {
      final result = await remoteDataSource.createRoadmap(
        departmentId,
        demoId,
        title,
      );
      return Right(result.steps);
    } catch (e) {
      final message = e.toString().replaceAll(RegExp(r'^Exception:\s*'), '');
      return Left(message);
    }
  }
}
