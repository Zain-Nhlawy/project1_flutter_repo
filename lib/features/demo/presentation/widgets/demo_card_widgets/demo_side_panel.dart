import 'dart:ui' show FontWeight;

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
    required this.demo,
    required this.size,
    required this.textScale,
    required this.localizations,
    required this.isRestricted,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/logo1.png',
            width: size.width * 0.2,
            height: size.width * 0.2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: size.width * 0.2,
              height: size.width * 0.2,
              color: AppColors.textSecondary.withOpacity(0.1),
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Icon(
        //       Icons.people_outline,
        //       color: AppColors.textSecondary,
        //       size: 16 * textScale,
        //     ),
        //     SizedBox(width: size.width * 0.015),
        //     Text(
        //       localizations.usersCountText(demo.membersCount),
        //       style: AppTextStyles.label.copyWith(
        //         color: AppColors.textSecondary,
        //         fontSize: 12 * textScale,
        //       ),
        //     ),
        //   ],
        // ),
        if (demo.isOwner) ...[
          SizedBox(height: size.height * 0.015),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                  vertical: size.height * 0.004,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  demo.plan ?? 'Starter',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * textScale,
                  ),
                ),
              ),
              if (isRestricted) ...[
                SizedBox(width: size.width * 0.02),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.height * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      localizations.upgradePlan,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 10 * textScale,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (!isRestricted) ...[
            SizedBox(height: size.height * 0.008),
            Text(
              localizations.daysLeftText(daysLeft),
              style: AppTextStyles.label.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 10 * textScale,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
