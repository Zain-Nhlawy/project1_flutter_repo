import 'package:dartz/dartz.dart';
import 'package:project1/features/department/domain/entities/roadmap_entity.dart';
import 'package:project1/features/department/domain/repository/roadmap_repository.dart';

class RoadmapUseCase {
  final RoadmapRepository roadmapRepository;

  RoadmapUseCase({
    required this.roadmapRepository,
  });

  Future<Either<String, List<RoadmapStepEntity>>> createRoadmap(
    String departmentId,
    String demoId,
    String title,
  ) async {
    return await roadmapRepository.createRoadmap(
      departmentId,
      demoId,
      title,
    );
  }
}
