import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class FeaturesSlide extends StatelessWidget {
  const FeaturesSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<AddDemoCubit, AddDemoState>(
      builder: (context, state) {
        final cubit = context.read<AddDemoCubit>();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.04),
              Text(
                localizations.superchargeDemo,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimaryOf(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 24 * textScale,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                localizations.selectAddons,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontSize: 14 * textScale,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: size.height * 0.1),
                  itemCount: state.availableFeatures.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: size.height * 0.02),
                  itemBuilder: (context, index) {
                    final feature = state.availableFeatures[index];
                    final isSelected = state.selectedFeatureIndices.contains(
                      index,
                    );
                    final primary = AppColors.primaryOf(context);
                    final surface = AppColors.surfaceOf(context);
                    final textPrimary = AppColors.textPrimaryOf(context);
                    final textSecondary = AppColors.textSecondaryOf(context);
                    final border = AppColors.borderOf(context);
                    final isDark = Theme.of(context).brightness == Brightness.dark;

                    return InkWell(
                      onTap: () => cubit.toggleFeature(index),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary.withValues(alpha: 0.08)
                              : surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? primary
                                : border.withValues(alpha: 0.5),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (!isSelected)
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.25)
                                    : textSecondary.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(size.width * 0.025),
                              decoration: BoxDecoration(
                                color: (feature["color"] as Color).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                feature["icon"],
                                color: feature["color"],
                                size: 24 * textScale,
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        feature["title"],
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              color: textPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16 * textScale,
                                            ),
                                      ),
                                      Text(
                                        "\$${feature["price"].toStringAsFixed(2)}",
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              color: primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16 * textScale,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Text(
                                    feature["description"],
                                    style: AppTextStyles.label.copyWith(
                                      color: textSecondary,
                                      fontSize: 13 * textScale,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
