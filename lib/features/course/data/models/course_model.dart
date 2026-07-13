import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.visibility,
    super.price,
    required super.imagePath,
    super.demoId,
    super.tagIds = const [],
    super.tags = const [],
    super.demo,
    DateTime? createdAt,
    DateTime? updatedAt,
    super.sectionsCount = 0,
    super.totalLessons = 0,
    super.totalDuration = 0,
    super.isPublished = false,

  }) : super(
          createdAt: createdAt ?? DateTime.now(),
          updatedAt: updatedAt ?? DateTime.now(),
        );


  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      visibility: json['visibility'] ?? '',
      price: (json['price'] as num?)?.toDouble(),
      imagePath: json['imagePath'] ?? '',
      demoId: json['demoId'] ?? json['demo']?['id'],
      tagIds: (json['tags'] as List<dynamic>?)
              ?.map((e) => e['id'].toString())
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e['name'].toString())
              .toList() ??
          [],
      demo: json['demo'] != null
          ? DemoModel.fromJson(json['demo'])
          : null,
      isPublished: json['isPublished'] ?? false,
      createdAt: DateTime.tryParse(
            json['createdAt'] ?? '',
          ) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
            json['updatedAt'] ?? '',
          ) ??
          DateTime.now(),
      sectionsCount:
          json['sectionsCount'] ?? 0,
      totalLessons:
          json['lessonCount'] ?? 0,
      totalDuration:
          json['totalDuration'] ?? 0,

    );
  }



  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "visibility": visibility,
      "description": description,
      "imagePath": imagePath,
      "demoId": demoId,
      "price": price,
      "tagIds": tagIds,
      "isPublished": isPublished,
    };
  }
}