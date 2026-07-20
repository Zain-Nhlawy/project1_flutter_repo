import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/presentation/cubit/search%20for%20users/search_user_state.dart';
import 'package:project1/features/demo/presentation/cubit/search%20for%20users/serach_user_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/config/theme/snackbar_theme.dart';

class SearchUserDialog extends StatelessWidget {
  final String demoId;
  const SearchUserDialog({super.key, required this.demoId});

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
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox(
              width: 550,
              height: 600,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        context.read<SearchUserCubit>().search(value);
                      },
                      decoration: InputDecoration(
                        hintText: l10n.searchUser,
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: colors.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: colors.outlineVariant, height: 1),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<SearchUserCubit, SearchUserState>(
                        builder: (context, state) {
                          if (state is SearchUserInitial) {
                            return Center(
                              child: Text(
                                l10n.startTyping,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          if (state is SearchUserLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is SearchUserEmpty) {
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
                                    l10n.noUsersFound,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is SearchUserError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: TextStyle(color: colors.error),
                              ),
                            );
                          }

                          if (state is SearchUserLoaded) {
                            return ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.users.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final user = state.users[index];

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
                                          radius: 26,
                                          backgroundImage: NetworkImage(
                                            user.imagePath ?? '',
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
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                user.email,
                                                style: TextStyle(
                                                  color:
                                                      colors.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Center(
                                          child: IconButton(
                                            onPressed: () {
                                              if (user.id != null) {
                                                showDialog(
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        l10n.sendInvitation,
                                                      ),
                                                      content: Text(
                                                        l10n.areYouSureSendInvitation,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                dialogContext,
                                                              ).pop(),
                                                          child: Text(
                                                            l10n.cancel,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                              dialogContext,
                                                            ).pop();
                                                            final error = await context
                                                                .read<
                                                                  DemoUserCubit
                                                                >()
                                                                .sendInvitation(
                                                                  demoId,
                                                                  user.id!,
                                                                );

                                                            if (context
                                                                .mounted) {
                                                              if (error !=
                                                                  null) {
                                                                SnackbarTheme()
                                                                    .newSnackBarError(
                                                                      context,
                                                                      error ==
                                                                              'user_already_invited'
                                                                          ? l10n.userAlreadyInvited
                                                                          : error,
                                                                    );
                                                              } else {
                                                                SnackbarTheme()
                                                                    .newSnackBarSuccess(
                                                                      context,
                                                                      l10n.invitationSentSuccessfully,
                                                                    );
                                                              }
                                                            }
                                                          },
                                                          child: Text(
                                                            l10n.confirm,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.person_add_rounded,
                                              size: 22,
                                            ),
                                            tooltip: l10n.sendInvitation,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
