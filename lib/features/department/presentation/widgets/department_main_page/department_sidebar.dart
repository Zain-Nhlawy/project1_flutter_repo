import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'department_nav_item.dart';

class DepartmentSidebar extends StatelessWidget {
  final double width;
  final bool isVisible;
  final int currentIndex;
  final List<DepartmentNavItem> navItems;
  final String departmentName;
  final String departmentDescription;
  final String navigationLabel;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onToggle;

  const DepartmentSidebar({
    super.key,
    required this.width,
    required this.isVisible,
    required this.currentIndex,
    required this.navItems,
    required this.departmentName,
    required this.departmentDescription,
    required this.navigationLabel,
    required this.onPageChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      hidden: !isVisible,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(
            left: isRtl ? BorderSide(color: borderColor) : BorderSide.none,
            right: isRtl ? BorderSide.none : BorderSide(color: borderColor),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: Offset(isRtl ? -8 : 8, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.headerGradientOf(context),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOf(
                          context,
                        ).withValues(alpha: 0.24),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                            ),
                            child: const Icon(
                              Icons.account_tree_outlined,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                          const Spacer(),
                          Material(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: onToggle,
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Text(
                        departmentName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (departmentDescription.trim().isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Text(
                          departmentDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.76),
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(17, 0, 17, 9),
                child: Text(
                  navigationLabel.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 18),
                  physics: const BouncingScrollPhysics(),
                  itemCount: navItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 7),
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
    );
  }
}
