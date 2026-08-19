import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class UserInfoDialog extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String? imagePath;
  final String? role;
  final String? jobTitle;

  const UserInfoDialog({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.imagePath,
    this.role,
    this.jobTitle,
  });

  factory UserInfoDialog.fromDemoMember(MembersEntity member) {
    return UserInfoDialog(
      firstName: member.firstName,
      lastName: member.lastName,
      email: member.email,
      imagePath: member.imagePath,
      role: member.role,
    );
  }

  factory UserInfoDialog.fromDepartmentMember(DepartmentMemberEntity member) {
    return UserInfoDialog(
      firstName: member.firstName,
      lastName: member.lastName,
      email: member.email,
      imagePath: member.imagePath,
      jobTitle: member.jobTitle,
    );
  }

  static Future<void> showForDemoMember(
    BuildContext context,
    MembersEntity member,
  ) {
    return showDialog(
      context: context,
      builder: (context) => UserInfoDialog.fromDemoMember(member),
    );
  }

  static Future<void> showForDepartmentMember(
    BuildContext context,
    DepartmentMemberEntity member,
  ) {
    return showDialog(
      context: context,
      builder: (context) => UserInfoDialog.fromDepartmentMember(member),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final fullName = '$firstName $lastName'.trim();
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    final badge = (role != null && role!.isNotEmpty)
        ? role!
        : (jobTitle != null && jobTitle!.isNotEmpty ? jobTitle! : '');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colors.surface,
      elevation: 6,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Avatar
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.headerGradientOf(context),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.22),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 36,
                backgroundColor: colors.surface,
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: colors.primaryContainer,
                  backgroundImage: hasImage ? NetworkImage(imagePath!) : null,
                  child: !hasImage
                      ? Text(
                          firstName.isNotEmpty
                              ? firstName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: colors.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Full Name
            Text(
              fullName.isNotEmpty ? fullName : l10n.userNameHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            // Badge
            if (badge.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  badge.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            // Info List Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoTile(
                    icon: Icons.person_outline_rounded,
                    label: l10n.userNameHint,
                    value: fullName.isNotEmpty ? fullName : '-',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, thickness: 0.5),
                  ),
                  _InfoTile(
                    icon: Icons.email_outlined,
                    label: l10n.emailAddressLabel,
                    value: email.isNotEmpty ? email : '-',
                  ),
                  if (jobTitle != null && jobTitle!.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
                    _InfoTile(
                      icon: Icons.work_outline_rounded,
                      label: l10n.jobTitle,
                      value: jobTitle!,
                    ),
                  ],
                  if (role != null && role!.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
                    _InfoTile(
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Role',
                      value: role!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Close / OK button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradientOf(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOf(context).withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      l10n.ok,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: colors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
