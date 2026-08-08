import 'package:auto_size_text/auto_size_text.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/home/presentation/cubit/navigation_tabs_cubit.dart';
import 'package:project1/features/home/presentation/cubit/navigation_tabs_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class NavigationsTabs extends StatelessWidget {
  const NavigationsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final screenHeight = size.height;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationTabsCubit()),
        BlocProvider(create: (_) => getIt<DemoCubit>()..fetchDemos()),
      ],
      child: BlocBuilder<NavigationTabsCubit, NavigationTabsState>(
        builder: (context, state) {
          final cubit = context.read<NavigationTabsCubit>();

          return Scaffold(
            backgroundColor: AppColors.background,
            extendBody: true,
            body: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (
                    Widget child,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    );
                  },
              child: cubit.pages[state.currentIndex],
            ),
            bottomNavigationBar: _buildModernNavBar(
              state,
              cubit,
              screenWidth,
              screenHeight,
              textScale,
              localizations,
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernNavBar(
    NavigationTabsState state,
    NavigationTabsCubit cubit,
    double screenWidth,
    double screenHeight,
    double textScale,
    AppLocalizations localizations,
  ) {
    final clampedTextScale = textScale.clamp(0.85, 1.25);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildNavItem(
                icon: Icons.home_outlined,
                index: 0,
                state: state,
                cubit: cubit,
                sideWord: localizations.navMain,
                textScale: clampedTextScale,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                icon: Icons.history_outlined,
                index: 1,
                state: state,
                cubit: cubit,
                sideWord: localizations.navHistory,
                textScale: clampedTextScale,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                icon: Icons.person_outline,
                index: 2,
                state: state,
                cubit: cubit,
                sideWord: localizations.navProfile,
                textScale: clampedTextScale,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required NavigationTabsState state,
    required NavigationTabsCubit cubit,
    required String sideWord,
    required double textScale,
  }) {
    final isActive = state.currentIndex == index;

    return InkWell(
      onTap: () => cubit.changePage(index),
      borderRadius: BorderRadius.circular(24),
      splashColor: AppColors.primary.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 22 * textScale,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: AutoSizeText(
                sideWord,
                maxLines: 1,
                style: AppTextStyles.label.copyWith(
                  fontSize: 11 * textScale,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
