import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class VisibilityDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String publicLabel;
  final String privateLabel;

  const VisibilityDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.publicLabel,
    required this.privateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1.2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
          items: [
            DropdownMenuItem(
              value: 'public',
              child: Row(
                children: [
                  const Icon(Icons.public, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(publicLabel),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'private',
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(privateLabel),
                ],
              ),
            ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}