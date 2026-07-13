import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/widgets/management/course_delete_button.dart';
import 'package:project1/features/course/presentation/widgets/management/course_edit_save_button.dart';
import 'package:project1/features/course/presentation/widgets/management/course_image_picker.dart';
import 'package:project1/features/course/presentation/widgets/management/course_management_actions_row.dart';
import 'package:project1/features/course/presentation/widgets/management/course_publish_button.dart';
import 'package:project1/features/course/presentation/widgets/management/course_stats_card.dart';
import 'package:project1/features/course/presentation/widgets/course_tags_section.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/course/presentation/widgets/management/visibility_dropdown.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseManagementScreen extends StatefulWidget {
  final String courseId;
  final String demoId;
  final String title;
  final String company;
  final String image;
  final String description;
  final double? price;
  final String visibility;
  final List<String> tagIds;
  final int lessons;
  final int duration;

  const CourseManagementScreen({
    super.key,
    required this.courseId,
    required this.demoId,
    required this.title,
    required this.company,
    required this.image,
    required this.description,
    required this.price,
    required this.visibility,
    required this.tagIds,
    required this.lessons,
    required this.duration,
  });

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late String visibility;
  File? selectedImage;
  bool removeExistingImage = false;
  bool isEditing = false;
  late Set<String> selectedTagIds;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    priceController = TextEditingController(text: widget.price?.toString() ?? '');
    visibility = widget.visibility;
    selectedTagIds = {...widget.tagIds};
  }

  void toggleTag(String id) {
    setState(() {
      if (selectedTagIds.contains(id)) {
        selectedTagIds.remove(id);
      } else {
        selectedTagIds.add(id);
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        removeExistingImage = false;
      });
    }
  }

  bool get isValid {
    return titleController.text.isNotEmpty && descriptionController.text.isNotEmpty;
  }

  void toggleEditOrSave() async {
    final localizations = AppLocalizations.of(context)!;
    if (isEditing && !isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.fillAllFieldsWarning),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }
    if (!isEditing) {
      setState(() => isEditing = true);
      return;
    }
    String imagePath = widget.image;
    if (selectedImage != null) {
      final uploadedUrl = await context.read<UploadPhotoCourseCubit>().uploadPhoto(selectedImage!);
      if (uploadedUrl == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.failedToUploadImage),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      imagePath = uploadedUrl;
    }
    final course = CourseEntity(
      id: widget.courseId,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      visibility: visibility,
      price: double.tryParse(priceController.text),
      imagePath: imagePath,
      demoId: widget.demoId,
      tagIds: selectedTagIds.toList(),
      demo: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      sectionsCount: widget.lessons,
      totalLessons: widget.lessons,
      totalDuration: widget.duration,
    );
    context.read<CourseCubit>().updateCourse(widget.courseId, course);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocListener<CourseCubit, CourseState>(
      listener: (context, state) {
        if (state is CourseUpdated || state is CourseDeleted) {
          Navigator.pop(context, true);
        }
        if (state is CourseUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errors.isNotEmpty ? state.errors.first : ''),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is CourseDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errors.isNotEmpty ? state.errors.first : ''),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is CoursePublished) {
          Navigator.pop(context, true);
        }
        if (state is CoursePublishError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errors.isNotEmpty ? state.errors.first : ''),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            localizations.courseManagement,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CourseImagePicker(
                selectedImage: selectedImage,
                initialImageUrl: removeExistingImage ? null : widget.image,
                onTap: pickImage,
                onRemove: () {
                  setState(() {
                    selectedImage = null;
                    removeExistingImage = true;
                  });
                },
                uploadLabel: localizations.uploadImage,
                enabled: isEditing,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: titleController,
                hintText: localizations.courseTitle,
                icon: Icons.title_outlined,
                enabled: isEditing,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: TextEditingController(text: widget.company),
                hintText: localizations.company,
                icon: Icons.apartment_outlined,
                enabled: false,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: descriptionController,
                hintText: localizations.courseDescription,
                icon: Icons.description_outlined,
                maxLines: 4,
                enabled: isEditing,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: priceController,
                hintText: localizations.price,
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                enabled: isEditing,
              ),
              const SizedBox(height: 16),
              VisibilityDropdown(
                value: visibility,
                onChanged: (v) => setState(() => visibility = v),
                publicLabel: localizations.public,
                privateLabel: localizations.private,
                enabled: isEditing,
              ),
              const SizedBox(height: 18),
              CourseTagsSection(
                selectedTagIds: selectedTagIds,
                onToggle: toggleTag,
                enabled: isEditing,
              ),
              const SizedBox(height: 16),
              CourseStatsCard(
                firstIcon: Icons.menu_book_outlined,
                firstLabel: localizations.lessons,
                firstValue: '${widget.lessons}',
                secondIcon: Icons.schedule_outlined,
                secondLabel: localizations.duration,
                secondValue: '${widget.duration}',
              ),
              const SizedBox(height: 24),
              CourseManagementActionsRow(
                courseId: widget.courseId,
                courseTitle: widget.title,
              ),
              const SizedBox(height: 24),
              CourseEditSaveButton(
                isEditing: isEditing,
                onPressed: toggleEditOrSave,
              ),
              const SizedBox(height: 14),
              CourseDeleteButton(courseId: widget.courseId),
              const SizedBox(height: 14),
              CoursePublishButton(courseId: widget.courseId),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}