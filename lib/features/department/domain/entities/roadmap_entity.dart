class RoadmapStepEntity {
  final int week;
  final String topic;
  final String goal;
  final List<String> skills;
  final List<String> projects;
  final List<String> deliverables;
  final List<String> resources;

  RoadmapStepEntity({
    required this.week,
    required this.topic,
    required this.goal,
    required this.skills,
    required this.projects,
    required this.deliverables,
    required this.resources,
  });
}

class RoadmapEntity {
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final List<String> prerequisites;
  final List<String> careerOutcomes;
  final List<RoadmapStepEntity> steps;

  RoadmapEntity({
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.prerequisites,
    required this.careerOutcomes,
    required this.steps,
  });
}
