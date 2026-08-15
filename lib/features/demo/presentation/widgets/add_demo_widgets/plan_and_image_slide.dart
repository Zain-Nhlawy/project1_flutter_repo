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

  Future<void> _pickSignatureImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (context.mounted) {
        context.read<AddDemoCubit>().updateSignatureImagePath(pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    final primary = AppColors.primaryOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surface = AppColors.surfaceOf(context);
    final plans = <Map<String, dynamic>>[];

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
                  color: textPrimary,
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
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.5),
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
                              color: primary,
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              localizations.tapToUpload,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: textSecondary,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: state.demoImagePath.startsWith('http://') ||
                                  state.demoImagePath.startsWith('https://')
                              ? Image.network(
                                  state.demoImagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.file(
                                  File(state.demoImagePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Upload Owner Signature',
                style: AppTextStyles.titleLarge.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              GestureDetector(
                onTap: () => _pickSignatureImage(context),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.16,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.5),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: state.signatureImagePath.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.draw_outlined,
                              size: 36 * textScale,
                              color: primary,
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              localizations.tapToUpload,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: textSecondary,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: state.signatureImagePath.startsWith('http://') ||
                                  state.signatureImagePath.startsWith('https://')
                              ? Image.network(
                                  state.signatureImagePath,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                )
                              : Image.file(
                                  File(state.signatureImagePath),
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                        ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              // Text(
              //   localizations.selectPlan,
              //   style: AppTextStyles.titleLarge.copyWith(
              //     color: AppColors.textPrimary,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
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
                          ? primary.withValues(alpha: 0.1)
                          : surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? primary
                            : textSecondary.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.1),
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
                                ? primary
                                : textSecondary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            plan["icon"] as IconData,
                            color: isSelected
                                ? Colors.white
                                : textSecondary,
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
                                  color: textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${plan["members"]} • ${plan["sections"]}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: textSecondary,
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
                                ? primary
                                : textPrimary,
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
