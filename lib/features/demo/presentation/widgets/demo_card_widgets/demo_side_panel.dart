import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoSidePanel extends StatelessWidget {
  final DemoEntity demo;
  final Size size;
  final double textScale;
  final AppLocalizations localizations;
  final bool isRestricted;
  final int daysLeft;

  const DemoSidePanel({
    super.key,
    required this.demo,
    required this.size,
    required this.textScale,
    required this.localizations,
    required this.isRestricted,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    final currentPlan = demo.plan?.toLowerCase() ?? 'starter';
    final isFreePlan = currentPlan == 'free';
    final avatarSize = 72.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.12),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textSecondary.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.5),
            child: Image.asset(
              'assets/images/logo1.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.textSecondary.withOpacity(0.08),
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: AppColors.textSecondary.withOpacity(0.4),
                  size: avatarSize * 0.4,
                ),
              ),
            ),
          ),
        ),
        if (demo.isOwner) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primary,
                  size: 11 * textScale,
                ),
                const SizedBox(width: 4),
                Text(
                  demo.plan ?? 'Starter',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * textScale,
                  ),
                ),
              ],
            ),
          ),
          if (!isRestricted && isFreePlan) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.orange.shade700,
                    size: 10 * textScale,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    localizations.daysLeftText(daysLeft),
                    style: AppTextStyles.label.copyWith(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 9 * textScale,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
}
