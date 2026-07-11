import 'package:project1/features/section/data/data_sources/section_remote_datasource.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';

class SectionRepositoryImpl implements SectionRepository {
  final SectionRemoteDataSource remoteDataSource;

  SectionRepositoryImpl(this.remoteDataSource);

  @override
  Future<SectionEntity> createSection({
    required String courseId,
    required String title,
    required int order,
  }) {
    return remoteDataSource.createSection(
      courseId: courseId,
      title: title,
      order: order,
    );
  }

  @override
  Future<SectionEntity> getSection({
    required String courseId,
    required String sectionId,
  }) {
    return remoteDataSource.getSection(
      courseId: courseId,
      sectionId: sectionId,
    );
  }

  @override
  Future<SectionEntity> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  }) {
    return remoteDataSource.updateSection(
      courseId: courseId,
      sectionId: sectionId,
      title: title,
      order: order,
    );
  }

  @override
  Future<void> deleteSection({
    required String courseId,
    required String sectionId,
  }) {
    return remoteDataSource.deleteSection(
      courseId: courseId,
      sectionId: sectionId,
    );
  }

  @override
Future<List<SectionEntity>> getSections({
  required String courseId,
}) {
  return remoteDataSource.getSections(
    courseId: courseId,
  );
}
}