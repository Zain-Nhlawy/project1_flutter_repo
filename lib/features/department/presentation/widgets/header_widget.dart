import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    final double topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      width: size.width,
      padding: EdgeInsets.only(
        top: topPadding > 0
            ? topPadding + (size.height * 0.02)
            : size.height * 0.06,
        left: size.width * 0.05,
        right: size.width * 0.05,
        bottom: size.height * 0.03,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.012,
                  ),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.surface,
                    size: 20 * textScale,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.012,
                  ),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.surface,
                    size: 20 * textScale,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            children: [
              Container(
                width: size.width * 0.15,
                height: size.width * 0.15,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_circle,
                  size: size.width * 0.13,
                  color: theme.colorScheme.surface,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.lincoCompanyDemo,
                      style: AppTextStyles.h3.copyWith(
                        color: theme.colorScheme.surface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      l10n.byAhmadAhmad,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.surface.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03,
              vertical: size.height * 0.005,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '14',
                  style: AppTextStyles.label.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                Icon(Icons.people, color: theme.colorScheme.surface, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
