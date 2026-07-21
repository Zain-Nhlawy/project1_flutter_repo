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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isVisible ? 85 : 0,
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        boxShadow: [
          if (isVisible)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
        ],
      ),
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          maxWidth: 85,
          minWidth: 85,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Material(
                  color: AppColors.textSecondaryOf(context).withOpacity(0.08),
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
        ),
      ),
    );
  }
}
