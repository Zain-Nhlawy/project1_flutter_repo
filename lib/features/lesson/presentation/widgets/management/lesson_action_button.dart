import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/lesson/presentation/widgets/custom_button.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonActionButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;
  final String? label; 

  const LessonActionButton({
    super.key,
    required this.loading,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return CustomButton(
      text: loading ? "..." : (label ?? l.createLesson),
      expand: true,
      gradient: AppColors.buttonGradient,
      onPressed: onPressed,
    );
  }
}