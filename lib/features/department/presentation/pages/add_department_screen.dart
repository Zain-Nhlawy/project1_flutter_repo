import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/department/domain/use_case/get_department_use_case.dart';
import 'package:project1/features/department/presentation/cubit/department%20cubit/department_cubit.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_cubit.dart';
import 'package:project1/features/department/presentation/cubit/add_department_cubit/add_department_state.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/config/theme/snackbar_theme.dart';

import '../widgets/add_department/department_name_field.dart';
import '../widgets/add_department/department_description_field.dart';
import '../widgets/add_department/manager_selection_field.dart';
import '../widgets/add_department/submit_department_button.dart';

class AddDepartmentScreen extends StatelessWidget {
  final String demoId;
  const AddDepartmentScreen({super.key, required this.demoId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => AddDepartmentCubit(getIt<GetDepartmentUseCase>()),
      child: BlocListener<AddDepartmentCubit, AddDepartmentState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AddDepartmentStatus.success) {
            SnackbarTheme().newSnackBarSuccess(
              context,
              l10n.departmentAddedSuccessfully,
            );
            context.read<DepartmentCubit>().fetchDepartments(demoId);
            Navigator.pop(context);
          } else if (state.status == AddDepartmentStatus.error) {
            SnackbarTheme().newSnackBarError(context, state.errorMessage ?? '');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.addSection),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DepartmentNameField(),
                const SizedBox(height: 24),
                const DepartmentDescriptionField(),
                const SizedBox(height: 24),
                ManagerSelectionField(demoId: demoId),
                const SizedBox(height: 48),
                SubmitDepartmentButton(demoId: demoId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
