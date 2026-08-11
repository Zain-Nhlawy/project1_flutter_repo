import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class LiveStreamStatusBadge extends StatelessWidget {
  final String status;

  const LiveStreamStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final upper = status.toUpperCase();

    if (upper == 'LIVE') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sensors_rounded, size: 14, color: Colors.red.shade600),
            const SizedBox(width: 4),
            Text(
              localizations.liveStatusLive,
              style: AppTextStyles.label.copyWith(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    } else if (upper == 'ENDED') {
      final color = AppColors.textSecondaryOf(context);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stop_circle_outlined, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              localizations.liveStatusEnded,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            localizations.liveStatusScheduled,
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
