import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  final int? usersCount;

  const DemoCard({
    super.key,
    required this.title,
    required this.description,
    required this.author,
    this.usersCount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      padding: EdgeInsets.all(size.width * 0.045),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16 * textScale,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13 * textScale,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            localizations.byAuthor(author),
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 12 * textScale,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (usersCount != null)
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: AppColors.textSecondary,
                      size: 16 * textScale,
                    ),
                    SizedBox(width: size.width * 0.015),
                    Text(
                      localizations.usersCountText(usersCount!),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12 * textScale,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
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
                        fontSize: 14 * textScale,
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.surface,
                      size: 16 * textScale,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
