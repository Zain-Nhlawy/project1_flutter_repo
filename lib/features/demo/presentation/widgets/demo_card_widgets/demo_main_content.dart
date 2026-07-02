import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart' show AppTextStyles;
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/department/presentation/pages/demo_main_page.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoMainContent extends StatelessWidget {
  final DemoEntity demo;
  final Size size;
  final double textScale;
  final AppLocalizations localizations;
  final bool isRestricted;

  const DemoMainContent({
    required this.demo,
    required this.size,
    required this.textScale,
    required this.localizations,
    required this.isRestricted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            demo.name,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16 * textScale,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            demo.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13 * textScale,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            localizations.byAuthor(demo.ownerName),
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 12 * textScale,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: size.height * 0.01),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: isRestricted
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DemoMainPage(demo: demo),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isRestricted
                    ? AppColors.textSecondary.withOpacity(0.3)
                    : AppColors.tertiary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.01,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.see,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w600,
                      fontSize: 12 * textScale,
                    ),
                  ),
                  SizedBox(width: size.width * 0.01),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.surface,
                    size: 14 * textScale,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}