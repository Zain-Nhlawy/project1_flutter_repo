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
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 60,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.goodMorning,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface,
                      fontSize: 16 * textScale,
                    ),
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      String name = "";
                      if (state is UserLoaded) {
                        name = "${state.user.firstName} ${state.user.lastName}";
                      }
                      return Row(
                        children: [
                          Text(
                            name,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.surface,
                              fontSize: 24 * textScale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
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
                      backgroundColor: AppColors.surface.withOpacity(0.3),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      localizations.addDemo,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * textScale,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
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
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.menu_book_rounded,
                  count: myDemosCount.toString(),
                  label: localizations.statMyDemos,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  icon: Icons.star_border_rounded,
                  count: enrolledDemosCount.toString(),
                  label: localizations.statEnrolled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
