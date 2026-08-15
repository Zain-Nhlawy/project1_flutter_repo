import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/invitations_cubit/invitation_cubit.dart';
import 'package:project1/features/demo/presentation/pages/add_demo_screen.dart';
import 'package:project1/features/demo/presentation/pages/invitations_page.dart';
import 'package:project1/features/home/presentation/widgets/state_card.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class MainHeader extends StatelessWidget {
  final int myDemosCount;
  final int enrolledDemosCount;
  const MainHeader({
    super.key,
    required this.myDemosCount,
    required this.enrolledDemosCount,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -46,
            top: -52,
            child: Container(
              width: 164,
              height: 164,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface.withValues(alpha: 0.07),
              ),
            ),
          ),
          PositionedDirectional(
            start: -58,
            bottom: -78,
            child: Container(
              width: 154,
              height: 154,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface.withValues(alpha: 0.08),
                  width: 24,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(
              top: topPadding + 14,
              start: 20,
              end: 20,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.goodMorning,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.surface.withValues(alpha: 0.76),
                              fontWeight: FontWeight.w500,
                            ) ?? AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.surface.withValues(alpha: 0.76),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          BlocBuilder<UserCubit, UserState>(
                            builder: (context, state) {
                              String name = '';
                              if (state is UserLoaded) {
                                name =
                                    '${state.user.firstName} ${state.user.lastName}';
                              }
                              return Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.surface,
                                  fontSize: 25,
                                  height: 1.15,
                                  letterSpacing: -0.4,
                                  fontWeight: FontWeight.w700,
                                ) ?? AppTextStyles.h2.copyWith(
                                  color: AppColors.surface,
                                  fontSize: 25,
                                  height: 1.15,
                                  letterSpacing: -0.4,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Invitation button (left)
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
                        // Notification button (right)
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
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.grid_view_rounded,
                        count: myDemosCount.toString(),
                        label: localizations.statMyDemos,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.school_outlined,
                        count: enrolledDemosCount.toString(),
                        label: localizations.statEnrolled,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.20),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final currentDemoCubit = context.read<DemoCubit>();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (routeContext, animation, secondaryAnimation) =>
                                  BlocProvider.value(
                                    value: currentDemoCubit,
                                    child: const AddDemoScreen(),
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface.withValues(
                        alpha: 0.24,
                      ),
                      foregroundColor: AppColors.surface,
                      overlayColor: AppColors.surface.withValues(alpha: 0.08),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      minimumSize: const Size.fromHeight(48),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      side: BorderSide(
                        color: AppColors.surface.withValues(alpha: 0.18),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 21),
                    label: Text(
                      localizations.addDemo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.surface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ) ?? AppTextStyles.titleMedium.copyWith(
                        color: AppColors.surface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    this.iconSize = 17,
    this.buttonSize = 38,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
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
        icon: Icon(icon, color: AppColors.surface, size: iconSize * textScale),
      ),
    );
  }
}
