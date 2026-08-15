import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_cubit.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class DepartmentNameField extends StatelessWidget {
  const DepartmentNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sectionName,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w600,
            fontSize: 14 * textScale,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        BlocBuilder<AddDepartmentCubit, AddDepartmentState>(
          buildWhen: (previous, current) =>
              previous.showValidationErrors != current.showValidationErrors ||
              previous.name != current.name,
          builder: (context, state) {
            final hasError =
                state.showValidationErrors && state.name.trim().isEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withValues(alpha: 0.25) : AppColors.textSecondary.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    initialValue: state.name,
                    onChanged: (value) =>
                        context.read<AddDepartmentCubit>().nameChanged(value),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 14 * textScale,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.enterSectionName,
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryOf(context).withValues(alpha: 0.6),
                        fontSize: 14 * textScale,
                      ),
                      prefixIcon: Icon(
                        Icons.title_rounded,
                        color: AppColors.primaryOf(context),
                        size: 20 * textScale,
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
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
                    child: Text(
                      l10n.requiredField,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
