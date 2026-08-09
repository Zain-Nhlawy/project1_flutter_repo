import 'package:flutter/material.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
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

    return GradientActionButton(
      label: label ?? l.createLesson,
      icon: Icons.add_circle_outline_rounded,
      isLoading: loading,
      expand: true,
      onPressed: onPressed,
    );
  }
}
