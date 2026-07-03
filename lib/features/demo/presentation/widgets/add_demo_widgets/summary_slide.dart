import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class SummarySlide extends StatelessWidget {
  const SummarySlide({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<AddDemoCubit, AddDemoState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.04),
                Text(
                  localizations.demoSummary,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24 * textScale,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  localizations.reviewDemoDetails,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14 * textScale,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Container(
                  padding: EdgeInsets.all(size.width * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textSecondary.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        context,
                        localizations.demoNameLabel,
                        state.demoName.isNotEmpty ? state.demoName : '-',
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildInfoRow(
                        context,
                        localizations.demoDescriptionLabel,
                        state.demoDescription.isNotEmpty
                            ? state.demoDescription
                            : '-',
                      ),
                      SizedBox(height: size.height * 0.02),
                      const Divider(color: AppColors.border),
                      SizedBox(height: size.height * 0.02),
                      _buildInfoRow(
                        context,
                        localizations.selectedPlanLabel,
                        state.selectedPlan,
                        valueColor: AppColors.primary,
                        isBoldValue: true,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        localizations.freeTrialLabel,
                        style: AppTextStyles.label.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12 * textScale,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      const Divider(color: AppColors.border),
                      SizedBox(height: size.height * 0.02),
                      // Text(
                      //   localizations.selectedFeatures,
                      //   style: AppTextStyles.label.copyWith(
                      //     color: AppColors.textSecondary,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 12 * textScale,
                      //   ),
                      // ),
                      // SizedBox(height: size.height * 0.015),
                      // if (state.selectedFeatureIndices.isEmpty)
                      //   Text(
                      //     localizations.noFeaturesSelected,
                      //     style: AppTextStyles.label.copyWith(
                      //       color: AppColors.textSecondary.withOpacity(0.7),
                      //     ),
                      //   )
                      // else
                      //   ...state.selectedFeatureIndices.map((index) {
                      //     final feature = state.availableFeatures[index];
                      //     return Padding(
                      //       padding: EdgeInsets.only(
                      //         bottom: size.height * 0.01,
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           Icon(
                      //             Icons.check_circle,
                      //             color: AppColors.primary,
                      //             size: 16 * textScale,
                      //           ),
                      //           SizedBox(width: size.width * 0.02),
                      //           Expanded(
                      //             child: Text(
                      //               feature["title"],
                      //               style: AppTextStyles.bodyMedium.copyWith(
                      //                 color: AppColors.textPrimary,
                      //                 fontSize: 14 * textScale,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //   );
                      //   }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    bool isBoldValue = false,
  }) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12 * textScale,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
            fontSize: 15 * textScale,
          ),
        ),
      ],
    );
  }
}
