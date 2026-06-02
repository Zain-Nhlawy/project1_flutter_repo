import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) {
          final isActive = index == currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            height: size.height * 0.01,
            width: isActive ? size.width * 0.08 : size.width * 0.025,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}