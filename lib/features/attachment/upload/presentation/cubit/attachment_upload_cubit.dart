import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/use_case/create_attachment_usecase.dart';
import 'package:project1/features/attachment/upload/domain/use_case/generate_attachment_upload_url_usecase.dart';
import 'package:project1/features/attachment/upload/domain/use_case/upload_attachment_file_usecase.dart';
import 'attachment_upload_state.dart';

const _mimeTypes = {
  'pdf': 'application/pdf',
  'zip': 'application/zip',
  'doc': 'application/msword',
  'docx':
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'ppt': 'application/vnd.ms-powerpoint',
  'pptx':
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'xls': 'application/vnd.ms-excel',
  'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
};

class AttachmentUploadCubit extends Cubit<AttachmentUploadState> {
  final GenerateAttachmentUploadUrlUseCase generateUploadUrlUseCase;
  final UploadAttachmentFileUseCase uploadFileUseCase;
  final CreateAttachmentUseCase createAttachmentUseCase;

  AttachmentUploadCubit({
    required this.generateUploadUrlUseCase,
    required this.uploadFileUseCase,
    required this.createAttachmentUseCase,
  }) : super(const AttachmentUploadInitial());

  List<String> _errorsOf(Failure failure) =>
      failure.errors ?? [failure.message];

  Future<void> uploadAttachment({
    required String lessonId,
    required File file,
  }) async {
    try {
      emit(const AttachmentUploadRequestingUrl());

      final fileName = file.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();
      final contentType = _mimeTypes[extension] ?? 'application/octet-stream';

      final urlResult = await generateUploadUrlUseCase(
        lessonId: lessonId,
        fileName: fileName,
      );

      if (urlResult.isLeft()) {
        urlResult.fold(
          (f) => emit(AttachmentUploadError(_errorsOf(f))),
          (r) => null,
        );
        return;
      }

      final uploadData = urlResult.getOrElse(() => throw Exception());

      emit(const AttachmentUploadInProgress(0));
      final uploadResult = await uploadFileUseCase(
        uploadUrl: uploadData.uploadUrl,
        file: file,
        contentType: contentType,
        onProgress: (progress) => emit(AttachmentUploadInProgress(progress)),
      );

      if (uploadResult.isLeft()) {
        uploadResult.fold(
          (f) => emit(AttachmentUploadError(_errorsOf(f))),
          (r) => null,
        );
        return;
      }

      final createResult = await createAttachmentUseCase(
        lessonId: lessonId,
        name: fileName,
        path: uploadData.path,
      );

      createResult.fold(
        (failure) => emit(AttachmentUploadError(_errorsOf(failure))),
        (attachment) => emit(AttachmentUploadSuccess(attachment)),
      );
    } catch (e) {
      emit(AttachmentUploadError([e.toString()]));
    }
  }

  void reset() => emit(const AttachmentUploadInitial());
}
