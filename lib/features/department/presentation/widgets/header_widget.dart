import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class HeaderWidget extends StatelessWidget {
  final DemoEntity demo;
  const HeaderWidget({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    final double topPadding = MediaQuery.paddingOf(context).top;

    final createdAt = demo.createdAt ?? DateTime.now();
    final daysPassed = DateTime.now().difference(createdAt).inDays;
    final int daysLeft = (14 - daysPassed) > 0 ? (14 - daysPassed) : 0;

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (demo.isOwner) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.daysLeftText(daysLeft),
                          style: AppTextStyles.label.copyWith(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11 * textScale,
                          ),
                        ),
                        SizedBox(height: size.height * 0.008),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03,
                              vertical: size.height * 0.006,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.upgradePlan,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11 * textScale,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: size.width * 0.03),
                  ],
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
                child: Image.asset(
                  'assets/images/logo1.png',
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: size.width * 0.2,
                    height: size.width * 0.2,
                    color: AppColors.textSecondary.withOpacity(0.1),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.name,
                      style: AppTextStyles.h3.copyWith(
                        color: theme.colorScheme.surface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      l10n.byAuthor(demo.ownerName),
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
                  demo.membersCount.toString(),
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
