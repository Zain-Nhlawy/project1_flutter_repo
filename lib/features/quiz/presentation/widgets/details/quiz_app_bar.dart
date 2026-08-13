import 'package:flutter/material.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onBackPressed;

  const QuizAppBar({super.key, this.title, this.subtitle, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GradientPageAppBar(
      title: title ?? localizations.quiz,
      subtitle: subtitle,
      onBackPressed: onBackPressed,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(subtitle == null || subtitle!.trim().isEmpty ? 72 : 82);
}
