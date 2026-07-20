import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_cubit.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class DepartmentNameField extends StatelessWidget {
  const DepartmentNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.sectionName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<AddDepartmentCubit, AddDepartmentState>(
          buildWhen: (previous, current) =>
              previous.showValidationErrors != current.showValidationErrors ||
              previous.name != current.name,
          builder: (context, state) {
            return TextFormField(
              initialValue: state.name,
              onChanged: (value) =>
                  context.read<AddDepartmentCubit>().nameChanged(value),
              decoration: InputDecoration(
                hintText: l10n.enterSectionName,
                errorText: state.showValidationErrors && state.name.trim().isEmpty
                    ? l10n.requiredField
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
