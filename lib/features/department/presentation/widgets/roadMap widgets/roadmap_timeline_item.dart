import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/department/domain/entities/roadmap_entity.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'roadmap_card_content.dart';

class RoadmapTimelineItem extends StatelessWidget {
  final RoadmapStepEntity step;
  final bool isFirst;
  final bool isLast;

  const RoadmapTimelineItem({
    super.key,
    required this.step,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final borderColor = AppColors.borderOf(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator (vertical line & week circle node)
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Top line
                Container(
                  width: 2,
                  height: 24,
                  color: isFirst ? Colors.transparent : borderColor,
                ),
                // Step Node Circle
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.headerGradientOf(context),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      l10n.weekPrefix(step.week),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Bottom line extending to next item
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : borderColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: RoadmapCardContent(step: step),
            ),
          ),
        ],
      ),
    );
  }
}