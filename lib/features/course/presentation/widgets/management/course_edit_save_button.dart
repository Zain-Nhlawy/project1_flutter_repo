import 'package:flutter/material.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseEditSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const CourseEditSaveButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GradientActionButton(
      label: localizations.saveChanges,
      icon: Icons.check_circle_outline_rounded,
      isLoading: isLoading,
      expand: true,
      onPressed: onPressed,
    );
  }
}
