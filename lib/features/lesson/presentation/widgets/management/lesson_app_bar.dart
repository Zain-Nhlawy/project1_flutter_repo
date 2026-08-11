import 'package:flutter/material.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;

  const LessonAppBar({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return GradientPageAppBar(
      title: l.createLesson,
      subtitle: l.lessonDescription,
      onBackPressed: onBackPressed,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(82);
}
