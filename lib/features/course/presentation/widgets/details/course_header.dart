import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_theme.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseHeader extends StatelessWidget {
  final String imageUrl;
  final int totalDurationSeconds;
  final int totalLessons;

  const CourseHeader({
    super.key,
    required this.imageUrl,
    required this.totalDurationSeconds,
    required this.totalLessons,
  });

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDuration = formatDuration(totalDurationSeconds);
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 310,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                boxShadow: const [AppTheme.primaryShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoItem(
                    Icons.access_time,
                    formattedDuration,
                    l10n.duration,
                    context,
                  ),
                  _infoItem(
                    Icons.play_circle_outline,
                    '$totalLessons',
                    l10n.lessons,
                    context,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(
    IconData icon,
    String val,
    String label,
    BuildContext context,
  ) => Column(
    children: [
      Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(width: 8),
          Text(
            val,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
    ],
  );
}
