class DepartmentCourseEntity {
  final String id;
  final String departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DepartmentCourseAssetEntity asset;

  const DepartmentCourseEntity({
    required this.id,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
    required this.asset,
  });
}

class DepartmentCourseAssetEntity {
  final String id;
  final String demoId;
  final String accessMethod;
  final DateTime acquiredAt;
  final DateTime updatedAt;
  final DepartmentCourseInfoEntity course;

  const DepartmentCourseAssetEntity({
    required this.id,
    required this.demoId,
    required this.accessMethod,
    required this.acquiredAt,
    required this.updatedAt,
    required this.course,
  });
}

class DepartmentCourseInfoEntity {
  final String id;
  final String title;
  final String visibility;
  final double? price;
  final String description;
  final String? imagePath;
  final bool isPublished;
  final int sectionsCount;
  final int lessonCount;
  final int totalDuration;

  const DepartmentCourseInfoEntity({
    required this.id,
    required this.title,
    required this.visibility,
    this.price,
    required this.description,
    this.imagePath,
    required this.isPublished,
    required this.sectionsCount,
    required this.lessonCount,
    required this.totalDuration,
  });
}