import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/pages/payment_pages/upgrade_plan.dart';
import 'package:project1/features/demo/presentation/pages/invitations_page.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/presentation/cubit/invitations_cubit/invitation_cubit.dart';

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

    final currentPlan = demo.plan?.toLowerCase() ?? 'starter';
    final isFreePlan = currentPlan == 'starter' || currentPlan == 'free';

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
              _GhostIconButton(
                icon: Icons.arrow_back_rounded,
                textScale: textScale,
                onTap: () => Navigator.of(context).pop(),
              ),
              _GhostIconButton(
                icon: Icons.notifications_none_rounded,
                textScale: textScale,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => InvitationCubit(usecase: getIt()),
                        child: const InvitationsPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: size.height * 0.025),
          Row(
            children: [
              Container(
                width: size.width * 0.15,
                height: size.width * 0.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface.withOpacity(0.35),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo1.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surface.withOpacity(0.15),
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: AppColors.surface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.name,
                      style: AppTextStyles.h3.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.height * 0.004),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 13 * textScale,
                          color: theme.colorScheme.surface.withOpacity(0.75),
                        ),
                        SizedBox(width: size.width * 0.01),
                        Flexible(
                          child: Text(
                            l10n.byAuthor(demo.ownerName),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: theme.colorScheme.surface.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.028,
                  vertical: size.height * 0.007,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      color: theme.colorScheme.surface,
                      size: 14 * textScale,
                    ),
                    SizedBox(width: size.width * 0.012),
                    Text(
                      demo.membersCount.toString(),
                      style: AppTextStyles.label.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (demo.isOwner && isFreePlan) ...[
            SizedBox(height: size.height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.035,
                    vertical: size.height * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.surface.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.orangeAccent,
                        size: 15 * textScale,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Text(
                          l10n.daysLeftText(daysLeft),
                          style: AppTextStyles.label.copyWith(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11 * textScale,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
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
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.height * 0.007,
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
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GhostIconButton extends StatelessWidget {
  final IconData icon;
  final double textScale;
  final VoidCallback onTap;

  const _GhostIconButton({
    required this.icon,
    required this.textScale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withOpacity(0.18),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: AppColors.surface, size: 20 * textScale),
        ),
      ),
    );
  }
}
