import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/lesson/presentation/widgets/custom_text_field.dart';
import 'package:project1/l10n/app_localizations.dart';

Future<String?> showAttachmentDialog(
  BuildContext context, {
  String? initialValue,
  required String title,
  required String confirmText,
}) {
  final controller = TextEditingController(text: initialValue);
  final l = AppLocalizations.of(context)!;

  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: CustomTextField(
          controller: controller,
          hintText: l.attachmentName,
          icon: initialValue == null
              ? Icons.attach_file
              : Icons.edit_outlined,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text.trim();

              if (value.isNotEmpty) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: Text(
              confirmText,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

