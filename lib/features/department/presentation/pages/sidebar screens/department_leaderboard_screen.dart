import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/presentation/widgets/demo%20member%20card/user_info_dialog.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'package:project1/features/department/domain/entities/leaderboard_member_entity.dart';
import 'package:project1/features/department/presentation/cubit/leaderboard_cubit/leaderboard_cubit.dart';
import 'package:project1/features/department/presentation/cubit/leaderboard_cubit/leaderboard_state.dart';
import 'package:project1/features/department/presentation/widgets/leaderboard/leaderboard_list_tile.dart';
import 'package:project1/features/department/presentation/widgets/leaderboard/leaderboard_podium.dart';
import 'package:project1/l10n/app_localizations.dart';

class DepartmentLeaderboardScreen extends StatelessWidget {
  final String departmentId;
  final String? demoId;

  const DepartmentLeaderboardScreen({
    super.key,
    required this.departmentId,
    this.demoId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LeaderboardCubit>()
        ..getLeaderboard(
          departmentId: departmentId,
          demoId: demoId ?? '',
        ),
      child: _DepartmentLeaderboardView(
        departmentId: departmentId,
        demoId: demoId ?? '',
      ),
    );
  }
}

class _DepartmentLeaderboardView extends StatelessWidget {
  final String departmentId;
  final String demoId;

  const _DepartmentLeaderboardView({
    required this.departmentId,
    required this.demoId,
  });

  void _showMemberInfo(BuildContext context, LeaderboardMemberEntity member) {
    final departmentMember = DepartmentMemberEntity(
      id: member.departmentMemberId,
      departmentId: departmentId,
      jobTitle: member.jobTitle,
      demoMemberId: member.departmentMemberId,
      userId: member.userId,
      firstName: member.firstName,
      lastName: member.lastName,
      email: '',
      imagePath: member.imagePath ?? '',
    );
    UserInfoDialog.showForDepartmentMember(context, departmentMember);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        color: AppColors.primaryOf(context),
        backgroundColor: AppColors.surfaceOf(context),
        onRefresh: () async {
          await context.read<LeaderboardCubit>().getLeaderboard(
                departmentId: departmentId,
                demoId: demoId,
              );
        },
        child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading || state is LeaderboardInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LeaderboardError) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 56,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPrimaryOf(context),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<LeaderboardCubit>().getLeaderboard(
                                      departmentId: departmentId,
                                      demoId: demoId,
                                    );
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(l10n.tryAgain),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOf(context),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            if (state is LeaderboardLoaded) {
              final members = state.members;

              if (members.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              size: 72,
                              color: AppColors.textSecondaryOf(context)
                                  .withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noLeaderboardData,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondaryOf(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              final top3 = members.take(3).toList();
              final remaining = members.skip(3).toList();

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                children: [
                  // Top 3 Podium Stage
                  LeaderboardPodium(
                    topMembers: top3,
                    onMemberTap: (member) => _showMemberInfo(context, member),
                  ),

                  // Remaining Members List (Rank 4+)
                  if (remaining.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        l10n.topMembers,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                    ),
                    ...remaining.map(
                      (member) => LeaderboardListTile(
                        member: member,
                        onTap: () => _showMemberInfo(context, member),
                      ),
                    ),
                  ],
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
