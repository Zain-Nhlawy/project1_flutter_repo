import 'package:project1/features/section/domain/entities/section_entity.dart';

class SectionModel extends SectionEntity {
  const SectionModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.order,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SectionModel.empty() {
    return SectionModel(
      id: '',
      courseId: '',
      title: '',
      order: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}