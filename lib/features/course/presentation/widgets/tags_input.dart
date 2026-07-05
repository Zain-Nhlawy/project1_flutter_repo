import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/widgets/custom_button.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';

class TagsInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> tags;
  final String hintText;
  final String addLabel;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onRemove;

  const TagsInput({
    super.key,
    required this.controller,
    required this.tags,
    required this.hintText,
    required this.addLabel,
    required this.onSubmitted,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller,
                hintText: hintText,
                icon: Icons.label_outline,
                onSubmitted: onSubmitted,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 90,
              height: 52,
              child: CustomButton(
                text: addLabel,
                gradient: AppColors.buttonGradient,
                expand: false,
                onPressed: () => onSubmitted(controller.text),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Chip(
                    label: Text(
                      tag,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: AppColors.primary.withOpacity(0.08),
                    deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.primary),
                    onDeleted: () => onRemove(tag),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}