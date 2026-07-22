import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart' show AppTextStyles;
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/pages/demo_main_page.dart';
import 'package:project1/features/demo/presentation/pages/payment_pages/upgrade_plan.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class DemoMainContent extends StatelessWidget {
  final DemoEntity demo;
  final Size size;
  final double textScale;
  final AppLocalizations localizations;
  final bool isRestricted;

  const DemoMainContent({
    super.key,
    required this.demo,
    required this.size,
    required this.textScale,
    required this.localizations,
    required this.isRestricted,
  });

  @override
  Widget build(BuildContext context) {
    final canOpen = !isRestricted;
    final canUpgrade = isRestricted && demo.isOwner;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            demo.name,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16 * textScale,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            demo.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13 * textScale,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.textSecondary.withOpacity(0.08),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 13 * textScale,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  localizations.byAuthor(demo.ownerName),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: 12 * textScale,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                size: size,
                textScale: textScale,
                canOpen: canOpen,
                canUpgrade: canUpgrade,
                label: canOpen
                    ? localizations.see
                    : canUpgrade
                    ? localizations.upgradePlan
                    : localizations.see,
                onPressed: canOpen
                    ? () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DemoMainPage(demo: demo),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeThroughTransition(
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    child: child,
                                  );
                                },
                          ),
                        );
                      }
                    : canUpgrade
                    ? () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    UpgradePlanScreen(demoId: demo.id!),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeThroughTransition(
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    child: child,
                                  );
                                },
                          ),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Size size;
  final double textScale;
  final bool canOpen;
  final bool canUpgrade;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.size,
    required this.textScale,
    required this.canOpen,
    required this.canUpgrade,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final icon = canOpen
        ? Icons.chevron_right_rounded
        : canUpgrade
        ? Icons.bolt_rounded
        : Icons.lock_outline_rounded;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isDisabled ? null : AppColors.buttonGradient,
          color: isDisabled ? AppColors.textSecondary.withOpacity(0.15) : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: isDisabled
                    ? AppColors.textSecondary.withOpacity(0.6)
                    : AppColors.surface,
                fontWeight: FontWeight.w600,
                fontSize: 12 * textScale,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              color: isDisabled
                  ? AppColors.textSecondary.withOpacity(0.6)
                  : AppColors.surface,
              size: 14 * textScale,
            ),
          ],
        ),
      ),
    );
  }
}
