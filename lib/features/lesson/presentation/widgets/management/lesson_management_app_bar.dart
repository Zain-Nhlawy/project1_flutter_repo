import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonManagementAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const LessonManagementAppBar({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: onBackPressed,
      ),
      title: Text(
        localizations.lessonManagement,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
