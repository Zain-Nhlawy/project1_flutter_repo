import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/widgets/demo%20member%20card/user_info_dialog.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/config/theme/snackbar_theme.dart';

class UserOptionsMenu extends StatelessWidget {
  final MembersEntity user;
  final String demoId;
  final String userIdInDemo;
  final String role;
  const UserOptionsMenu({
    super.key,
    required this.user,
    required this.demoId,
    required this.userIdInDemo,
    required this.role,
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
      onSelected: (value) {
        if (value == 0) {
          UserInfoDialog.showForDemoMember(context, user);
        }
      },
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
        if (role != 'OWNER')
          PopupMenuItem(
            onTap: () {
              final cubit = context.read<DemoUserCubit>();
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return BlocProvider.value(
                    value: cubit,
                    child: AlertDialog(
                      title: Text(l10n.removeUserPrompt),
                      content: Text(l10n.areYouSureRemoveUser),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(l10n.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final successMessage =
                                l10n.memberRemovedSuccessfully;

                            final success = await cubit.removeUser(
                              demoId,
                              userIdInDemo,
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
