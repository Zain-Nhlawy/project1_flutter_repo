import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/pages/PlaceholderScreen.dart';
import 'package:project1/features/course/presentation/widgets/course_image_picker.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/course/presentation/widgets/management_action_tile.dart';
import 'package:project1/features/course/presentation/widgets/tags_input.dart';
import 'package:project1/features/course/presentation/widgets/visibility_dropdown.dart';
import 'package:project1/features/section/presentation/pages/section_management_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseManagementScreen extends StatefulWidget {
  final String title;
  final String company;
  final String image;
  final int lessons;
  final String duration;

  const CourseManagementScreen({
    super.key,
    required this.title,
    required this.company,
    required this.image,
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
  final tagController = TextEditingController();

  String visibility = 'public';
  List<String> tags = [];
  File? selectedImage;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void addTag(String tag) {
    final cleaned = tag.trim();
    if (cleaned.isEmpty) return;
    if (tags.contains(cleaned)) return;
    setState(() => tags.add(cleaned));
    tagController.clear();
  }

  void removeTag(String tag) {
    setState(() => tags.remove(tag));
  }

  Future<void> pickImage() async {
    // TODO
    // final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (picked != null) setState(() => selectedImage = File(picked.path));
  }

  bool get isValid {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty;
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
      // TODO: 
      setState(() => isEditing = false);
    } else {
      setState(() => isEditing = true);
    }
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
              initialImageUrl: widget.image,
              onTap: pickImage,
              onRemove: () => setState(() => selectedImage = null),
              uploadLabel: localizations.uploadImage,
              enabled: isEditing,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              controller: titleController,
              hintText: localizations.courseTitle,
              icon: Icons.title_outlined,
              enabled: isEditing,
              onSubmitted: (_) => setState(() {}),
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
              onSubmitted: (_) => setState(() {}),
            ),

            const SizedBox(height: 14),

            CustomTextField(
              controller: priceController,
              hintText: localizations.price,
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
              enabled: isEditing,
              onSubmitted: (_) => setState(() {}),
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

            TagsInput(
              controller: tagController,
              tags: tags,
              hintText: localizations.tags,
              addLabel: localizations.add,
              onSubmitted: addTag,
              onRemove: removeTag,
              enabled: isEditing,
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.border, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoTile(
                    icon: Icons.menu_book_outlined,
                    label: localizations.lessons,
                    value: '${widget.lessons}',
                  ),
                  Container(width: 1, height: 34, color: AppColors.border),
                  _InfoTile(
                    icon: Icons.schedule_outlined,
                    label: localizations.duration,
                    value: widget.duration,
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
                          builder: (_) => PlaceholderScreen(title: localizations.manageFaq),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ManagementActionTile(
                    icon: Icons.view_list_rounded,
                    label: localizations.manageSections,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SectionManagementScreen(courseTitle: widget.title),
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
                  isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                  color: isEditing ? Colors.white : AppColors.primary,
                ),
                label: Text(
                  isEditing ? localizations.saveChanges : localizations.editCourse,
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

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }
}