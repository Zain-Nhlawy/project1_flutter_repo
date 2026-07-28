import 'package:project1/features/department/domain/entities/roadmap_entity.dart';

class RoadmapStepModel extends RoadmapStepEntity {
  RoadmapStepModel({
    required super.week,
    required super.topic,
    required super.goal,
    required super.skills,
    required super.projects,
    required super.deliverables,
    required super.resources,
  });

  factory RoadmapStepModel.fromJson(Map<String, dynamic> json) {
    int weekNum = 0;
    if (json['week'] is int) {
      weekNum = json['week'];
    } else if (json['week'] != null) {
      weekNum = int.tryParse(json['week'].toString()) ?? 0;
    }

    return RoadmapStepModel(
      week: weekNum,
      topic: json['topic']?.toString() ?? json['title']?.toString() ?? '',
      goal: json['goal']?.toString() ?? json['description']?.toString() ?? '',
      skills: json['skills'] is List
          ? (json['skills'] as List).map((e) => e.toString()).toList()
          : [],
      projects: json['projects'] is List
          ? (json['projects'] as List).map((e) => e.toString()).toList()
          : [],
      deliverables: json['deliverables'] is List
          ? (json['deliverables'] as List).map((e) => e.toString()).toList()
          : [],
      resources: json['resources'] is List
          ? (json['resources'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }
}

class RoadmapModel extends RoadmapEntity {
  RoadmapModel({
    required super.title,
    required super.description,
    required super.duration,
    required super.difficulty,
    required super.prerequisites,
    required super.careerOutcomes,
    required super.steps,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    final stepsRaw = json['steps'] ?? (json['data'] is List ? json['data'] : null);
    List<RoadmapStepModel> parsedSteps = [];

    if (stepsRaw is List) {
      parsedSteps = stepsRaw
          .whereType<Map<String, dynamic>>()
          .map((step) => RoadmapStepModel.fromJson(step))
          .toList();
    }

    return RoadmapModel(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? '',
      prerequisites: json['prerequisites'] is List
          ? (json['prerequisites'] as List).map((e) => e.toString()).toList()
          : [],
      careerOutcomes: json['careerOutcomes'] is List
          ? (json['careerOutcomes'] as List).map((e) => e.toString()).toList()
          : [],
      steps: parsedSteps,
    );
  }
}
