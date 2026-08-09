import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class VisibilityDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String publicLabel;
  final String privateLabel;
  final bool enabled;

  const VisibilityDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.publicLabel,
    required this.privateLabel,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    final surface = AppColors.surfaceOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: enabled ? surface : surface.withValues(alpha: 0.5),
        border: Border.all(color: AppColors.borderOf(context), width: 1.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled ? primary : AppColors.textSecondaryOf(context),
          ),
          items: [
            DropdownMenuItem(
              value: 'PUBLIC',
              child: Row(
                children: [
                  Icon(
                    Icons.public,
                    size: 18,
                    color: enabled
                        ? primary
                        : AppColors.textSecondaryOf(context),
                  ),
                  const SizedBox(width: 8),
                  Text(publicLabel),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'PRIVATE',
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: enabled
                        ? primary
                        : AppColors.textSecondaryOf(context),
                  ),
                  const SizedBox(width: 8),
                  Text(privateLabel),
                ],
              ),
            ),
          ],
          onChanged: enabled
              ? (v) {
                  if (v != null) {
                    onChanged(v);
                  }
                }
              : null,
        ),
      ),
    );
  }
}
