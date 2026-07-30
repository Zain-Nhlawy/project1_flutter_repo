import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/department_member_cubit.dart';
import 'package:project1/features/department/presentation/cubit/department%20members%20cubit/deprtment_member_state.dart';
import 'package:project1/features/department/presentation/widgets/department_member/select_job_title_dialog.dart';
import 'package:project1/l10n/app_localizations.dart';

class SearchDepartmentMemberDialog extends StatefulWidget {
  final String departmentId;
  final String demoId;

  const SearchDepartmentMemberDialog({
    super.key,
    required this.departmentId,
    required this.demoId,
  });

  @override
  State<SearchDepartmentMemberDialog> createState() =>
      _SearchDepartmentMemberDialogState();
}

class _SearchDepartmentMemberDialogState
    extends State<SearchDepartmentMemberDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentMemberCubit>().searchDemoMembers(
            widget.departmentId,
            widget.demoId,
            '',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 550,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.searchDemoMembers,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    context.read<DepartmentMemberCubit>().searchDemoMembers(
                          widget.departmentId,
                          widget.demoId,
                          value,
                        );
                  },
                  decoration: InputDecoration(
                    hintText: l10n.searchMembersHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: colors.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: colors.outlineVariant, height: 1),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<DepartmentMemberCubit,
                      DepartmentMemberState>(
                    builder: (context, state) {
                      if (state is DepartmentMemberSearchLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is DepartmentMemberSearchError) {
                        return Center(
                          child: Text(
                            state.error,
                            style: TextStyle(color: colors.error),
                          ),
                        );
                      }

                      if (state is DepartmentMemberSearchLoaded) {
                        if (state.searchResults.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_search_outlined,
                                  size: 60,
                                  color: colors.outline,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.noMembersFound,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.searchResults.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final user = state.searchResults[index];
                            final hasImage = user.imagePath != null &&
                                user.imagePath!.isNotEmpty;

                            return Material(
                              color: colors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(18),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: colors.primaryContainer,
                                      backgroundImage: hasImage
                                          ? NetworkImage(user.imagePath!)
                                          : null,
                                      child: hasImage
                                          ? null
                                          : Text(
                                              user.firstName.isNotEmpty
                                                  ? user.firstName[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: TextStyle(
                                                color: colors.onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${user.firstName} ${user.lastName}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            user.email,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: colors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () async {
                                        final cubit = context
                                            .read<DepartmentMemberCubit>();

                                        final added = await showDialog<bool>(
                                          context: context,
                                          builder: (dialogContext) {
                                            return SelectJobTitleDialog(
                                              user: user,
                                              departmentId:
                                                  widget.departmentId,
                                              demoId: widget.demoId,
                                              cubit: cubit,
                                            );
                                          },
                                        );

                                        if (added == true && context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.person_add_rounded,
                                        size: 22,
                                      ),
                                      tooltip: l10n.addMember,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
