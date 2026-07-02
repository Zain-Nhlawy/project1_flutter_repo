import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/step_progress_indecator.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';
import '../cubit/demo_cubit.dart';
import '../cubit/demo_state.dart';
import '../cubit/add demo wizard/add_demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_state.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/demo_name_slide.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/features_slide.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/plan_and_image_slide.dart';
import 'package:project1/features/demo/presentation/widgets/add_demo_widgets/checkout_slide.dart';

class AddDemoScreen extends StatelessWidget {
  const AddDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => AddDemoCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<DemoCubit, DemoState>(
          listener: (context, demoState) {
            if (demoState is AddDemoLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (demoState is AddDemoSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Demo Created Successfully!')),
              );
              Navigator.pop(context);
            } else if (demoState is AddDemoError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(demoState.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SafeArea(
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
                            totalSteps: 4,
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
                          PlanAndImageSlide(),
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
                        onTap: state.currentPage == 3
                            ? () {
                                if (state.demoName.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localizations.nameRequiredError,
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                if (state.demoDescription.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localizations.descriptionRequiredError,
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final newDemo = DemoModel(
                                  name: state.demoName,
                                  description: state.demoDescription,
                                  imagePath: state.demoImagePath.isNotEmpty
                                      ? state.demoImagePath
                                      : 'assets/images/demo_placeholder.png',
                                  ownerName: 'Owner Name',
                                  isOwner: true,
                          
                                  membersCount: 1,
                                  createdAt: DateTime.now(),
                                );

                                context.read<DemoCubit>().addDemo(newDemo);
                              }
                            : cubit.nextPage,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
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
                              state.currentPage == 3
                                  ? localizations.payAndCreate(
                                      state.totalPrice.toStringAsFixed(2),
                                    )
                                  : localizations.continueBtn,
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
      ),
    );
  }
}
