import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_management_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/attachment/upload/presentation/cubit/attachment_upload_cubit.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_leave_confirmation_dialog.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_cubit.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonManagementScreen extends StatefulWidget {
  final String sectionId;
  final String lessonId;
  final String lessonTitle;
  final String lessonDescription;
  final String? videoUrl;
  final List<LessonAttachmentEntity> initialAttachments;

  const LessonManagementScreen({
    super.key,
    required this.sectionId,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonDescription,
    this.videoUrl,
    this.initialAttachments = const [],
  });

  @override
  State<LessonManagementScreen> createState() => _LessonManagementScreenState();
}

class _LessonManagementScreenState extends State<LessonManagementScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String? selectedVideoUrl;
  File? newVideoFile;
  Duration _videoDuration = Duration.zero;

  Uint8List? _videoThumbnail;
  String? _thumbnailUrl;
  bool _loadingThumbnail = false;

  bool isEditing = false;
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.lessonTitle);
    descriptionController = TextEditingController(
      text: widget.lessonDescription,
    );
    selectedVideoUrl = widget.videoUrl;
    _generateThumbnail();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateThumbnail() async {
    if (newVideoFile == null &&
        (selectedVideoUrl == null || selectedVideoUrl!.isEmpty)) {
      return;
    }
    if (newVideoFile != null) {
      setState(() => _loadingThumbnail = true);
      try {
        final Uint8List? bytes = await VideoThumbnail.thumbnailData(
          video: newVideoFile!.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 400,
          quality: 60,
        );
        if (!mounted) return;
        setState(() {
          _videoThumbnail = bytes;
          _thumbnailUrl = null;
          _loadingThumbnail = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _loadingThumbnail = false);
      }
      return;
    }
    setState(() {
      _thumbnailUrl = _buildThumbnailUrl(selectedVideoUrl!);
      _videoThumbnail = null;
      _loadingThumbnail = false;
    });
  }

  String? _buildThumbnailUrl(String videoUrl) {
    try {
      final uri = Uri.parse(videoUrl);
      final path = uri.path;
      if (!path.contains('/uploads/lessons/')) return null;
      final newPath = path
          .replaceFirst('/uploads/lessons/', '/uploads/thumbnails/lessons/')
          .replaceAll(RegExp(r'\.mp4$', caseSensitive: false), '.jpg')
          .replaceAll(RegExp(r'\.mov$', caseSensitive: false), '.jpg')
          .replaceAll(RegExp(r'\.avi$', caseSensitive: false), '.jpg')
          .replaceAll(RegExp(r'\.mkv$', caseSensitive: false), '.jpg')
          .replaceAll(RegExp(r'\.webm$', caseSensitive: false), '.jpg');
      return uri.replace(path: newPath).toString();
    } catch (e) {
      debugPrint('Failed to build thumbnail URL: $e');
      return null;
    }
  }

  Future<void> pickVideo(BuildContext context) async {
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
        newVideoFile = file;
        _videoDuration = duration;
      });
      await _generateThumbnail();
    } finally {
      await player.dispose();
    }
  }

  bool get isValid {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  Future<void> _saveLessonChanges(BuildContext context) async {
    setState(() => _isSaving = true);

    String? finalVideoUrl = selectedVideoUrl;
    int? finalDuration = _videoDuration.inSeconds > 0
        ? _videoDuration.inSeconds
        : null;

    if (newVideoFile != null) {
      final uploadedUrl = await _uploadVideoAndWait(context, newVideoFile!);

      if (uploadedUrl == null) {
        if (mounted) setState(() => _isSaving = false);
        return;
      }
      finalVideoUrl = uploadedUrl;
    }

    final lesson = await context.read<LessonCubit>().updateLessonAndReturn(
      sectionId: widget.sectionId,
      lessonId: widget.lessonId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      videoUrl: finalVideoUrl,
      duration: finalDuration,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (lesson != null) {
      setState(() {
        selectedVideoUrl = finalVideoUrl;
        newVideoFile = null;
        _thumbnailUrl = finalVideoUrl != null
            ? _buildThumbnailUrl(finalVideoUrl)
            : null;
      });
      Navigator.of(context).pop(true);
    } else {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.lessonUpdateFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _uploadVideoAndWait(BuildContext context, File file) async {
    final cubit = context.read<LessonVideoUploadCubit>();
    final completer = Completer<String?>();

    late final StreamSubscription subscription;
    subscription = cubit.stream.listen((state) {
      if (state is LessonVideoUploadSuccess) {
        subscription.cancel();
        completer.complete(state.cdnUrl);
      } else if (state is LessonVideoUploadError) {
        subscription.cancel();
        final message = state.errors.isNotEmpty
            ? state.errors.first
            : 'Upload failed';
        if (context.mounted) {
          SnackbarTheme().newSnackBarError(
            context,
            message,
          );
        }
        completer.complete(null);
      }
    });

    cubit.uploadVideo(sectionId: widget.sectionId, file: file);

    return completer.future;
  }

  void toggleEditOrSave(BuildContext context) {
    if (isEditing) {
      if (!isValid) {
        final localizations = AppLocalizations.of(context)!;
        SnackbarTheme().newSnackBarError(
          context,
          localizations.fillAllFieldsWarning,
        );
        return;
      }
      _saveLessonChanges(context);
    } else {
      setState(() => isEditing = true);
    }
  }

  Future<void> _handleBack(BuildContext context, bool isBusy) async {
    if (!isBusy) {
      Navigator.pop(context, _hasChanges);
      return;
    }
    final shouldLeave = await showLeaveWhileBusyDialog(context);
    if (shouldLeave && context.mounted) {
      Navigator.pop(context, _hasChanges);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LessonCubit>()),
        BlocProvider(create: (_) => getIt<LessonVideoUploadCubit>()),
        BlocProvider(create: (_) => getIt<AttachmentUploadCubit>()),
        BlocProvider(create: (_) => getIt<LessonAttachmentCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return LessonManagementView(
            titleController: titleController,
            descriptionController: descriptionController,
            lessonId: widget.lessonId,
            videoThumbnail: _videoThumbnail,
            thumbnailUrl: _thumbnailUrl,
            loadingThumbnail: _loadingThumbnail,
            isEditing: isEditing,
            isSaving: _isSaving,
            onPickVideo: () => pickVideo(context),
            onToggleEditOrSave: () => toggleEditOrSave(context),
            onBack: (isBusy) => _handleBack(context, isBusy),
          );
        },
      ),
    );
  }
}
