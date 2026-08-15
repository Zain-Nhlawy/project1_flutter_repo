import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
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
  final DepartmentEntity? departmentToEdit;

  const AddDepartmentScreen({
    super.key,
    required this.demoId,
    this.departmentToEdit,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final l10n = AppLocalizations.of(context)!;
    final isEdit = departmentToEdit != null;

    return BlocProvider(
      create: (context) => AddDepartmentCubit(
        getIt<GetDepartmentUseCase>(),
        departmentToEdit: departmentToEdit,
      ),
      child: BlocListener<AddDepartmentCubit, AddDepartmentState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AddDepartmentStatus.success) {
            SnackbarTheme().newSnackBarSuccess(
              context,
              isEdit
                  ? l10n.departmentUpdatedSuccessfully
                  : l10n.departmentAddedSuccessfully,
            );
            context.read<DepartmentCubit>().fetchDepartments(demoId);
            Navigator.pop(context);
          } else if (state.status == AddDepartmentStatus.error) {
            SnackbarTheme().newSnackBarError(context, state.errorMessage ?? '');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundOf(context),
          appBar: AppBar(
            backgroundColor: AppColors.backgroundOf(context),
            elevation: 0,
            centerTitle: true,
            title: Text(
              isEdit ? l10n.editDepartment : l10n.addSection,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimaryOf(context),
                fontWeight: FontWeight.bold,
                fontSize: 20 * textScale,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimaryOf(context),
                size: 24 * textScale,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DepartmentNameField(),
                  SizedBox(height: size.height * 0.03),
                  const DepartmentDescriptionField(),
                  SizedBox(height: size.height * 0.03),
                  ManagerSelectionField(demoId: demoId),
                  SizedBox(height: size.height * 0.05),
                  SubmitDepartmentButton(demoId: demoId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
