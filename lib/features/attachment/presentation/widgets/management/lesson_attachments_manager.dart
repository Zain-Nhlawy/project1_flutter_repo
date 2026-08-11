import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_state.dart';
import 'package:project1/features/attachment/upload/presentation/cubit/attachment_upload_cubit.dart';
import 'package:project1/features/attachment/upload/presentation/cubit/attachment_upload_state.dart';
import 'package:project1/features/attachment/presentation/widgets/management/lesson_attachments_section.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonAttachmentsManager extends StatefulWidget {
  final String? lessonId;
  final bool enabled;

  const LessonAttachmentsManager({
    super.key,
    required this.lessonId,
    required this.enabled,
  });

  @override
  State<LessonAttachmentsManager> createState() =>
      LessonAttachmentsManagerState();
}

class LessonAttachmentsManagerState extends State<LessonAttachmentsManager> {
  List<LessonAttachmentEntity> _attachments = [];
  final Map<String, File> _pendingFiles = {};

  bool _loading = false;
  bool _fetchedOnce = false;

  bool get _isPending => widget.lessonId == null;

  int get attachmentsCount => _attachments.length;
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchedOnce && !_isPending) {
      _fetchedOnce = true;
      _loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAttachments());
    }
  }

  Future<void> _loadAttachments() async {
    if (_isPending) return;

    setState(() => _loading = true);

    final result = await context.read<LessonAttachmentCubit>().getAttachments(
      lessonId: widget.lessonId!,
    );

    if (!mounted) return;
    setState(() {
      _attachments = result;
      _loading = false;
    });
  }

  Future<File?> _pickAttachmentFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null || result.files.single.path == null) return null;
    return File(result.files.single.path!);
  }

  Future<void> _addAttachment() async {
    final file = await _pickAttachmentFile();
    if (file == null || !mounted) return;

    if (_isPending) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        _attachments.add(
          LessonAttachmentEntity(
            id: id,
            name: file.path.split('/').last,
            path: file.path,
            lessonId: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        _pendingFiles[id] = file;
      });
      return;
    }

    context.read<AttachmentUploadCubit>().uploadAttachment(
      lessonId: widget.lessonId!,
      file: file,
    );
  }

  Future<void> _editAttachment(LessonAttachmentEntity attachment) async {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: attachment.name);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final primary = AppColors.primaryOf(dialogContext);

        return AlertDialog(
          backgroundColor: AppColors.surfaceOf(dialogContext),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
          actionsPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.edit_outlined, color: primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.editAttachment,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimaryOf(dialogContext),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: AppColors.textPrimaryOf(dialogContext)),
            decoration: InputDecoration(
              hintText: localizations.attachmentName,
              hintStyle: TextStyle(
                color: AppColors.textSecondaryOf(dialogContext),
              ),
              prefixIcon: Icon(Icons.title_rounded, color: primary),
              filled: true,
              fillColor: AppColors.backgroundOf(dialogContext),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.borderOf(dialogContext),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.borderOf(dialogContext),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: primary, width: 1.7),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                  color: AppColors.textSecondaryOf(dialogContext),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                localizations.save,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );

    if (result == null || !mounted) return;

    if (_isPending) {
      setState(() {
        final index = _attachments.indexWhere((e) => e.id == attachment.id);
        if (index != -1) {
          _attachments[index] = attachment.copyWith(
            name: result,
            updatedAt: DateTime.now(),
          );
        }
      });
      return;
    }

    context.read<LessonAttachmentCubit>().updateAttachment(
      lessonId: widget.lessonId!,
      attachmentId: attachment.id,
      name: result,
    );
  }

  Future<void> _deleteAttachment(LessonAttachmentEntity attachment) async {
    final localizations = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceOf(dialogContext),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
          actionsPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.deleteAttachment,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimaryOf(dialogContext),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            localizations.deleteAttachmentConfirmation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(dialogContext),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                  color: AppColors.textSecondaryOf(dialogContext),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                localizations.delete,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    if (_isPending) {
      setState(() {
        _attachments.removeWhere((e) => e.id == attachment.id);
        _pendingFiles.remove(attachment.id);
      });
      return;
    }

    context.read<LessonAttachmentCubit>().deleteAttachment(
      lessonId: widget.lessonId!,
      attachment: attachment,
    );
  }

  Future<void> uploadPendingAttachments(
    BuildContext context,
    String lessonId,
  ) async {
    if (!_isPending || _pendingFiles.isEmpty) return;

    final cubit = context.read<AttachmentUploadCubit>();

    for (final attachment in List<LessonAttachmentEntity>.from(_attachments)) {
      final file = _pendingFiles[attachment.id];
      if (file == null) continue;

      final completer = Completer<void>();
      late final StreamSubscription subscription;

      subscription = cubit.stream.listen((state) {
        if (state is AttachmentUploadSuccess ||
            state is AttachmentUploadError) {
          subscription.cancel();
          if (!completer.isCompleted) completer.complete();
        }
      });

      cubit.uploadAttachment(lessonId: lessonId, file: file);

      await completer.future;
    }
  }

  void _handleAttachmentUploadState(
    BuildContext context,
    AttachmentUploadState state,
  ) {
    final localizations = AppLocalizations.of(context)!;
    if (state is AttachmentUploadSuccess) {
      setState(() {
        _attachments.add(state.attachment);
      });
      context.read<AttachmentUploadCubit>().reset();
    } else if (state is AttachmentUploadError) {
  final message = state.errors.isNotEmpty
      ? state.errors.first
      : localizations.uploadFailed;
  SnackbarTheme().newSnackBarError(context, message);
  context.read<AttachmentUploadCubit>().reset();
}
  }

  void _handleLessonAttachmentState(
    BuildContext context,
    LessonAttachmentState state,
  ) {
    final localizations = AppLocalizations.of(context)!;
    if (state is LessonAttachmentUpdated) {
      setState(() {
        final index = _attachments.indexWhere(
          (e) => e.id == state.attachment.id,
        );
        if (index != -1) {
          _attachments[index] = state.attachment;
        }
      });
    } else if (state is LessonAttachmentDeleted) {
      setState(() {
        _attachments.removeWhere((e) => e.id == state.attachmentId);
      });
    } else if (state is LessonAttachmentError) {
  final message = state.errors.isNotEmpty
      ? state.errors.first
      : localizations.unexpectedError;

  SnackbarTheme().newSnackBarError(context, message);
}
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AttachmentUploadCubit, AttachmentUploadState>(
          listener: _isPending ? (_, __) {} : _handleAttachmentUploadState,
        ),
        BlocListener<LessonAttachmentCubit, LessonAttachmentState>(
          listener: _handleLessonAttachmentState,
        ),
      ],
      child: BlocBuilder<AttachmentUploadCubit, AttachmentUploadState>(
        builder: (context, uploadState) {
          final isUploading =
              !_isPending &&
              (uploadState is AttachmentUploadRequestingUrl ||
                  uploadState is AttachmentUploadInProgress);

          if (_loading) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 34),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.borderOf(context)),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.primaryOf(context),
                ),
              ),
            );
          }

          return LessonAttachmentsSection(
            attachments: _attachments,
            onAdd: _addAttachment,
            onEdit: _editAttachment,
            onDelete: _deleteAttachment,
            enabled: widget.enabled,
            isUploading: isUploading,
          );
        },
      ),
    );
  }
}
