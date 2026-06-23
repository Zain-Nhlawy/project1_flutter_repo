import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: size.width * 0.22,
                height: size.width * 0.22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.headerGradient,
                ),
                child: Center(
                  child: Text(
                    "AJ",
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 28 * textScale,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.015),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 3),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.surface,
                  size: 14 * textScale,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "Alex Johnson",
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20 * textScale,
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            "alex.johnson@company.com",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14 * textScale,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.menu_book_rounded,
                iconColor: Colors.blue,
                count: "3",
                label: localizations.profileDemos,
                size: size,
                textScale: textScale,
              ),
              Container(
                height: size.height * 0.05,
                width: 1,
                color: AppColors.border,
              ),
              _buildStatItem(
                icon: Icons.star_border_rounded,
                iconColor: Colors.teal,
                count: "2",
                label: localizations.profileEnrolled,
                size: size,
                textScale: textScale,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    required Size size,
    required double textScale,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 20 * textScale),
        SizedBox(height: size.height * 0.01),
        Text(
          count,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18 * textScale,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12 * textScale,
          ),
        ),
      ],
    );
  }
}
