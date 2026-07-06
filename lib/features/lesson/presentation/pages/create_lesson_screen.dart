import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/attachment/presentation/widgets/lesson_attachments_section.dart';
import 'package:project1/features/lesson/presentation/widgets/custom_button.dart';
import 'package:project1/features/lesson/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/lesson/presentation/widgets/lesson_video_picker.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonAttachment {
  final String id;
  final String name;

  const LessonAttachment({
    required this.id,
    required this.name,
  });

  LessonAttachment copyWith({
    String? id,
    String? name,
  }) {
    return LessonAttachment(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class CreateLessonScreen extends StatefulWidget {
  const CreateLessonScreen({super.key});

  @override
  State<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? selectedVideo;

  List<LessonAttachment> attachments = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void pickVideo() {
    // TODO
  }

  void saveLesson() {
    // TODO
  }

  Future<void> addAttachment() async {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.bold,
                ),
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
        title: Text(
          localizations.createLesson,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
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
            ),

            const SizedBox(height: 24),

            _sectionTitle(localizations.lessonTitle),

            CustomTextField(
              controller: _titleController,
              hintText: localizations.enterLessonTitle,
              icon: Icons.title_rounded,
            ),

            const SizedBox(height: 24),

            _sectionTitle(localizations.lessonDescription),

            CustomTextField(
              controller: _descriptionController,
              hintText: localizations.enterLessonDescription,
              icon: Icons.description_outlined,
              maxLines: 6,
            ),

            const SizedBox(height: 24),

            LessonAttachmentsSection(
              attachments: attachments,
              onAdd: addAttachment,
              onEdit: editAttachment,
              onDelete: deleteAttachment,
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: localizations.createLesson,
              gradient: AppColors.buttonGradient,
              expand: true,
              onPressed: saveLesson,
            ),
          ],
        ),
      ),
    );
  }
}