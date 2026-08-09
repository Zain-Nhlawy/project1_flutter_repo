import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/attachment/presentation/widgets/management/lesson_attachments_manager.dart';
import 'package:project1/features/attachment/upload/presentation/cubit/attachment_upload_cubit.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_state.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_action_button.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_app_bar.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_form_section.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_leave_confirmation_dialog.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_upload_progress.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_video_section.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_cubit.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_state.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateLessonScreen extends StatefulWidget {
  final String sectionId;
  final int nextOrder;

  const CreateLessonScreen({
    super.key,
    required this.sectionId,
    this.nextOrder = 1,
  });

  @override
  State<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Duration _videoDuration = Duration.zero;

  File? selectedFile;
  Uint8List? _videoThumbnail;
  bool _loadingThumbnail = false;
  final _attachmentsManagerKey = GlobalKey<LessonAttachmentsManagerState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    final result = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (result == null) return;

    final file = File(result.path);
    final player = Player();

    try {
      await player.open(Media(file.path));
      Duration duration = player.state.duration;
      var attempts = 0;
      while (duration == Duration.zero && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        duration = player.state.duration;
        attempts++;
      }

      if (!mounted) return;

      setState(() {
        selectedFile = file;
        _videoDuration = duration;
      });

      await _generateThumbnail(file);
    } finally {
      await player.dispose();
    }
  }

  Future<void> _generateThumbnail(File file) async {
    setState(() => _loadingThumbnail = true);

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 60,
      );

      if (!mounted) return;
      setState(() {
        _videoThumbnail = bytes;
        _loadingThumbnail = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingThumbnail = false);
    }
  }

  bool get isValid =>
      _titleController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty &&
      selectedFile != null;

  Future<void> saveLesson(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    if (!isValid) {
      SnackbarTheme().newSnackBarError(context, l.fillAllFieldsWarning);
      return;
    }

    context.read<LessonVideoUploadCubit>().uploadVideo(
      sectionId: widget.sectionId,
      file: selectedFile!,
    );
  }

  Future<void> _handleBack(bool isBusy) async {
    if (!isBusy) {
      Navigator.pop(context);
      return;
    }
    final shouldLeave = await showLeaveWhileBusyDialog(context);
    if (shouldLeave && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LessonVideoUploadCubit>()),
        BlocProvider(create: (_) => getIt<LessonCubit>()),
        BlocProvider(create: (_) => getIt<AttachmentUploadCubit>()),
        BlocProvider(create: (_) => getIt<LessonAttachmentCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<LessonVideoUploadCubit, LessonVideoUploadState>(
                listener: _handleUploadState,
              ),
              BlocListener<LessonCubit, LessonState>(
                listener: _handleLessonState,
              ),
            ],
            child: BlocBuilder<LessonVideoUploadCubit, LessonVideoUploadState>(
              builder: (context, uploadState) {
                return BlocBuilder<LessonCubit, LessonState>(
                  builder: (context, lessonState) {
                    final isUploading =
                        uploadState is LessonVideoUploadRequestingUrl ||
                        uploadState is LessonVideoUploadInProgress;
                    final isCreatingLesson = lessonState is LessonLoading;
                    final isBusy = isUploading || isCreatingLesson;

                    return PopScope(
                      canPop: !isBusy,
                      onPopInvokedWithResult: (didPop, result) {
                        if (didPop) return;
                        _handleBack(isBusy);
                      },
                      child: Scaffold(
                        backgroundColor: AppColors.backgroundOf(context),
                        appBar: LessonAppBar(
                          onBackPressed: () => _handleBack(isBusy),
                        ),
                        body: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(18, 24, 18, 54),
                          child: Column(
                            children: [
                              LessonVideoSection(
                                state: uploadState,
                                selectedFile: selectedFile,
                                thumbnail: _videoThumbnail,
                                loadingThumbnail: _loadingThumbnail,
                                onPick: pickVideo,
                              ),
                              if (isUploading)
                                LessonUploadProgress(state: uploadState),
                              const SizedBox(height: 22),
                              LessonFormSection(
                                titleController: _titleController,
                                descriptionController: _descriptionController,
                              ),
                              const SizedBox(height: 22),
                              LessonAttachmentsManager(
                                key: _attachmentsManagerKey,
                                lessonId: null,
                                enabled: !isBusy,
                              ),
                              const SizedBox(height: 30),
                              LessonActionButton(
                                loading: isBusy,
                                onPressed: isBusy
                                    ? null
                                    : () => saveLesson(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleUploadState(BuildContext context, LessonVideoUploadState state) {
    if (state is LessonVideoUploadSuccess) {
      context.read<LessonCubit>().createLesson(
        sectionId: widget.sectionId,
        title: _titleController.text.trim(),
        order: widget.nextOrder,
        videoUrl: state.cdnUrl,
        description: _descriptionController.text.trim(),
        duration: _videoDuration.inSeconds,
      );
    } else if (state is LessonVideoUploadError) {
      final message = state.errors.isNotEmpty
          ? state.errors.first
          : "Upload failed";
      SnackbarTheme().newSnackBarError(context, message);
    }
  }

  Future<void> _handleLessonState(
    BuildContext context,
    LessonState state,
  ) async {
    if (state is LessonSuccess) {
      await _attachmentsManagerKey.currentState?.uploadPendingAttachments(
        context,
        state.lesson.id,
      );

      if (!context.mounted) return;

      Navigator.pop(context, true);
    } else if (state is LessonError) {
      SnackbarTheme().newSnackBarError(
        context,
        state.errors.isNotEmpty ? state.errors.first : "Error",
      );
    }
  }
}
