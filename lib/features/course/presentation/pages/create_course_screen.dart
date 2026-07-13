import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/widgets/course_tags_section.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/widgets/management/course_image_picker.dart';
import 'package:project1/features/course/presentation/widgets/custom_button.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/course/presentation/widgets/management/visibility_dropdown.dart';
import 'package:project1/l10n/app_localizations.dart';


class CreateCourseScreen extends StatefulWidget {
  final String demoId;

  const CreateCourseScreen({
    super.key,
    required this.demoId,
  });

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}


class _CreateCourseScreenState extends State<CreateCourseScreen> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String visibility = 'PUBLIC';
  File? selectedImage;

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  String imagePath = '';

  if (selectedImage != null) {
    final uploadedUrl = await context
        .read<UploadPhotoCourseCubit>()
        .uploadPhoto(selectedImage!);

    if (uploadedUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to upload image"),
          backgroundColor: Colors.red,
        ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Course created successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }

      if (state is CourseCreateError) {
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
          localizations.createCourse,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseImagePicker(
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
            const SizedBox(height: 16),

            CustomTextField(controller: _titleController, hintText: localizations.courseTitle, icon: Icons.title_outlined),
            const SizedBox(height: 12),

            CustomTextField(controller: _descriptionController, hintText: localizations.courseDescription, icon: Icons.description_outlined, maxLines: 4),
            const SizedBox(height: 12),

            CustomTextField(
              controller: _priceController,
              hintText: localizations.price,
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            VisibilityDropdown(
              value: visibility,
              onChanged: (v) => setState(() => visibility = v),
              publicLabel: localizations.public,
              privateLabel: localizations.private,
            ),

            const SizedBox(height: 16),

            CourseTagsSection(
              selectedTagIds: selectedTagIds,
              onToggle: toggleTag,
              enabled: true,
            ),

            const SizedBox(height: 24),

            BlocBuilder<CourseCubit, CourseState>(
              builder: (context, state) {
                final loading = state is CourseCreating;

                return SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: CustomButton(
                    text: loading ? "Creating..." : localizations.createCourse,
                    gradient: AppColors.buttonGradient,
                    expand: true,
                    onPressed: loading ? null : handleCreateCourse,
                  ),
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