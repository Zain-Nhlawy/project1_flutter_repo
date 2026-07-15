import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/domain/use_case/get_attachments_usecase.dart';
import 'package:project1/features/attachment/domain/use_case/update_attachment_usecase.dart';
import 'package:project1/features/attachment/domain/use_case/delete_attachment_usecase.dart';
import 'lesson_attachment_state.dart';

class LessonAttachmentCubit extends Cubit<LessonAttachmentState> {
  final GetAttachmentsUseCase getAttachmentsUseCase;
  final UpdateAttachmentUseCase updateAttachmentUseCase;
  final DeleteAttachmentUseCase deleteAttachmentUseCase;

  LessonAttachmentCubit({
    required this.getAttachmentsUseCase,
    required this.updateAttachmentUseCase,
    required this.deleteAttachmentUseCase,
  }) : super(const LessonAttachmentInitial());

  List<String> _errorsOf(Failure failure) => failure.errors ?? [failure.message];

  Future<List<LessonAttachmentEntity>> getAttachments({
    required String lessonId,
    String? cursor,
  }) async {
    final result = await getAttachmentsUseCase(lessonId: lessonId, cursor: cursor);
    return result.fold(
      (failure) {
        emit(LessonAttachmentError(_errorsOf(failure)));
        return <LessonAttachmentEntity>[];
      },
      (attachments) => attachments,
    );
  }

  Future<void> updateAttachment({
    required String lessonId,
    required String attachmentId,
    required String name,
  }) async {
    emit(const LessonAttachmentLoading());
    final result = await updateAttachmentUseCase(
      lessonId: lessonId,
      attachmentId: attachmentId,
      name: name,
    );
    result.fold(
      (failure) => emit(LessonAttachmentError(_errorsOf(failure))),
      (attachment) => emit(LessonAttachmentUpdated(attachment)),
    );
  }

Future<void> deleteAttachment({
  required String lessonId,
  required LessonAttachmentEntity attachment,
}) async {
  emit(const LessonAttachmentLoading());

  final result = await deleteAttachmentUseCase(
    lessonId: lessonId,
    attachmentId: attachment.id,
    name: attachment.name, 
  );
  result.fold(
    (failure) => emit(LessonAttachmentError(_errorsOf(failure))),
    (_) => emit(LessonAttachmentDeleted(attachment.id)),
  );
}
}