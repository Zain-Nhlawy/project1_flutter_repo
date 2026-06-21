import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:project1/features/home/presentation/cubit/navigation_tabs_cubit.dart';
import 'package:project1/features/home/presentation/cubit/navigation_tabs_state.dart';
import 'package:project1/features/profile/presentation/cubit/locale_cubit.dart';
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
            body: PageView(
              controller: cubit.pageController,
              onPageChanged: (index) {
                cubit.updateIndex(index);
              },
              children: cubit.pages,
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
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.12,
          vertical: screenHeight * 0.01,
        ),
        height: screenHeight * 0.08,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                textScale: textScale,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                icon: Icons.history_outlined,
                index: 1,
                state: state,
                cubit: cubit,
                sideWord: localizations.navHistory,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                textScale: textScale,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                icon: Icons.person_outline,
                index: 2,
                state: state,
                cubit: cubit,
                sideWord: localizations.navProfile,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                textScale: textScale,
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
    required double screenWidth,
    required double screenHeight,
    required double textScale,
  }) {
    final isActive = state.currentIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => cubit.changePage(index),
            borderRadius: BorderRadius.circular(32),
            splashColor: AppColors.primary.withOpacity(0.1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              width: screenWidth * 0.125,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                icon,
                size: 24 * textScale,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.002),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              sideWord,
              style: AppTextStyles.label.copyWith(
                fontSize: 12 * textScale,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
