import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;

  const Avatar({required this.name, required this.avatarUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryOf(context).withOpacity(.12),
      backgroundImage: hasImage ? NetworkImage(avatarUrl!) : null,
      child: hasImage
          ? null
          : Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.primaryOf(context),
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}