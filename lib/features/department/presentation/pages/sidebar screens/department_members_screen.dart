import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/department/data/models/department_member_model.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/department_member_cubit.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/deprtment_member_state.dart';
import 'package:project1/features/department/presentation/widgets/department_member/department_member_card.dart';
import 'package:project1/features/department/presentation/widgets/department_member/search_department_member_dialog.dart';
import 'package:project1/l10n/app_localizations.dart';

class DepartmentMembersPage extends StatelessWidget {
  final String demoId;
  final String departmentId;
  final bool canManage;
  final String? managerId;

  const DepartmentMembersPage({
    super.key,
    required this.demoId,
    required this.departmentId,
    this.canManage = false,
    this.managerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DepartmentMemberCubit>()
            ..getDepartmentMembers(departmentId, demoId),
      child: _DepartmentMembersView(
        demoId: demoId,
        departmentId: departmentId,
        canManage: canManage,
        managerId: managerId,
      ),
    );
  }
}

class _DepartmentMembersView extends StatelessWidget {
  final String demoId;
  final String departmentId;
  final bool canManage;
  final String? managerId;

  const _DepartmentMembersView({
    required this.demoId,
    required this.departmentId,
    required this.canManage,
    this.managerId,
  });

  void _refresh(BuildContext context) {
    context.read<DepartmentMemberCubit>().getDepartmentMembers(
      departmentId,
      demoId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      floatingActionButton: canManage
          ? Container(
              decoration: BoxDecoration(
                gradient: AppColors.headerGradientOf(context),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isDark ? AppColors.darkSecondary : AppColors.secondary)
                            .withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () async {
                    final cubit = context.read<DepartmentMemberCubit>();
                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return BlocProvider.value(
                          value: cubit,
                          child: SearchDepartmentMemberDialog(
                            departmentId: departmentId,
                            demoId: demoId,
                          ),
                        );
                      },
                    );
                    if (context.mounted) {
                      cubit.restoreDepartmentMembers();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        color: AppColors.primaryOf(context),
        backgroundColor: AppColors.surfaceOf(context),
        onRefresh: () async => _refresh(context),
        child: BlocBuilder<DepartmentMemberCubit, DepartmentMemberState>(
          buildWhen: (previous, current) =>
              current is DepartmentMemberInitial ||
              current is DepartmentMemberLoading ||
              current is DepartmentMemberLoaded ||
              current is DepartmentMemberError,
          builder: (context, state) {
            if (state is DepartmentMemberInitial ||
                state is DepartmentMemberLoading) {
              return AppSkeletonizer(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => DepartmentMemberCard(
                    member: dummyDepartmentMember,
                    departmentId: departmentId,
                    demoId: demoId,
                    canManage: false,
                    onTap: () {},
                  ),
                ),
              );
            }

            if (state is DepartmentMemberError) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: _ErrorState(
                      message: state.error,
                      l10n: l10n,
                      onRetry: () => _refresh(context),
                    ),
                  ),
                ),
              );
            }

            List<DepartmentMemberModel> members = [];
            if (state is DepartmentMemberLoaded) {
              members = state.departmentMembers;
            } else {
              members = context.read<DepartmentMemberCubit>().cachedMembers;
            }

            if (members.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: _EmptyState(l10n: l10n),
                  ),
                ),
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: members.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final member = members[index];
                return DepartmentMemberCard(
                  member: member,
                  departmentId: departmentId,
                  demoId: demoId,
                  canManage: canManage,
                  managerId: managerId,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noMembersInDepartment,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.l10n,
    required this.onRetry,
  });

  final String message;
  final AppLocalizations l10n;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(l10n.tryAgain)),
          ],
        ),
      ),
    );
  }
}
