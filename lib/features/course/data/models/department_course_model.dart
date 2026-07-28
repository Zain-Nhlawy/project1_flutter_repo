import '../../domain/entities/department_course_entity.dart';

class DepartmentCourseModel extends DepartmentCourseEntity {
  const DepartmentCourseModel({
    required super.id,
    required super.departmentId,
    required super.createdAt,
    required super.updatedAt,
    required super.asset,
  });

  factory DepartmentCourseModel.fromJson(Map<String, dynamic> json) {
    return DepartmentCourseModel(
      id: json['id'] as String,
      departmentId: json['departmentId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      asset: DepartmentCourseAssetModel.fromJson(
        Map<String, dynamic>.from(json['asset']),
      ),
    );
  }
}

class DepartmentCourseAssetModel extends DepartmentCourseAssetEntity {
  const DepartmentCourseAssetModel({
    required super.id,
    required super.demoId,
    required super.accessMethod,
    required super.acquiredAt,
    required super.updatedAt,
    required super.course,
  });

  factory DepartmentCourseAssetModel.fromJson(Map<String, dynamic> json) {
    return DepartmentCourseAssetModel(
      id: json['id'] as String,
      demoId: json['demoId'] as String,
      accessMethod: json['accessMethod'] as String,
      acquiredAt: DateTime.parse(json['acquiredAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      course: DepartmentCourseInfoModel.fromJson(
        Map<String, dynamic>.from(json['course']),
      ),
    );
  }
}

class DepartmentCourseInfoModel extends DepartmentCourseInfoEntity {
  const DepartmentCourseInfoModel({
    required super.id,
    required super.title,
    required super.visibility,
    super.price,
    required super.description,
    super.imagePath,
    required super.isPublished,
    required super.sectionsCount,
    required super.lessonCount,
    required super.totalDuration,
  });

  factory DepartmentCourseInfoModel.fromJson(Map<String, dynamic> json) {
    return DepartmentCourseInfoModel(
      id: json['id'] as String,
      title: json['title']?.toString() ?? '',
      visibility: json['visibility']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble(),
      description: json['description']?.toString() ?? '',
      imagePath: json['imagePath']?.toString(),
      isPublished: json['isPublished'] ?? false,
      sectionsCount: json['sectionsCount'] ?? 0,
      lessonCount: json['lessonCount'] ?? 0,
      totalDuration: json['totalDuration'] ?? 0,
    );
  }
}