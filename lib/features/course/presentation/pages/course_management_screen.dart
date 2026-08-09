import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
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
  late TextEditingController companyController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late String visibility;
  File? selectedImage;
  bool removeExistingImage = false;
  late Set<String> selectedTagIds;

  late int _currentLessons;
  late int _currentDuration;

  bool _hasChanges = false;
  bool _hasFormChanges = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    companyController = TextEditingController(text: widget.company);
    descriptionController = TextEditingController(text: widget.description);
    priceController = TextEditingController(
      text: widget.price?.toString() ?? '',
    );
    visibility = widget.visibility;
    selectedTagIds = {...widget.tagIds};
    _currentLessons = widget.lessons;
    _currentDuration = widget.duration;
    titleController.addListener(_updateFormChanges);
    descriptionController.addListener(_updateFormChanges);
    priceController.addListener(_updateFormChanges);
  }

  void toggleTag(String id) {
    setState(() {
      if (selectedTagIds.contains(id)) {
        selectedTagIds.remove(id);
      } else {
        selectedTagIds.add(id);
      }
      _hasFormChanges = _computeHasFormChanges();
    });
  }

  bool get _priceHasChanged {
    final currentText = priceController.text.trim();
    final originalText = widget.price?.toString() ?? '';

    if (currentText == originalText) return false;

    final currentPrice = double.tryParse(currentText);
    if (currentPrice != null &&
        widget.price != null &&
        currentPrice == widget.price) {
      return false;
    }

    return true;
  }

  bool _computeHasFormChanges() {
    final originalTags = widget.tagIds.toSet();
    final tagsChanged =
        originalTags.length != selectedTagIds.length ||
        !originalTags.every(selectedTagIds.contains);
    final imageChanged =
        selectedImage != null ||
        (removeExistingImage && widget.image.isNotEmpty);

    return titleController.text.trim() != widget.title.trim() ||
        descriptionController.text.trim() != widget.description.trim() ||
        _priceHasChanged ||
        visibility != widget.visibility ||
        tagsChanged ||
        imageChanged;
  }

  void _updateFormChanges() {
    final hasChanges = _computeHasFormChanges();
    if (hasChanges == _hasFormChanges || !mounted) return;
    setState(() => _hasFormChanges = hasChanges);
  }

  Future<void> _onVisibilityChanged(String value) async {
    if (value == visibility) return;

    if (value == 'PUBLIC' && visibility != 'PUBLIC') {
      final localizations = AppLocalizations.of(context)!;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          final primary = AppColors.primaryOf(dialogContext);

          return AlertDialog(
            backgroundColor: AppColors.surfaceOf(dialogContext),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            actionsPadding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
            title: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.public_rounded, color: primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizations.publicVisibilityWarningTitle,
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(dialogContext),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              localizations.publicVisibilityWarningMessage,
              style: TextStyle(
                color: AppColors.textSecondaryOf(dialogContext),
                fontSize: 14,
                height: 1.55,
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
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  localizations.confirm,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          );
        },
      );

      if (!mounted || confirmed != true) return;
    }

    setState(() {
      visibility = value;
      _hasFormChanges = _computeHasFormChanges();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
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
        _hasFormChanges = _computeHasFormChanges();
      });
    }
  }

  bool get isValid {
    return titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty;
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void saveChanges() async {
    final localizations = AppLocalizations.of(context)!;
    if (!isValid) {
      SnackbarTheme().newSnackBarError(
        context,
        localizations.fillAllFieldsWarning,
      );
      return;
    }
    if (!_hasFormChanges) return;

    String imagePath = widget.image;
    if (selectedImage != null) {
      final uploadCubit = context.read<UploadPhotoCourseCubit>();
      final uploadedUrl = await uploadCubit.uploadPhoto(selectedImage!);

      if (!mounted) return;

      if (uploadedUrl == null) {
        SnackbarTheme().newSnackBarError(
          context,
          localizations.failedToUploadImage,
        );
        return;
      }
      imagePath = uploadedUrl;
    } else if (removeExistingImage) {
      imagePath = '';
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
          backgroundColor: AppColors.backgroundOf(context),
          appBar: GradientPageAppBar(
            title: localizations.courseManagement,
            subtitle: widget.title,
            onBackPressed: _handleBack,
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
                      removeExistingImage = widget.image.isNotEmpty;
                      _hasFormChanges = _computeHasFormChanges();
                    });
                  },
                  uploadLabel: localizations.uploadImage,
                  enabled: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: titleController,
                  hintText: localizations.courseTitle,
                  icon: Icons.title_outlined,
                  enabled: true,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: companyController,
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
                  enabled: true,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: priceController,
                  hintText: localizations.price,
                  icon: Icons.attach_money_rounded,
                  keyboardType: TextInputType.number,
                  enabled: true,
                ),
                const SizedBox(height: 16),
                VisibilityDropdown(
                  value: visibility,
                  onChanged: _onVisibilityChanged,
                  publicLabel: localizations.public,
                  privateLabel: localizations.private,
                  enabled: true,
                ),
                const SizedBox(height: 18),
                CourseTagsSection(
                  selectedTagIds: selectedTagIds,
                  onToggle: toggleTag,
                  enabled: true,
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
                BlocBuilder<CourseCubit, CourseState>(
                  builder: (context, state) {
                    final isSaving = state is CourseUpdating;

                    return AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      alignment: Alignment.topCenter,
                      child: _hasFormChanges
                          ? Column(
                              children: [
                                CourseEditSaveButton(
                                  isLoading: isSaving,
                                  onPressed: isSaving ? null : saveChanges,
                                ),
                                const SizedBox(height: 14),
                              ],
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
                CoursePublishButton(courseId: widget.courseId),
                const SizedBox(height: 30),
                CourseDeleteButton(courseId: widget.courseId),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
