import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonVideoPicker extends StatelessWidget {
  final String? selectedVideo;
  final VoidCallback onTap;
  final bool enabled;

  const LessonVideoPicker({
    super.key,
    required this.selectedVideo,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(enabled ? .25 : .12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              color: enabled ? AppColors.primary : AppColors.textSecondary,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              selectedVideo ?? localizations.uploadLessonVideo,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            )
          ],
        ),
      ),
    );
  }
}