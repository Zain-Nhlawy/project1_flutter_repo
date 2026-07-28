import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class RoadmapHeaderBanner extends StatelessWidget {
  final VoidCallback onGeneratePressed;

  const RoadmapHeaderBanner({
    super.key,
    required this.onGeneratePressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          AppColors.primaryShadowOf(context),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alt_route_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.departmentRoadmap,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.roadmapSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: onGeneratePressed,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.newRoadmap,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
