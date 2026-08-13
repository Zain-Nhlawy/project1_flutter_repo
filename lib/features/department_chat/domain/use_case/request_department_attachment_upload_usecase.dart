import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';

import '../entities/department_attachment_upload_entity.dart';
import '../repository/department_chat_repository.dart';

class RequestDepartmentAttachmentUploadUseCase {
  final DepartmentChatRepository repository;

  RequestDepartmentAttachmentUploadUseCase(this.repository);

  Future<Either<Failure, DepartmentAttachmentUploadEntity>> call({
    required String departmentId,
    required String demoId,
    required String fileName,
  }) {
    return repository.requestAttachmentUpload(
      departmentId: departmentId,
      demoId: demoId,
      fileName: fileName,
    );
  }
}
