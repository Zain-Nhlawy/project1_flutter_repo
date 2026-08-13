import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;

  const Avatar({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    final primary = AppColors.primaryOf(context);

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceOf(context),
        border: Border.all(color: primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.09),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: primary.withValues(alpha: 0.11),
        backgroundImage: hasImage ? NetworkImage(avatarUrl!) : null,
        child: hasImage
            ? null
            : Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontFamily: AppTextStyles.fontFamily,
                  color: primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
