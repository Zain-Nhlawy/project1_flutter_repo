import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/pages/add_demo_screen.dart';
import 'package:project1/features/home/presentation/widgets/state_card.dart';
import 'package:project1/l10n/app_localizations.dart';

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
      padding: EdgeInsets.only(
        top: size.height * 0.08,
        left: size.width * 0.06,
        right: size.width * 0.06,
        bottom: size.height * 0.04,
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
                  SizedBox(height: size.height * 0.005),
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
                          SizedBox(width: size.width * 0.02),
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
                        MaterialPageRoute(
                          builder: (routeContext) => BlocProvider.value(
                            value: currentDemoCubit,
                            child: const AddDemoScreen(),
                          ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.015,
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
                  SizedBox(width: size.width * 0.02),
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
          SizedBox(height: size.height * 0.04),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.menu_book_rounded,
                  count: myDemosCount.toString(),
                  label: localizations.statMyDemos,
                ),
              ),
              SizedBox(width: size.width * 0.04),
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
