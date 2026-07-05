import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/widgets/course_image_picker.dart';
import 'package:project1/features/course/presentation/widgets/custom_button.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/course/presentation/widgets/tags_input.dart';
import 'package:project1/features/course/presentation/widgets/visibility_dropdown.dart';
import 'package:project1/l10n/app_localizations.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagController = TextEditingController();

  String visibility = 'public';
  List<String> tags = [];
  File? selectedImage;

  void addTag(String tag) {
    final cleaned = tag.trim();
    if (cleaned.isEmpty) return;
    if (tags.contains(cleaned)) return;

    setState(() {
      tags.add(cleaned);
    });

    _tagController.clear();
  }

  void removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  Future<void> pickImage() async {
    //TO DO
    // final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (picked != null) setState(() => selectedImage = File(picked.path));
  }

  bool get isValid {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty;
  }

  void handleCreateCourse() {
    if (!isValid) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.fillAllFieldsWarning),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
      return;
    }

    // TODO: submit
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tagController.dispose();
    super.dispose();
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
          localizations.createCourse,
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
              onTap: pickImage,
              onRemove: () => setState(() => selectedImage = null),
              uploadLabel: localizations.uploadImage,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              controller: _titleController,
              hintText: localizations.courseTitle,
              icon: Icons.title_outlined,
              onSubmitted: (_) => setState(() {}),
            ),

            const SizedBox(height: 14),

            CustomTextField(
              controller: _descriptionController,
              hintText: localizations.courseDescription,
              icon: Icons.description_outlined,
              maxLines: 4,
              onSubmitted: (_) => setState(() {}),
            ),

            const SizedBox(height: 14),

            CustomTextField(
              controller: _priceController,
              hintText: localizations.price,
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => setState(() {}),
            ),

            const SizedBox(height: 16),

            VisibilityDropdown(
              value: visibility,
              onChanged: (v) => setState(() => visibility = v),
              publicLabel: localizations.public,
              privateLabel: localizations.private,
            ),

            const SizedBox(height: 18),

            TagsInput(
              controller: _tagController,
              tags: tags,
              hintText: localizations.tags,
              addLabel: localizations.add,
              onSubmitted: addTag,
              onRemove: removeTag,
            ),

            const SizedBox(height: 28),

            Center(
              child: SizedBox(
                height: 52,
                child: CustomButton(
                  text: localizations.createCourse,
                  gradient: AppColors.buttonGradient,
                  expand: true,
                  onPressed: handleCreateCourse,
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