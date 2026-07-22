import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
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
  final String assetId;
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
    required this.assetId,
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

  late int _currentLessons;
  late int _currentDuration;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    priceController = TextEditingController(
      text: widget.price?.toString() ?? '',
    );
    visibility = widget.visibility;
    selectedTagIds = {...widget.tagIds};
    _currentLessons = widget.lessons;
    _currentDuration = widget.duration;
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
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void toggleEditOrSave() async {
    final localizations = AppLocalizations.of(context)!;
    if (isEditing && !isValid) {
      SnackbarTheme().newSnackBarError(
        context,
        localizations.fillAllFieldsWarning,
      );
      return;
    }
    if (!isEditing) {
      setState(() => isEditing = true);
      return;
    }
    String imagePath = widget.image;
    if (selectedImage != null) {
      final uploadedUrl = await context
          .read<UploadPhotoCourseCubit>()
          .uploadPhoto(selectedImage!);
      if (uploadedUrl == null) {
        if (context.mounted) {
          SnackbarTheme().newSnackBarError(
            context,
            localizations.failedToUploadImage,
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
      totalLessons: _currentLessons,
      totalDuration: _currentDuration,
    );
    context.read<CourseCubit>().updateCourse(widget.courseId, course);
  }

  void _onSectionsChanged() {
    _hasChanges = true;
    context.read<CourseCubit>().getDemoCourse(
      demoId: widget.demoId,
      assetId: widget.assetId,
    );
  }

  void _handleBack() {
    Navigator.pop(context, _hasChanges);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _hasChanges);
      },
      child: BlocListener<CourseCubit, CourseState>(
        listener: (context, state) {
          if (state is CourseUpdated) {
            _hasChanges = true;
            Navigator.pop(context, true);
          }
          if (state is CourseDeleted) {
            Navigator.pop(context, true);
          }
          if (state is CourseUpdateError) {
            SnackbarTheme().newSnackBarError(
              context,
              state.errors.isNotEmpty ? state.errors.first : '',
            );
          }
          if (state is CourseDeleteError) {
            SnackbarTheme().newSnackBarError(
              context,
              state.errors.isNotEmpty ? state.errors.first : '',
            );
          }
          if (state is CoursePublished) {
            _hasChanges = true;
            Navigator.pop(context, true);
          }
          if (state is CoursePublishError) {
            SnackbarTheme().newSnackBarError(
              context,
              state.errors.isNotEmpty ? state.errors.first : '',
            );
          }
          if (state is CourseAssetLoaded) {
            setState(() {
              _currentLessons = state.course.totalLessons;
              _currentDuration = state.course.totalDuration;
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: _handleBack,
            ),
            title: Text(
              localizations.courseManagement,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
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
                  firstValue: '$_currentLessons',
                  secondIcon: Icons.schedule_outlined,
                  secondLabel: localizations.duration,
                  secondValue: formatDuration(_currentDuration),
                ),
                const SizedBox(height: 24),
                CourseManagementActionsRow(
                  courseId: widget.courseId,
                  courseTitle: widget.title,
                  onSectionsChanged: _onSectionsChanged,
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
      ),
    );
  }
}
