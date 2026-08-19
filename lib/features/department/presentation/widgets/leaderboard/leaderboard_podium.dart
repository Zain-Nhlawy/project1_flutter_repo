import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/department/domain/entities/leaderboard_member_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class LeaderboardPodium extends StatelessWidget {
  final List<LeaderboardMemberEntity> topMembers;
  final void Function(LeaderboardMemberEntity member)? onMemberTap;

  const LeaderboardPodium({
    super.key,
    required this.topMembers,
    this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    if (topMembers.isEmpty) return const SizedBox.shrink();

    final rank1 = topMembers.isNotEmpty ? topMembers[0] : null;
    final rank2 = topMembers.length > 1 ? topMembers[1] : null;
    final rank3 = topMembers.length > 2 ? topMembers[2] : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Rank 2 (Left)
              if (rank2 != null)
                Expanded(
                  child: _PodiumColumn(
                    member: rank2,
                    rank: 2,
                    pedestalHeight: 90,
                    avatarRadius: 28,
                    podiumColor: const Color(0xFF9E9E9E),
                    accentColor: const Color(0xFFC0C0C0),
                    onTap: () => onMemberTap?.call(rank2),
                  ),
                )
              else
                const Expanded(child: SizedBox()),

              const SizedBox(width: 8),

              // Rank 1 (Center - Highest)
              if (rank1 != null)
                Expanded(
                  child: _PodiumColumn(
                    member: rank1,
                    rank: 1,
                    pedestalHeight: 120,
                    avatarRadius: 36,
                    podiumColor: const Color(0xFFFFB300),
                    accentColor: const Color(0xFFFFD54F),
                    isFirst: true,
                    onTap: () => onMemberTap?.call(rank1),
                  ),
                ),

              const SizedBox(width: 8),

              // Rank 3 (Right)
              if (rank3 != null)
                Expanded(
                  child: _PodiumColumn(
                    member: rank3,
                    rank: 3,
                    pedestalHeight: 70,
                    avatarRadius: 26,
                    podiumColor: const Color(0xFFCD7F32),
                    accentColor: const Color(0xFFD78C4E),
                    onTap: () => onMemberTap?.call(rank3),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  final LeaderboardMemberEntity member;
  final int rank;
  final double pedestalHeight;
  final double avatarRadius;
  final Color podiumColor;
  final Color accentColor;
  final bool isFirst;
  final VoidCallback? onTap;

  const _PodiumColumn({
    required this.member,
    required this.rank,
    required this.pedestalHeight,
    required this.avatarRadius,
    required this.podiumColor,
    required this.accentColor,
    this.isFirst = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasImage = member.imagePath != null && member.imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar with Rank Badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accentColor, podiumColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: podiumColor.withValues(alpha: 0.35),
                      blurRadius: isFirst ? 14 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColors.surfaceOf(context),
                  backgroundImage:
                      hasImage ? NetworkImage(member.imagePath!) : null,
                  child: hasImage
                      ? null
                      : Text(
                          member.firstName.isNotEmpty
                              ? member.firstName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: avatarRadius * 0.8,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOf(context),
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: podiumColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Name
          Text(
            member.fullName,
            style: TextStyle(
              fontSize: isFirst ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryOf(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 2),

          // Job Title
          if (member.jobTitle.isNotEmpty)
            Text(
              member.jobTitle,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryOf(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 4),

          // Score Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: podiumColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: podiumColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.stars_rounded,
                  size: 13,
                  color: podiumColor,
                ),
                const SizedBox(width: 3),
                Text(
                  '${member.totalScore} ${l10n.points}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: podiumColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Pedestal Block
          Container(
            height: pedestalHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  podiumColor.withValues(alpha: 0.25),
                  podiumColor.withValues(alpha: 0.08),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(
                color: podiumColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: isFirst ? 36 : 28,
                  fontWeight: FontWeight.w900,
                  color: podiumColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
