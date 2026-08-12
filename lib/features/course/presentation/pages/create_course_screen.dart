import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/course/presentation/widgets/course_tags_section.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/widgets/management/course_image_picker.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/course/presentation/widgets/management/visibility_dropdown.dart';
import 'package:project1/l10n/app_localizations.dart';

class CreateCourseScreen extends StatefulWidget {
  final String demoId;

  const CreateCourseScreen({super.key, required this.demoId});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String visibility = 'PUBLIC';
  File? selectedImage;
  bool _isSubmitting = false; 

  final Set<String> selectedTagIds = {};

  void toggleTag(String id) {
    setState(() {
      selectedTagIds.contains(id)
          ? selectedTagIds.remove(id)
          : selectedTagIds.add(id);
    });
  }

  bool get isValid =>
      _titleController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty &&
      _priceController.text.isNotEmpty;

  Future<void> handleCreateCourse() async {
    if (!isValid) {
      SnackbarTheme().newSnackBarError(
        context,
        AppLocalizations.of(context)!.pleaseFillAllFields,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    String imagePath = '';

    if (selectedImage != null) {
      final uploadedUrl = await context
          .read<UploadPhotoCourseCubit>()
          .uploadPhoto(selectedImage!);

      if (uploadedUrl == null) {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
        SnackbarTheme().newSnackBarError(
          context,
          AppLocalizations.of(context)!.failedToUploadImage,
        );
        return;
      }
      imagePath = uploadedUrl;
    }

    final course = CourseEntity(
      id: '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      visibility: visibility,
      price: double.tryParse(_priceController.text),
      imagePath: imagePath,
      demoId: widget.demoId,
      tagIds: selectedTagIds.toList(),
      demo: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      sectionsCount: 0,
      totalLessons: 0,
      totalDuration: 0,
    );
    context.read<CourseCubit>().createCourse(course);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;
    setState(() {
      selectedImage = File(image.path);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<CourseCubit, CourseState>(
      listener: (context, state) {
        if (state is CourseCreated) {
          SnackbarTheme().newSnackBarSuccess(
            context,
            localizations.courseCreatedSuccessfully,
          );
          Navigator.pop(context, true);
        }
        if (state is CourseCreateError) {
          if (mounted) {
            setState(() => _isSubmitting = false);
          }
          SnackbarTheme().newSnackBarError(
            context,
            state.errors.isNotEmpty ? state.errors.first : '',
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        appBar: GradientPageAppBar(
          title: localizations.createCourse,
          subtitle: localizations.courseDescription,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CourseCreationSection(
                icon: Icons.add_photo_alternate_outlined,
                title: localizations.uploadImage,
                child: CourseImagePicker(
                  key: ValueKey(selectedImage?.path),
                  selectedImage: selectedImage,
                  onTap: pickImage,
                  onRemove: () {
                    setState(() {
                      selectedImage = null;
                    });
                  },
                  uploadLabel: localizations.uploadImage,
                ),
              ),
              const SizedBox(height: 22),
              _CourseCreationSection(
                icon: Icons.auto_stories_outlined,
                title: localizations.courseDetails,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      hintText: localizations.courseTitle,
                      icon: Icons.title_outlined,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: localizations.courseDescription,
                      icon: Icons.description_outlined,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _priceController,
                      hintText: localizations.price,
                      icon: Icons.attach_money_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    VisibilityDropdown(
                      value: visibility,
                      onChanged: (v) => setState(() => visibility = v),
                      publicLabel: localizations.public,
                      privateLabel: localizations.private,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _CourseCreationSection(
                icon: Icons.sell_outlined,
                title: localizations.tags,
                child: CourseTagsSection(
                  selectedTagIds: selectedTagIds,
                  onToggle: toggleTag,
                  enabled: true,
                  showTitle: false,
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<CourseCubit, CourseState>(
                builder: (context, state) {
                  final loading = state is CourseCreating || _isSubmitting;
                  return GradientActionButton(
                    label: loading ? "Creating..." : localizations.createCourse,
                    icon: Icons.add_circle_outline_rounded,
                    isLoading: loading,
                    expand: true,
                    onPressed: loading ? null : handleCreateCourse,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseCreationSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _CourseCreationSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: primary, size: 20),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
