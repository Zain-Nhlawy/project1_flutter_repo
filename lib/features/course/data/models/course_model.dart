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
    super.assetId,
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
      tagIds:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => e['id'].toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => e['name'].toString())
              .toList() ??
          [],
      demo: json['demo'] != null ? DemoModel.fromJson(json['demo']) : null,
      isPublished: json['isPublished'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      sectionsCount: json['sectionsCount'] ?? 0,
      totalLessons: json['lessonCount'] ?? 0,
      totalDuration: json['totalDuration'] ?? 0,
    );
  }

  factory CourseModel.fromAssetJson(Map<String, dynamic> assetJson) {
    final courseJson = assetJson['course'] as Map<String, dynamic>?;
    if (courseJson == null) {
      throw ArgumentError('Asset json does not contain a course object');
    }

    final course = CourseModel.fromJson(courseJson);

    return CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      visibility: course.visibility,
      price: course.price,
      imagePath: course.imagePath,
      demoId: assetJson['demoId'] ?? course.demoId,
      assetId: assetJson['id'],
      tagIds: course.tagIds,
      tags: course.tags,
      demo: course.demo,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      sectionsCount: course.sectionsCount,
      totalLessons: course.totalLessons,
      totalDuration: course.totalDuration,
      isPublished: course.isPublished,
    );
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? visibility,
    double? price,
    bool clearPrice = false,
    String? imagePath,
    String? demoId,
    String? assetId,
    List<String>? tagIds,
    List<String>? tags,
    DemoModel? demo,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sectionsCount,
    int? totalLessons,
    int? totalDuration,
    bool? isPublished,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      visibility: visibility ?? this.visibility,
      price: clearPrice ? null : (price ?? this.price),
      imagePath: imagePath ?? this.imagePath,
      demoId: demoId ?? this.demoId,
      assetId: assetId ?? this.assetId,
      tagIds: tagIds ?? this.tagIds,
      tags: tags ?? this.tags,
      demo: demo ?? this.demo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sectionsCount: sectionsCount ?? this.sectionsCount,
      totalLessons: totalLessons ?? this.totalLessons,
      totalDuration: totalDuration ?? this.totalDuration,
      isPublished: isPublished ?? this.isPublished,
    );
  }

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
