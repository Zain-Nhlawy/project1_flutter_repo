import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/pages/demo_users_page.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_cubit.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class ManagerSelectionField extends StatelessWidget {
  final String demoId;

  const ManagerSelectionField({super.key, required this.demoId});

  void _selectManager(BuildContext context) async {
    final cubit = context.read<AddDepartmentCubit>();
    DemoUserCubit demoUserCubit;
    try {
      demoUserCubit = context.read<DemoUserCubit>();
    } catch (_) {
      demoUserCubit = getIt<DemoUserCubit>()..fetchUsers(demoId);
    }

    final selectedUser = await Navigator.push<MembersEntity>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: demoUserCubit,
          child: DemoUsersScreen(
            demoId: demoId,
            onUserTap: (user) {
              Navigator.pop(context, user);
            },
          ),
        ),
      ),
    );

    if (selectedUser != null) {
      cubit.managerSelected(selectedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.manager,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w600,
            fontSize: 14 * textScale,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        BlocBuilder<AddDepartmentCubit, AddDepartmentState>(
          buildWhen: (previous, current) =>
              previous.selectedManager != current.selectedManager ||
              previous.showValidationErrors != current.showValidationErrors,
          builder: (context, state) {
            final hasError =
                state.showValidationErrors && state.selectedManager == null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () => _selectManager(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textSecondaryOf(context).withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.primary,
                            size: 20 * textScale,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.selectedManager == null
                                  ? l10n.selectManager
                                  : '${state.selectedManager!.firstName} ${state.selectedManager!.lastName}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: state.selectedManager == null
                                    ? AppColors.textSecondaryOf(context).withValues(
                                        alpha: 0.6,
                                      )
                                    : AppColors.textPrimaryOf(context),
                                fontSize: 14 * textScale,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textSecondaryOf(context).withValues(
                              alpha: 0.6,
                            ),
                            size: 22 * textScale,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
                    child: Text(
                      l10n.pleaseSelectManager,
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
