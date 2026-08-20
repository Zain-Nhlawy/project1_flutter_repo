import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/demo/presentation/cubit/invitations_cubit/invitation_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/invitations_cubit/invitation_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<InvitationCubit>().getInvitations();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: Column(
        children: [
          _InvitationsHeader(
            topPadding: topPadding,
            title: l10n.invitationsTitle,
            subtitle: l10n.invitationsSubtitle,
          ),
          Expanded(
            child: BlocBuilder<InvitationCubit, InvitationState>(
              builder: (context, state) {
                if (state is InvitationLoading) {
                  return AppSkeletonizer(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceOf(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.borderOf(context),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 27,
                              backgroundColor: AppColors.backgroundOf(context),
                              child: const Icon(Icons.domain_rounded),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dummyInvitation.demoName),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.invitedBy(
                                      dummyInvitation.senderFirstName,
                                      dummyInvitation.senderLastName,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.close_rounded),
                            const SizedBox(width: 12),
                            const Icon(Icons.check_rounded),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is InvitationError) {
                  return RefreshIndicator(
                    color: AppColors.primaryOf(context),
                    backgroundColor: AppColors.surfaceOf(context),
                    onRefresh: () async =>
                        await context.read<InvitationCubit>().getInvitations(),
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Text(
                              state.message,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is InvitationLoaded) {
                  final invitations = state.invitations;
                  if (invitations.isEmpty) {
                    return RefreshIndicator(
                      color: AppColors.primaryOf(context),
                      backgroundColor: AppColors.surfaceOf(context),
                      onRefresh: () async => await context
                          .read<InvitationCubit>()
                          .getInvitations(),
                      child: LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Center(
                                  child: Text(
                                    l10n.noNewInvitations,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondaryOf(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primaryOf(context),
                    backgroundColor: AppColors.surfaceOf(context),
                    onRefresh: () async =>
                        await context.read<InvitationCubit>().getInvitations(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: invitations.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final inv = invitations[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceOf(context),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? 0.25
                                      : 0.04,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.borderOf(context),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundOf(context),
                                  border: Border.all(
                                    color: AppColors.borderOf(context),
                                    width: 1,
                                  ),
                                  image: inv.demoImagePath.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            inv.demoImagePath,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: inv.demoImagePath.isEmpty
                                    ? Icon(
                                        Icons.domain_rounded,
                                        color: AppColors.textSecondaryOf(
                                          context,
                                        ),
                                        size: 28,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inv.demoName,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColors.textPrimaryOf(context),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: -0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.invitedBy(
                                        inv.senderFirstName,
                                        inv.senderLastName,
                                      ),
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondaryOf(
                                          context,
                                        ),
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Material(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<InvitationCubit>()
                                            .rejectInvitation(inv.id);
                                      },
                                      borderRadius: BorderRadius.circular(14),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Material(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<InvitationCubit>()
                                            .acceptInvitation(inv.id);
                                      },
                                      borderRadius: BorderRadius.circular(14),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationsHeader extends StatelessWidget {
  final double topPadding;
  final String title;
  final String subtitle;

  const _InvitationsHeader({
    required this.topPadding,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding > 0 ? topPadding + 8 : 32,
          left: 20,
          right: 20,
          bottom: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 38,
                      height: 38,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.surface,
                      size: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.surface.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
