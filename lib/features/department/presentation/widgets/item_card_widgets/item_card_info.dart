import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class ItemCardInfo extends StatelessWidget {
  final String name;
  final String description;

  const ItemCardInfo({
    super.key,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description.isEmpty ? 'No description available' : description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.2,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
