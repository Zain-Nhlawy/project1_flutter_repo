import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';

abstract class SectionRepository {
  Future<Either<Failure, SectionEntity>> createSection({
    required String courseId,
    required String title,
    required int order,
  });

  Future<Either<Failure, SectionEntity>> getSection({
    required String courseId,
    required String sectionId,
  });

  Future<Either<Failure, SectionEntity>> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  });

  Future<Either<Failure, void>> deleteSection({
    required String courseId,
    required String sectionId,
  });

  Future<Either<Failure, List<SectionEntity>>> getSections({
    required String courseId,
  });
}