import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/pages/add_demo_screen.dart';
import 'package:project1/features/home/presentation/widgets/state_card.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);

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
                    "Good morning,",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface,
                      fontSize: 16 * textScale,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Row(
                    children: [
                      Text(
                        "Alex Johnson",
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.surface,
                          fontSize: 24 * textScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddDemoScreen(),
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
                      "Add Demo",
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
              const Expanded(
                child: StatCard(
                  icon: Icons.menu_book_rounded,
                  count: "3",
                  label: "My Demos",
                ),
              ),
              SizedBox(width: size.width * 0.04),
              const Expanded(
                child: StatCard(
                  icon: Icons.star_border_rounded,
                  count: "2",
                  label: "Enrolled",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
