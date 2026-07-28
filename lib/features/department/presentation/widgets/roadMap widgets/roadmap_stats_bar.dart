import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class RoadmapStatsBar extends StatelessWidget {
  final int totalSteps;
  final int totalWeeks;
  final VoidCallback? onExportPdfPressed;

  const RoadmapStatsBar({
    super.key,
    required this.totalSteps,
    required this.totalWeeks,
    this.onExportPdfPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildStatItem(
                context,
                label: l10n.stepsLabel,
                value: '$totalSteps',
                icon: Icons.format_list_numbered_rounded,
              ),
              const SizedBox(width: 16),
              Container(
                width: 1,
                height: 24,
                color: borderColor,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                context,
                label: l10n.durationLabel,
                value: l10n.weeksCount(totalWeeks),
                icon: Icons.date_range_rounded,
              ),
            ],
          ),
          if (onExportPdfPressed != null) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onExportPdfPressed,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.headerGradientOf(context),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.exportPdf,
                        style: const TextStyle(
                          fontSize: 12,
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
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.headerGradientOf(context).createShader(bounds),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
