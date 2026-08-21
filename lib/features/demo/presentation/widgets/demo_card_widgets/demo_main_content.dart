import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart' show AppTextStyles;
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
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
    final canSubscribe = isRestricted && demo.isOwner;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            demo.name,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimaryOf(context),
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
              color: AppColors.textSecondaryOf(context),
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
            color: AppColors.borderOf(context).withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          _OwnerActionLayout(
            ownerName: demo.ownerName,
            textScale: textScale,
            stackAction: !canOpen,
            action: _ActionButton(
              size: size,
              textScale: textScale,
              canOpen: canOpen,
              canSubscribe: canSubscribe,
              label: canOpen
                  ? localizations.see
                  : canSubscribe
                  ? localizations.upgradePlan
                  : localizations.restricted,
              onPressed: canOpen
                  ? () async {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DemoMainPage(demo: demo),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeThroughTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    }
                  : canSubscribe
                  ? () async {
                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  UpgradePlanScreen(
                                    demoId: demo.id!,
                                    currentPlan: null,
                                  ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeThroughTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                      if (context.mounted && getIt.isRegistered<DemoCubit>()) {
                        getIt<DemoCubit>().fetchDemos();
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerActionLayout extends StatelessWidget {
  final String ownerName;
  final double textScale;
  final bool stackAction;
  final Widget action;

  const _OwnerActionLayout({
    required this.ownerName,
    required this.textScale,
    required this.stackAction,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final owner = Row(
      children: [
        Icon(
          Icons.person_outline_rounded,
          size: 13 * textScale,
          color: AppColors.textSecondaryOf(context).withValues(alpha: 0.7),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            ownerName,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondaryOf(context).withValues(alpha: 0.85),
              fontSize: 12 * textScale,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (stackAction) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          owner,
          const SizedBox(height: 10),
          Align(alignment: AlignmentDirectional.centerEnd, child: action),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: owner),
        const SizedBox(width: 8),
        action,
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Size size;
  final double textScale;
  final bool canOpen;
  final bool canSubscribe;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.size,
    required this.textScale,
    required this.canOpen,
    required this.canSubscribe,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final icon = canOpen
        ? Icons.chevron_right_rounded
        : canSubscribe
        ? Icons.bolt_rounded
        : Icons.lock_outline_rounded;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isDisabled ? null : AppColors.headerGradientOf(context),
          color: isDisabled
              ? AppColors.textSecondaryOf(context).withValues(alpha: 0.15)
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color:
                        (Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSecondary
                                : AppColors.secondary)
                            .withValues(alpha: 0.25),
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
                    ? AppColors.textSecondaryOf(context).withValues(alpha: 0.6)
                    : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12 * textScale,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              color: isDisabled
                  ? AppColors.textSecondaryOf(context).withValues(alpha: 0.6)
                  : Colors.white,
              size: 14 * textScale,
            ),
          ],
        ),
      ),
    );
  }
}
