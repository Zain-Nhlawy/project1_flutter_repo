import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/attachment/presentation/widgets/lesson_attachments_section.dart';
import 'package:project1/features/lesson/presentation/pages/create_lesson_screen.dart';
import 'package:project1/features/lesson/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/lesson/presentation/widgets/lesson_video_picker.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonManagementScreen extends StatefulWidget {
  final String lessonTitle;
  final String lessonDescription;
  final String? videoUrl;
  final List<LessonAttachment> initialAttachments;

  const LessonManagementScreen({
    super.key,
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

  String? selectedVideo;
  late List<LessonAttachment> attachments;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.lessonTitle);
    descriptionController = TextEditingController(text: widget.lessonDescription);
    selectedVideo = widget.videoUrl;
    attachments = List<LessonAttachment>.from(widget.initialAttachments);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void pickVideo() {
    // TODO
  }

  bool get isValid {
    return titleController.text.isNotEmpty && descriptionController.text.isNotEmpty;
  }

  void toggleEditOrSave() {
    if (isEditing) {
      if (!isValid) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.fillAllFieldsWarning),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(12),
          ),
        );
        return;
      }
      // TODO
      setState(() => isEditing = false);
    } else {
      setState(() => isEditing = true);
    }
  }

  Future<void> addAttachment() async {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(localizations.addAttachment),
          content: CustomTextField(
            controller: controller,
            hintText: localizations.attachmentName,
            icon: Icons.attach_file,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                localizations.cancel,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              child: Text(
                localizations.add,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        attachments.add(
          LessonAttachment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: result,
          ),
        );
      });
    }
  }

  Future<void> editAttachment(LessonAttachment attachment) async {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: attachment.name);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(localizations.editAttachment),
          content: CustomTextField(
            controller: controller,
            hintText: localizations.attachmentName,
            icon: Icons.edit_outlined,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                localizations.cancel,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  Navigator.pop(dialogContext, value);
                }
              },
              child: Text(
                localizations.save,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        final index = attachments.indexWhere((e) => e.id == attachment.id);
        attachments[index] = attachment.copyWith(name: result);
      });
    }
  }

  Future<void> deleteAttachment(LessonAttachment attachment) async {
    final localizations = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(localizations.deleteAttachment),
          content: Text(localizations.deleteAttachmentConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                localizations.delete,
                style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        attachments.removeWhere((e) => e.id == attachment.id);
      });
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.lessonManagement,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 55),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(localizations.lessonVideo),

            LessonVideoPicker(
              selectedVideo: selectedVideo,
              onTap: pickVideo,
              enabled: isEditing,
            ),

            const SizedBox(height: 24),

            _sectionTitle(localizations.lessonTitle),

            CustomTextField(
              controller: titleController,
              hintText: localizations.enterLessonTitle,
              icon: Icons.title_rounded,
              enabled: isEditing,
            ),

            const SizedBox(height: 24),

            _sectionTitle(localizations.lessonDescription),

            CustomTextField(
              controller: descriptionController,
              hintText: localizations.enterLessonDescription,
              icon: Icons.description_outlined,
              maxLines: 6,
              enabled: isEditing,
            ),

            const SizedBox(height: 24),

            LessonAttachmentsSection(
              attachments: attachments,
              onAdd: addAttachment,
              onEdit: editAttachment,
              onDelete: deleteAttachment,
              enabled: isEditing,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: toggleEditOrSave,
                icon: Icon(
                  isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                  color: isEditing ? Colors.white : AppColors.primary,
                ),
                label: Text(
                  isEditing ? localizations.saveChanges : localizations.editLesson,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isEditing ? Colors.white : AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.green.shade600 : Colors.transparent,
                  side: BorderSide(
                    color: isEditing ? Colors.green.shade600 : AppColors.primary,
                    width: 1.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}