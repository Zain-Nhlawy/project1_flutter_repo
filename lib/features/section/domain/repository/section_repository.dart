import 'package:project1/features/section/domain/entities/section_entity.dart';

abstract class SectionRepository {
  Future<SectionEntity> createSection({
    required String courseId,
    required String title,
    required int order,
  });

  Future<SectionEntity> getSection({
    required String courseId,
    required String sectionId,
  });

  Future<SectionEntity> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  });

  Future<void> deleteSection({
    required String courseId,
    required String sectionId,
  });

  Future<List<SectionEntity>> getSections({
  required String courseId,
});
}