import 'package:dartz/dartz.dart';
import 'package:project1/features/department/domain/entities/roadmap_entity.dart';

abstract class RoadmapRepository {
  Future<Either<String, List<RoadmapStepEntity>>> createRoadmap(
    String departmentId,
    String demoId,
    String title,
  );
}
