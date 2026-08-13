import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class OnlineMembersHeader extends StatelessWidget {
  final List<DepartmentMemberEntity> members;

  const OnlineMembersHeader({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Material(
      color: AppColors.surfaceOf(context),
      shape: StadiumBorder(
        side: BorderSide(color: AppColors.borderOf(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: members.isEmpty ? null : () => _showOnlineMembers(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: members.isEmpty
                      ? AppColors.textSecondaryOf(context)
                      : AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                localizations?.chatOnlineCount(members.length) ??
                    '${members.length} online',
                style: TextStyle(
                  color: AppColors.textPrimaryOf(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (members.isNotEmpty) ...[
                const SizedBox(width: 10),
                _buildAvatarStack(context),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textSecondaryOf(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context) {
    final displayedCount = members.length > 4 ? 3 : members.length;
    final extraCount = members.length - displayedCount;
    final circleCount = displayedCount + (extraCount > 0 ? 1 : 0);
    final width = 32.0 + math.max(0, circleCount - 1) * 21;

    return SizedBox(
      width: width,
      height: 32,
      child: Stack(
        children: [
          for (var index = 0; index < displayedCount; index++)
            Positioned(
              left: index * 21,
              child: Tooltip(
                message: _fullName(members[index]),
                child: _MemberAvatar(member: members[index], size: 32),
              ),
            ),
          if (extraCount > 0)
            Positioned(
              left: displayedCount * 21,
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.backgroundOf(context),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surfaceOf(context),
                    width: 2,
                  ),
                ),
                child: Text(
                  '+$extraCount',
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showOnlineMembers(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceOf(context),
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.65,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text(
                    localizations?.chatOnlineMembersTitle ?? 'Online members',
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(sheetContext),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    itemCount: members.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: AppColors.borderOf(sheetContext),
                    ),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return ListTile(
                        leading: _MemberAvatar(member: member, size: 42),
                        title: Text(
                          _fullName(member),
                          style: TextStyle(
                            color: AppColors.textPrimaryOf(sheetContext),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: member.jobTitle.trim().isEmpty
                            ? null
                            : Text(
                                member.jobTitle,
                                style: TextStyle(
                                  color: AppColors.textSecondaryOf(
                                    sheetContext,
                                  ),
                                ),
                              ),
                        trailing: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _fullName(DepartmentMemberEntity member) {
    final name = '${member.firstName} ${member.lastName}'.trim();
    return name.isEmpty ? member.email : name;
  }
}

class _MemberAvatar extends StatelessWidget {
  final DepartmentMemberEntity member;
  final double size;

  const _MemberAvatar({required this.member, required this.size});

  @override
  Widget build(BuildContext context) {
    final imagePath = member.imagePath.trim();

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.success, width: 1.5),
      ),
      child: ClipOval(
        child: imagePath.isEmpty
            ? Container(
                alignment: Alignment.center,
                color: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  _initials(member),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            : Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  alignment: Alignment.center,
                  color: AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    _initials(member),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  String _initials(DepartmentMemberEntity member) {
    final first = member.firstName.trim();
    final last = member.lastName.trim();
    final initials =
        '${first.isEmpty ? '' : first[0]}'
        '${last.isEmpty ? '' : last[0]}';
    return initials.isEmpty ? '?' : initials.toUpperCase();
  }
}
