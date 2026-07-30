import 'package:flutter/material.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/department_member_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class SelectJobTitleDialog extends StatefulWidget {
  final MembersModel user;
  final String departmentId;
  final String demoId;
  final DepartmentMemberCubit cubit;

  const SelectJobTitleDialog({
    super.key,
    required this.user,
    required this.departmentId,
    required this.demoId,
    required this.cubit,
  });

  @override
  State<SelectJobTitleDialog> createState() => _SelectJobTitleDialogState();
}

class _SelectJobTitleDialogState extends State<SelectJobTitleDialog> {
  String _selectedTitle = 'INTERN';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final titles = [
      {'value': 'INTERN', 'label': l10n.intern},
      {'value': 'JUNIOR', 'label': l10n.junior},
      {'value': 'SENIOR', 'label': l10n.senior},
    ];

    final hasImage =
        widget.user.imagePath != null && widget.user.imagePath!.isNotEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.selectJobTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primaryContainer,
                backgroundImage:
                    hasImage ? NetworkImage(widget.user.imagePath!) : null,
                child: hasImage
                    ? null
                    : Text(
                        widget.user.firstName.isNotEmpty
                            ? widget.user.firstName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...titles.map((t) {
            final value = t['value']!;
            final label = t['label']!;
            final isSelected = _selectedTitle == value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTitle = value;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary.withValues(alpha: 0.1)
                        : colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colors.primary
                          : colors.outlineVariant.withValues(alpha: 0.5),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: isSelected
                            ? colors.primary
                            : colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? colors.primary : colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  setState(() {
                    _isSubmitting = true;
                  });

                  final demoMemberId =
                      widget.user.memberIdInDemo ?? widget.user.id ?? '';

                  await widget.cubit.addDepartmentMember(
                    widget.departmentId,
                    widget.demoId,
                    demoMemberId,
                    _selectedTitle,
                  );

                  if (context.mounted) {
                    SnackbarTheme().newSnackBarSuccess(
                      context,
                      l10n.memberAddedSuccessfully,
                    );
                    Navigator.of(context).pop(true);
                  }
                },
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.addMember),
        ),
      ],
    );
  }
}
