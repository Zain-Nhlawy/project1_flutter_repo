import 'package:project1/features/demo/domain/entities/demo_entity.dart';

class CourseEntity {
  final String id;
  final String title;
  final String description;
  final String visibility;
  final double? price;
  final String imagePath;

  final String? demoId;
  final String? assetId;

  final List<String> tagIds;
  final List<String> tags;

  final DateTime createdAt;
  final DateTime updatedAt;

  final DemoEntity? demo;

  final int sectionsCount;
  final int totalLessons;
  final int totalDuration;

  final bool isPublished;

  CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.visibility,
    this.price,
    required this.imagePath,
    this.demoId,
    this.assetId,
    this.tagIds = const [],
    this.tags = const [],
    this.demo,
    required this.createdAt,
    required this.updatedAt,
    this.sectionsCount = 0,
    this.totalLessons = 0,
    this.totalDuration = 0,
    this.isPublished = false,
  });
}
