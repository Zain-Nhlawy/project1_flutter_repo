import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/step_progress_indecator.dart';
import '../cubit/add demo wizard/add_demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_state.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/demo_name_slide.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/features_slide.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/checkout_slide.dart';

class AddDemoScreen extends StatelessWidget {
  const AddDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return BlocProvider(
      create: (context) => AddDemoCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<AddDemoCubit, AddDemoState>(
            builder: (context, state) {
              final cubit = context.read<AddDemoCubit>();
              
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.02,
                    ),
                    child: Row(
                      children: [
                        if (state.currentPage > 0)
                          IconButton(
                            onPressed: cubit.previousPage,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.textPrimary,
                              size: 24 * textScale,
                            ),
                          )
                        else
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close_rounded,
                              color: AppColors.textPrimary,
                              size: 24 * textScale,
                            ),
                          ),
                        const Spacer(),
                        StepProgressIndicator(
                          totalSteps: 3,
                          currentStep: state.currentPage,
                        ),
                        const Spacer(),
                        SizedBox(width: size.width * 0.12),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: cubit.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        DemoNameSlide(),
                        FeaturesSlide(),
                        CheckoutSlide(),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(size.width * 0.06),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textSecondary.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: state.currentPage == 2 ? () {} : cubit.nextPage,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            state.currentPage == 2
                                ? "Pay \$${state.totalPrice.toStringAsFixed(2)} & Create"
                                : "Continue",
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * textScale,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}