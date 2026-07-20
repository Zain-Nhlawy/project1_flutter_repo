import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';

abstract class LessonAttachmentState {
  const LessonAttachmentState();
}

class LessonAttachmentInitial extends LessonAttachmentState {
  const LessonAttachmentInitial();
}

class LessonAttachmentLoading extends LessonAttachmentState {
  const LessonAttachmentLoading();
}

class LessonAttachmentLoaded extends LessonAttachmentState {
  final List<LessonAttachmentEntity> attachments;
  const LessonAttachmentLoaded(this.attachments);
}

class LessonAttachmentUpdated extends LessonAttachmentState {
  final LessonAttachmentEntity attachment;
  const LessonAttachmentUpdated(this.attachment);
}

class LessonAttachmentDeleted extends LessonAttachmentState {
  final String attachmentId;
  const LessonAttachmentDeleted(this.attachmentId);
}

class LessonAttachmentError extends LessonAttachmentState {
  final List<String> errors;
  const LessonAttachmentError(this.errors);
}
