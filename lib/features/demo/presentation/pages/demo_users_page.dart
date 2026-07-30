import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/use%20case/demo_users_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/search%20for%20users/serach_user_cubit.dart';
import 'package:project1/features/demo/presentation/widgets/demo%20member%20card/search_user_dialog.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_state.dart';
import 'package:project1/features/demo/presentation/widgets/demo%20member%20card/demo_users_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoUsersScreen extends StatelessWidget {
  const DemoUsersScreen({
    super.key,
    required this.demoId,
    this.onUserTap,
    this.isOwner = true,
  });
  final bool isOwner;
  final String demoId;
  final ValueChanged<MembersEntity>? onUserTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        ),
        centerTitle: true,
        title: Text(l10n.demoMembers),
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradientOf(context),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.darkSecondary : AppColors.primary)
                  .withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              final demoUserCubit = context.read<DemoUserCubit>();
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: demoUserCubit),
                      BlocProvider(
                        create: (_) =>
                            SearchUserCubit(getIt<DemoUsersUsecase>()),
                      ),
                    ],
                    child: SearchUserDialog(demoId: demoId),
                  );
                },
              );
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
      ),
      body: BlocBuilder<DemoUserCubit, DemoUsersState>(
        builder: (context, state) {
          if (state is DemoUserInitial || state is GetDemoUsersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetDemoUsersError) {
            return _ErrorState(message: state.message, l10n: l10n);
          }

          if (state is GetDemoUsersLoaded) {
            if (state.users.isEmpty) {
              return _EmptyState(l10n: l10n);
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserCard(
                  user: user,
                  isOwner: isOwner,
                  onTap: onUserTap != null ? () => onUserTap!(user) : null,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
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
            Text(l10n.usersEmptyTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              l10n.usersEmptySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.l10n});

  final String message;
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
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
