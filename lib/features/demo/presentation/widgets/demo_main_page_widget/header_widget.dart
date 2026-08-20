import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/domain/entities/demo_subscription_status.dart';
import 'package:project1/features/demo/presentation/pages/payment_pages/manage_plan.dart';
import 'package:project1/features/demo/presentation/pages/invitations_page.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/invitations_cubit/invitation_cubit.dart';

class HeaderWidget extends StatelessWidget {
  final DemoEntity demo;
  const HeaderWidget({super.key, required this.demo});

  String _subscriptionMessage(
    AppLocalizations localizations,
    DemoSubscriptionStatus status,
    int daysLeft,
  ) {
    return switch (status) {
      DemoSubscriptionStatus.trialing => localizations.daysLeftText(daysLeft),
      DemoSubscriptionStatus.active => localizations.subscriptionActive,
      DemoSubscriptionStatus.expired => localizations.freeTrialExpired,
      DemoSubscriptionStatus.cancelled => localizations.subscriptionCancelled,
      DemoSubscriptionStatus.unknown => localizations.manageSubscription,
    };
  }

  IconData _subscriptionIcon(DemoSubscriptionStatus status) {
    return switch (status) {
      DemoSubscriptionStatus.trialing => Icons.timer_outlined,
      DemoSubscriptionStatus.active => Icons.check_circle_outline_rounded,
      DemoSubscriptionStatus.expired => Icons.timer_off_outlined,
      DemoSubscriptionStatus.cancelled => Icons.cancel_outlined,
      DemoSubscriptionStatus.unknown => Icons.settings_outlined,
    };
  }

  Widget _buildHeaderImage(String? imagePath) {
    if (imagePath != null && imagePath.trim().isNotEmpty) {
      final path = imagePath.trim();
      if (path.startsWith('http://') || path.startsWith('https://')) {
        return Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallbackHeaderImage(),
        );
      } else if (path.startsWith('assets/')) {
        return Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallbackHeaderImage(),
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _fallbackHeaderImage(),
          );
        }
      }
    }
    return _fallbackHeaderImage();
  }

  Widget _fallbackHeaderImage() {
    return Image.asset(
      'assets/images/logo1.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.white.withValues(alpha: 0.2),
        child: Icon(
          Icons.business_rounded,
          color: Colors.white.withValues(alpha: 0.9),
          size: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final double topPadding = MediaQuery.paddingOf(context).top;

    final subscriptionStatus = demo.resolvedSubscriptionStatus();
    final daysLeft = demo.trialDaysLeft();

    return Container(
      width: size.width,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding > 0 ? topPadding + 12 : 36,
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _GhostIconButton(
                  icon: Icons.arrow_back_rounded,
                  textScale: textScale,
                  iconSize: 17,
                  buttonSize: 38,
                  onTap: () => Navigator.of(context).pop(),
                ),
                Row(
                  children: [
                    if (demo.isOwner) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              color: Colors.amberAccent,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Owner',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    _GhostIconButton(
                      icon: Icons.mail_outline_rounded,
                      textScale: textScale,
                      iconSize: 17,
                      buttonSize: 38,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  InvitationCubit(usecase: getIt()),
                              child: const InvitationsPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _GhostIconButton(
                      icon: Icons.notifications_none_rounded,
                      textScale: textScale,
                      iconSize: 17,
                      buttonSize: 38,
                      onTap: () {
                        // Notifications action
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Demo Avatar & Details Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.16,
                  height: size.width * 0.16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(child: _buildHeaderImage(demo.imagePath)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        demo.name,
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14 * textScale,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              l10n.byAuthor(demo.ownerName),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
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
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_alt_rounded,
                        color: Colors.white,
                        size: 15 * textScale,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        demo.membersCount.toString(),
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Subscription management banner
            if (demo.isOwner) ...[
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _subscriptionIcon(subscriptionStatus),
                            color: Colors.amberAccent,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _subscriptionMessage(
                              l10n,
                              subscriptionStatus,
                              daysLeft,
                            ),
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12 * textScale,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ManagePlanScreen(demoId: demo.id!),
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
                            if (context.mounted &&
                                getIt.isRegistered<DemoCubit>()) {
                              getIt<DemoCubit>().fetchDemos();
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceOf(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryOf(
                                  context,
                                ).withValues(alpha: 0.25),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 0.3
                                        : 0.1,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              l10n.managePlan,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.primaryOf(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 12 * textScale,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

class _GhostIconButton extends StatelessWidget {
  final IconData icon;
  final double textScale;
  final double iconSize;
  final double buttonSize;
  final VoidCallback onTap;

  const _GhostIconButton({
    required this.icon,
    required this.textScale,
    this.iconSize = 20,
    this.buttonSize = 44,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: buttonSize,
          height: buttonSize,
        ),
        icon: Icon(icon, color: Colors.white, size: iconSize * textScale),
      ),
    );
  }
}
