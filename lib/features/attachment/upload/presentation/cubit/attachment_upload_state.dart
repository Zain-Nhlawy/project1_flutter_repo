import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';

abstract class AttachmentUploadState {
  const AttachmentUploadState();
}

class AttachmentUploadInitial extends AttachmentUploadState {
  const AttachmentUploadInitial();
}

class AttachmentUploadRequestingUrl extends AttachmentUploadState {
  const AttachmentUploadRequestingUrl();
}

class AttachmentUploadInProgress extends AttachmentUploadState {
  final double progress;
  const AttachmentUploadInProgress(this.progress);
}

class AttachmentUploadSuccess extends AttachmentUploadState {
  final LessonAttachmentEntity attachment;
  const AttachmentUploadSuccess(this.attachment);
}

class AttachmentUploadError extends AttachmentUploadState {
  final List<String> errors;
  const AttachmentUploadError(this.errors);
}
