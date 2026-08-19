import 'package:flutter/material.dart';
import 'package:project1/features/demo/presentation/widgets/demo member card/user_info_dialog.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'department_member_options_menu.dart';

class DepartmentMemberCard extends StatelessWidget {
  const DepartmentMemberCard({
    super.key,
    required this.member,
    required this.departmentId,
    required this.demoId,
    this.canManage = true,
    this.managerId,
    this.onTap,
  });

  final DepartmentMemberEntity member;
  final String departmentId;
  final String demoId;
  final bool canManage;
  final String? managerId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasImage = member.imagePath.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap ??
                () => UserInfoDialog.showForDepartmentMember(context, member),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                bottom: 16,
                right: 8,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.15),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: colors.primaryContainer,
                      backgroundImage:
                          hasImage ? NetworkImage(member.imagePath) : null,
                      child: hasImage
                          ? null
                          : Text(
                              member.firstName.isNotEmpty
                                  ? member.firstName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: colors.onPrimaryContainer,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${member.firstName} ${member.lastName}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          member.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (member.jobTitle.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        member.jobTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  const SizedBox(width: 4),
                  if (canManage)
                    DepartmentMemberOptionsMenu(
                      member: member,
                      departmentId: departmentId,
                      demoId: demoId,
                      managerId: managerId,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
