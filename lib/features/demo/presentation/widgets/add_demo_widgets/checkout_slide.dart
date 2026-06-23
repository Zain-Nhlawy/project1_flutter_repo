import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class CheckoutSlide extends StatelessWidget {
  const CheckoutSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<AddDemoCubit, AddDemoState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.04),
              Text(
                localizations.orderSummary,
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
                  children: [
                    _buildSummaryRow(
                      context: context,
                      title: localizations.baseDemoReservation,
                      price: "\$${state.basePrice.toStringAsFixed(2)}",
                      isBold: true,
                    ),
                    SizedBox(height: size.height * 0.02),
                    const Divider(color: AppColors.border),
                    SizedBox(height: size.height * 0.02),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localizations.selectedFeatures,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12 * textScale,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    if (state.selectedFeatureIndices.isEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          localizations.noFeaturesSelected,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      )
                    else
                      ...state.selectedFeatureIndices.map((index) {
                        final feature = state.availableFeatures[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.01),
                          child: _buildSummaryRow(
                            context: context,
                            title: feature["title"],
                            price: "\$${feature["price"].toStringAsFixed(2)}",
                            isBold: false,
                          ),
                        );
                      }),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _buildSummaryRow(
                        context: context,
                        title: localizations.totalAmount,
                        price: "\$${state.totalPrice.toStringAsFixed(2)}",
                        isBold: true,
                        titleColor: AppColors.primary,
                        priceColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow({
    required BuildContext context,
    required String title,
    required String price,
    required bool isBold,
    Color? titleColor,
    Color? priceColor,
  }) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: titleColor ?? AppColors.textPrimary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 15 * textScale,
          ),
        ),
        Text(
          price,
          style: AppTextStyles.titleMedium.copyWith(
            color: priceColor ?? AppColors.textPrimary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: 16 * textScale,
          ),
        ),
      ],
    );
  }
}