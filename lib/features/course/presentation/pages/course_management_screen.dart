import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/pages/PlaceholderScreen.dart';
import 'package:project1/features/course/presentation/widgets/course_image_picker.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/course/presentation/widgets/management_action_tile.dart';
import 'package:project1/features/course/presentation/widgets/tags_selector.dart';
import 'package:project1/features/course/presentation/widgets/visibility_dropdown.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/features/section/presentation/pages/section_management_screen.dart';
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
  State<CourseManagementScreen> createState() =>
      _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  late String visibility;

  File? selectedImage;

  bool isEditing = false;

  late Set<String> selectedTagIds;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.title);

    descriptionController =
        TextEditingController(text: widget.description);

    priceController =
        TextEditingController(
          text: widget.price?.toString() ?? '',
        );

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
    });
  }
}
  bool get isValid {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  void toggleEditOrSave() async {
    final localizations =
        AppLocalizations.of(context)!;
    if (isEditing && !isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.fillAllFieldsWarning,
          ),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }
    if (isEditing) {
      String imagePath = widget.image;
      if (selectedImage != null) {
        final uploadedUrl = await context
            .read<UploadPhotoCourseCubit>()
            .uploadPhoto(selectedImage!);

        if (uploadedUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to upload image'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        imagePath = uploadedUrl;
      }
      // TODO
    }
setState(() {
  isEditing = !isEditing;
});
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context)!;
        bool removeExistingImage = false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
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
              hintText:
                  localizations.courseTitle,
              icon: Icons.title_outlined,
              enabled: isEditing,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: TextEditingController(
                text: widget.company,
              ),
              hintText: localizations.company,
              icon: Icons.apartment_outlined,
              enabled: false,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: descriptionController,
              hintText:
                  localizations.courseDescription,
              icon: Icons.description_outlined,
              maxLines: 4,
              enabled: isEditing,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: priceController,
              hintText: localizations.price,
              icon: Icons.attach_money_rounded,
              keyboardType:
                  TextInputType.number,
              enabled: isEditing,
            ),
            const SizedBox(height: 16),
            VisibilityDropdown(
              value: visibility,
              onChanged: (v) {
                setState(() {
                  visibility = v;
                });
              },
              publicLabel:
                  localizations.public,
              privateLabel:
                  localizations.private,
              enabled: isEditing,
            ),

                        const SizedBox(height: 18),
            Text(
              localizations.tags,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<CourseCubit, CourseState>(
              builder: (context, state) {
                if (state is CourseTagsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is CourseTagsLoaded) {
                  return TagsSelector(
                    availableTags: state.tags,
                    selectedTagIds: selectedTagIds,
                    onToggle: toggleTag,
                    enabled: isEditing,
                    isLoading: false,
                  );
                }

                if (state is CourseTagsError) {
                  return Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _InfoTile(
                    icon: Icons.menu_book_outlined,
                    label: localizations.lessons,
                    value: '${widget.lessons}',
                  ),
                  Container(
                    width: 1,
                    height: 34,
                    color: AppColors.border,
                  ),
                  _InfoTile(
                    icon: Icons.schedule_outlined,
                    label: localizations.duration,
                    value: '${widget.duration}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ManagementActionTile(
                    icon: Icons.help_outline_rounded,
                    label: localizations.manageFaq,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PlaceholderScreen(
                            title:
                                localizations.manageFaq,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ManagementActionTile(
                    icon: Icons.view_list_rounded,
                    label:
                        localizations.manageSections,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SectionManagementScreen(
                            courseTitle:
                                widget.title,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: toggleEditOrSave,
                icon: Icon(
                  isEditing
                      ? Icons.check_circle_outline
                      : Icons.edit_outlined,
                  color: isEditing
                      ? Colors.white
                      : AppColors.primary,
                ),
                label: Text(
                  isEditing
                      ? localizations.saveChanges
                      : localizations.editCourse,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isEditing
                        ? Colors.white
                        : AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isEditing
                      ? Colors.green.shade600
                      : Colors.transparent,
                  side: BorderSide(
                    color: isEditing
                        ? Colors.green.shade600
                        : AppColors.primary,
                    width: 1.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary
                .withOpacity(.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}