import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class PlanAndImageSlide extends StatelessWidget {
  const PlanAndImageSlide({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (context.mounted) {
        context.read<AddDemoCubit>().updateImagePath(pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    final plans = [
      {
        "id": "STARTER",
        "title": "Starter",
        "members": "Up to 20 members",
        "sections": "5 sections",
        "price": "\$20/mo",
        "icon": Icons.rocket_launch_outlined,
      },
      {
        "id": "PRO",
        "title": "Pro",
        "members": "Up to 100 members",
        "sections": "Unlimited sections",
        "price": "\$100/mo",
        "icon": Icons.star_border_rounded,
      },
      {
        "id": "ENTERPRISE",
        "title": "Enterprise",
        "members": "Unlimited members",
        "sections": "Unlimited sections",
        "price": "\$200/mo",
        "icon": Icons.business_center_outlined,
      },
    ];

    return BlocBuilder<AddDemoCubit, AddDemoState>(
      builder: (context, state) {
        final cubit = context.read<AddDemoCubit>();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.uploadDemoImage,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              GestureDetector(
                onTap: () => _pickImage(context),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.5),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: state.demoImagePath.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40 * textScale,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              localizations.tapToUpload,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(state.demoImagePath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Text(
                localizations.selectPlan,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              ...plans.map((plan) {
                final isSelected = state.selectedPlan == plan["id"];
                return GestureDetector(
                  onTap: () => cubit.updatePlan(plan["id"] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.only(bottom: size.height * 0.02),
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            plan["icon"] as IconData,
                            color: isSelected
                                ? AppColors.surface
                                : AppColors.textSecondary,
                            size: 24 * textScale,
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan["title"] as String,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${plan["members"]} • ${plan["sections"]}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12 * textScale,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          plan["price"] as String,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16 * textScale,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
