import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : AppColors.primaryOf(context).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 280),
                curve: Curves.fastOutSlowIn,
                alignment: isSectionsActive
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.headerGradientOf(context),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOf(
                            context,
                          ).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onToggle(true),
                      borderRadius: BorderRadius.circular(24),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.grid_view_rounded,
                                size: 18,
                                color: isSectionsActive
                                    ? Colors.white
                                    : AppColors.textSecondaryOf(context),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: AppTextStyles.label.copyWith(
                                      fontFamily:
                                          theme.textTheme.bodyMedium?.fontFamily ??
                                          AppTextStyles.fontFamily,
                                      color: isSectionsActive
                                          ? Colors.white
                                          : AppColors.textSecondaryOf(context),
                                      fontWeight: isSectionsActive
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                    child: Text(l10n.department),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => onToggle(false),
                      borderRadius: BorderRadius.circular(24),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.groups_rounded,
                                size: 18,
                                color: !isSectionsActive
                                    ? Colors.white
                                    : AppColors.textSecondaryOf(context),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: AppTextStyles.label.copyWith(
                                      fontFamily:
                                          theme.textTheme.bodyMedium?.fontFamily ??
                                          AppTextStyles.fontFamily,
                                      color: !isSectionsActive
                                          ? Colors.white
                                          : AppColors.textSecondaryOf(context),
                                      fontWeight: !isSectionsActive
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                    child: Text(l10n.groups),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
