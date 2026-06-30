import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';


class ToggleSwitchWidget extends StatelessWidget {
  final bool isSectionsActive;
  final Function(bool) onToggle;

  const ToggleSwitchWidget({
    super.key,
    required this.isSectionsActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: size.width * 0.7,
      height: size.height * 0.05,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSectionsActive ? theme.colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  l10n.sections,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isSectionsActive ? theme.colorScheme.primary : theme.colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isSectionsActive ? theme.colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  l10n.groups,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: !isSectionsActive ? theme.colorScheme.primary : theme.colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}