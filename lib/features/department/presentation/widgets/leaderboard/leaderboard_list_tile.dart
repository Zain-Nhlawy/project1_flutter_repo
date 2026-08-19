import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/department/domain/entities/leaderboard_member_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class LeaderboardListTile extends StatelessWidget {
  final LeaderboardMemberEntity member;
  final VoidCallback? onTap;

  const LeaderboardListTile({
    super.key,
    required this.member,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasImage = member.imagePath != null && member.imagePath!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Rank Number Badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOf(context).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${member.rank}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOf(context),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      AppColors.primaryOf(context).withValues(alpha: 0.15),
                  backgroundImage:
                      hasImage ? NetworkImage(member.imagePath!) : null,
                  child: hasImage
                      ? null
                      : Text(
                          member.firstName.isNotEmpty
                              ? member.firstName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOf(context),
                          ),
                        ),
                ),

                const SizedBox(width: 14),

                // Name & Job Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.fullName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryOf(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (member.jobTitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          member.jobTitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryOf(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Score Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOf(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          AppColors.primaryOf(context).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        size: 14,
                        color: AppColors.primaryOf(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${member.totalScore} ${l10n.points}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryOf(context),
                        ),
                      ),
                    ],
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
