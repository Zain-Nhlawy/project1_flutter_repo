import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../repository/lesson_video_upload_repository.dart';

class GenerateVideoUploadUrlUseCase {
  final LessonVideoUploadRepository repository;

  GenerateVideoUploadUrlUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String sectionId,
    required String fileName,
  }) {
    return repository.generateUploadUrl(
      sectionId: sectionId,
      fileName: fileName,
    );
  }
}
