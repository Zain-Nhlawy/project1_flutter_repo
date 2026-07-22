import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class DepartmentNavItem {
  final IconData icon;
  final String label;

  DepartmentNavItem(this.icon, this.label);
}

class SidebarItemWidget extends StatelessWidget {
  final DepartmentNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textSecondary = AppColors.textSecondaryOf(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? theme.tertiary : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              item.icon,
              color: isSelected ? Colors.white : textSecondary.withOpacity(0.5),
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? theme.onTertiary
                    : textSecondary.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
