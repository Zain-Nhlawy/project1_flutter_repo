import 'package:project1/features/department/domain/entities/roadmap_entity.dart';

abstract class RoadmapState {}

class RoadmapInitial extends RoadmapState {}

class RoadmapLoading extends RoadmapState {}

class RoadmapLoaded extends RoadmapState {
  final List<RoadmapStepEntity> roadmapSteps;

  RoadmapLoaded(this.roadmapSteps);
}

class RoadmapError extends RoadmapState {
  final String error;

  RoadmapError(this.error);
}
