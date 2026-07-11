import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';

class ItemCardWidget extends StatelessWidget {

  final IconData icon;
  final bool isRestricted;
  final DepartmentEntity? departmentEntity;

  const ItemCardWidget({
    super.key,
    required this.icon,
    this.isRestricted = false,
    this.departmentEntity,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    final cardColor = isRestricted
        ? AppColors.headerGradient.withOpacity(0.5)
        :  AppColors.headerGradient;

    final textColor = isRestricted
        ? theme.colorScheme.onSurface.withOpacity(0.5)
        : theme.colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.04),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        gradient: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.surface, size: size.width * 0.08),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departmentEntity?.name ?? 'Unknown',
                  style: AppTextStyles.titleMedium.copyWith(color: textColor),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  departmentEntity?.description ?? 'No description available',
                  style: AppTextStyles.label.copyWith(
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.surface,
                size: size.width * 0.06,
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      departmentEntity?.memberCount.toString() ?? '0',
                      style: AppTextStyles.caption.copyWith(
                        color: theme.colorScheme.surface,
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Icon(
                      Icons.people,
                      color: theme.colorScheme.surface,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
