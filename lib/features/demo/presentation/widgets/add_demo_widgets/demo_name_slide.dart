import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/presentation/cubit/add%20demo%20wizard/add_demo_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoNameSlide extends StatelessWidget {
  const DemoNameSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.04),
            Text(
              localizations.startWithName,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 24 * textScale,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              localizations.giveCatchyTitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14 * textScale,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            _buildInputField(
              context: context,
              label: localizations.labelDemoName,
              hint: localizations.hintDemoName,
              icon: Icons.title_rounded,
              onChanged: (value) {
                context.read<AddDemoCubit>().updateDemoName(value);
              },
            ),
            SizedBox(height: size.height * 0.03),
            _buildInputField(
              context: context,
              label: localizations.labelDescription,
              hint: localizations.hintDescription,
              icon: Icons.description_outlined,
              maxLines: 3,
              onChanged: (value) {
                context.read<AddDemoCubit>().updateDemoDescription(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14 * textScale,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.textSecondary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 14 * textScale,
              ),
              prefixIcon: maxLines == 1
                  ? Icon(icon, color: AppColors.primary, size: 20 * textScale)
                  : Padding(
                      padding: EdgeInsets.only(
                        bottom: size.height * 0.06,
                        left: size.width * 0.03,
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.primary,
                        size: 20 * textScale,
                      ),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.02,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
