import 'package:flutter/material.dart';
import 'package:project1/l10n/app_localizations.dart';

class UserOptionsMenu extends StatelessWidget {
  const UserOptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert_rounded, color: colors.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colors.surfaceContainer,
      elevation: 3,
      onSelected: (value) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: colors.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.viewPersonalInfo,
                style: TextStyle(color: colors.onSurface),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                size: 20,
                color: colors.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.changePermissions,
                style: TextStyle(color: colors.onSurface),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.person_remove_rounded, size: 20, color: colors.error),
              const SizedBox(width: 12),
              Text(
                l10n.removeFromRoom,
                style: TextStyle(
                  color: colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
