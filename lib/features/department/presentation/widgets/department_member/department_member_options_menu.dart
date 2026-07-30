import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/department_member_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class DepartmentMemberOptionsMenu extends StatelessWidget {
  final String departmentId;
  final String demoId;
  final String demoMemberId;

  const DepartmentMemberOptionsMenu({
    super.key,
    required this.departmentId,
    required this.demoId,
    required this.demoMemberId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert_rounded, color: colors.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colors.surfaceContainer,
      elevation: 3,
      onSelected: (value) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: colors.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.viewPersonalInfo,
                style: TextStyle(color: colors.onSurface),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                size: 20,
                color: colors.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.changePermissions,
                style: TextStyle(color: colors.onSurface),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            final cubit = context.read<DepartmentMemberCubit>();
            showDialog(
              context: context,
              builder: (dialogContext) {
                return BlocProvider.value(
                  value: cubit,
                  child: AlertDialog(
                    title: Text(l10n.removeMemberPrompt),
                    content: Text(l10n.areYouSureRemoveMember),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(l10n.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final successMessage =
                              l10n.memberRemovedSuccessfully;

                          final success = await cubit.removeDepartmentMember(
                            departmentId,
                            demoId,
                            demoMemberId,
                          );

                          if (success && dialogContext.mounted) {
                            SnackbarTheme().newSnackBarSuccess(
                              dialogContext,
                              successMessage,
                            );
                          }
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        },
                        child: Text(l10n.confirm),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.person_remove_rounded,
                size: 20,
                color: colors.error,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.removeFromRoom,
                style: TextStyle(
                  color: colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
