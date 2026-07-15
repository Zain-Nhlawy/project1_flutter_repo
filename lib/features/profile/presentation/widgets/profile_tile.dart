import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final Widget trailing;
  final bool showDivider;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.trailing,
    this.showDivider = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.015,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(size.width * 0.025),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20 * textScale,
                  ),
                ),
                SizedBox(width: size.width * 0.04),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 15 * textScale,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.16),
              child: Divider(
                color: AppColors.borderOf(context),
                height: 1,
                thickness: 0.5,
              ),
            ),
        ],
      ),
    );
  }
}

