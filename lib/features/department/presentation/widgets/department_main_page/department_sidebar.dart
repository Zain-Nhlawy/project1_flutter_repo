import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'department_nav_item.dart';

class DepartmentSidebar extends StatelessWidget {
  final bool isVisible;
  final int currentIndex;
  final List<DepartmentNavItem> navItems;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onToggle;

  const DepartmentSidebar({
    super.key,
    required this.isVisible,
    required this.currentIndex,
    required this.navItems,
    required this.onPageChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);

    return Container(
      width: 85,
      decoration: BoxDecoration(
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Material(
              color: AppColors.textSecondaryOf(context).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.menu_open_rounded,
                    color: AppColors.textPrimaryOf(context),
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: navItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  return SidebarItemWidget(
                    item: navItems[index],
                    isSelected: index == currentIndex,
                    onTap: () => onPageChanged(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
