import 'package:project1/features/demo/domain/entities/demo_entity.dart';

class CourseEntity {
  final String id;
  final String title;
  final String description;
  final String visibility;
  final double? price;
  final String imagePath;

  final DateTime createdAt;
  final DateTime updatedAt;

  final DemoEntity demo;

  final int totalLessons;
  final String duration;

  CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.visibility,
    required this.price,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.demo,
    required this.totalLessons,
    required this.duration,
  });
}