import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_state.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
import 'package:project1/features/department/presentation/cubit/department%20cubit/department_cubit.dart';
import 'package:project1/features/department/presentation/cubit/department%20cubit/department_state.dart';
import 'package:project1/features/department/presentation/pages/add_department_screen.dart';
import 'package:project1/features/department/presentation/widgets/item_card_widgets/item_card_widget.dart';
import 'package:project1/l10n/app_localizations.dart';

class SectionsContentWidget extends StatelessWidget {
  final DemoEntity demo;

  const SectionsContentWidget({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<DepartmentCubit, DepartmentState>(
      listener: (context, state) {
        if (state is DepartmentDeleted) {
          SnackbarTheme().newSnackBarSuccess(
            context,
            l10n.departmentDeletedSuccessfully,
          );
          context.read<DepartmentCubit>().fetchDepartments(demo.id!);
        } else if (state is DepartmentUpdated) {
          SnackbarTheme().newSnackBarSuccess(
            context,
            l10n.departmentUpdatedSuccessfully,
          );
          context.read<DepartmentCubit>().fetchDepartments(demo.id!);
        } else if (state is DepartmentCreated) {
          context.read<DepartmentCubit>().fetchDepartments(demo.id!);
        }
      },
      builder: (context, state) {
        if (state is DepartmentLoading || state is DepartmentInitial) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryOf(context),
            ),
          );
        }

        if (state is DepartmentError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is DepartmentLoaded) {
          final departments = state.departments;
          final currentPlan = demo.plan?.toLowerCase() ?? 'starter';
          final isFreePlan = currentPlan == 'starter' || currentPlan == 'free';
          final isLimitReached = isFreePlan && departments.length >= 5;

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: 8,
            ),
            children: [
              // Header title & action row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.yourSections,
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColors.textPrimaryOf(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOf(
                              context,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            departments.length.toString(),
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primaryOf(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (demo.isOwner)
                    InkWell(
                      onTap: isLimitReached
                          ? () {
                              SnackbarTheme().newSnackBarError(
                                context,
                                l10n.limitReachedSnackBar,
                              );
                            }
                          : () {
                              final departmentCubit = context
                                  .read<DepartmentCubit>();
                              final demoUserCubit = context
                                  .read<DemoUserCubit>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value: departmentCubit,
                                      ),
                                      BlocProvider.value(value: demoUserCubit),
                                    ],
                                    child: AddDepartmentScreen(
                                      demoId: demo.id!,
                                    ),
                                  ),
                                ),
                              );
                            },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isLimitReached
                              ? Colors.grey.withValues(alpha: 0.12)
                              : AppColors.primaryOf(
                                  context,
                                ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: isLimitReached
                                  ? Colors.transparent
                                  : AppColors.primaryOf(
                                      context,
                                    ).withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLimitReached
                                  ? Icons.lock_outline
                                  : Icons.add_rounded,
                              color: isLimitReached
                                  ? Colors.grey
                                  : AppColors.primaryOf(context),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isLimitReached
                                  ? l10n.limitReachedMessage
                                  : l10n.addSection,
                              style: AppTextStyles.label.copyWith(
                                color: isLimitReached
                                    ? Colors.grey
                                    : AppColors.primaryOf(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              if (departments.isEmpty)
                _SectionsEmptyState(demo: demo)
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: departments.length,
                  itemBuilder: (context, index) {
                    final department = departments[index];
                    final userState = context.watch<UserCubit>().state;
                    final demoUsersState = context.watch<DemoUserCubit>().state;
                    String? myMemberId;
                    if (userState is UserLoaded &&
                        demoUsersState is GetDemoUsersLoaded) {
                      myMemberId = context.read<DemoUserCubit>().getMyMemberId(
                        userState.user.id,
                      );
                    }
                    final isManager =
                        myMemberId != null &&
                        department.managerId == myMemberId;
                    final departmentCubit = context.read<DepartmentCubit>();
                    final demoUserCubit = context.read<DemoUserCubit>();
                    return ItemCardWidget(
                      departmentEntity: department,
                      icon: Icons.layers_rounded,
                      isOwner: demo.isOwner,
                      isManager: isManager,
                      demoId: demo.id!,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: departmentCubit),
                                BlocProvider.value(value: demoUserCubit),
                              ],
                              child: AddDepartmentScreen(
                                demoId: demo.id!,
                                departmentToEdit: department,
                              ),
                            ),
                          ),
                        );
                      },
                      onDelete: () {
                        _showDeleteConfirmationDialog(
                          context,
                          department: department,
                          demoId: demo.id!,
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 100),
            ],
          );
        }

        return Center(
          child: Text(
            l10n.somethingWentWrong,
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context, {
    required DepartmentEntity department,
    required String demoId,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final departmentCubit = context.read<DepartmentCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.removeDepartment,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          content: Text(
            l10n.deleteSectionConfirmation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.surfaceOf(context),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.cancel,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                departmentCubit.deleteDepartment(department.id!, demoId);
              },
              child: Text(
                l10n.delete,
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionsEmptyState extends StatelessWidget {
  final DemoEntity demo;

  const _SectionsEmptyState({required this.demo});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOf(context).withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.layers_clear_rounded,
              size: 36,
              color: AppColors.primaryOf(context),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noSectionFound,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addSection,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
            ),
            textAlign: TextAlign.center,
          ),
          if (demo.isOwner) ...[
            const SizedBox(height: 20),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.primaryOf(context),
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 20,
            //       vertical: 12,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(16),
            //     ),
            //   ),
            //   onPressed: () {
            //     final departmentCubit = context.read<DepartmentCubit>();
            //     final demoUserCubit = context.read<DemoUserCubit>();
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MultiBlocProvider(
            //           providers: [
            //             BlocProvider.value(value: departmentCubit),
            //             BlocProvider.value(value: demoUserCubit),
            //           ],
            //           child: AddDepartmentScreen(demoId: demo.id!),
            //         ),
            //       ),
            //     );
            //   },
            //   icon: const Icon(Icons.add_rounded, size: 18),
            //   label: Text(
            //     l10n.addSection,
            //     style: AppTextStyles.label.copyWith(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ],
      ),
    );
  }
}
