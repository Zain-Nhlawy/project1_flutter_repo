import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.order,
    required super.videoUrl,
    required super.subTitleUrl,
    required super.sectionId,
    required super.duration,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      subTitleUrl: json['subTitleUrl'],
      sectionId: json['sectionId'] ?? '',
      duration: json['duration'] ?? 0,
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'order': order,
      'videoUrl': videoUrl,
      'subTitleUrl': subTitleUrl,
      'sectionId': sectionId,
      'duration': duration,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
