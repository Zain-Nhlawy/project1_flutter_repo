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
  final bool enabled;

  const TagsInput({
    super.key,
    required this.controller,
    required this.tags,
    required this.hintText,
    required this.addLabel,
    required this.onSubmitted,
    required this.onRemove,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (enabled)
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
        if (enabled) const SizedBox(height: 12),
        if (tags.isEmpty)
          Text(
            '—',
            style: TextStyle(color: AppColors.textSecondary.withOpacity(0.6)),
          )
        else
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
                    deleteIcon: enabled ? const Icon(Icons.close, size: 16, color: AppColors.primary) : null,
                    onDeleted: enabled ? () => onRemove(tag) : null,
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