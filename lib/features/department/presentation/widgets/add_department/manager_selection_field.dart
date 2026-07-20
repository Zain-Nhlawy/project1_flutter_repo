import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    final selectedUser = await Navigator.push<MembersEntity>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<DemoUserCubit>()..fetchUsers(demoId),
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.manager,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<AddDepartmentCubit, AddDepartmentState>(
          buildWhen: (previous, current) =>
              previous.selectedManager != current.selectedManager ||
              previous.showValidationErrors != current.showValidationErrors,
          builder: (context, state) {
            final hasError = state.showValidationErrors && state.selectedManager == null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => _selectManager(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasError
                            ? colors.error
                            : (state.selectedManager == null
                                ? colors.outline.withOpacity(0.5)
                                : colors.primary.withOpacity(0.5)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: hasError
                              ? colors.error
                              : (state.selectedManager == null
                                  ? colors.onSurfaceVariant
                                  : colors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.selectedManager == null
                                ? l10n.selectManager
                                : '${state.selectedManager!.firstName} ${state.selectedManager!.lastName}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: state.selectedManager == null
                                  ? colors.onSurfaceVariant
                                  : colors.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Text(
                      l10n.pleaseSelectManager,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.error,
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
