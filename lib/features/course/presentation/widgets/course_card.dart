import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String imageUrl;
  final int totalLessons;
  final String duration;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.companyName,
    required this.imageUrl,
    required this.totalLessons,
    required this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [

            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.asset(
                imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.menu_book, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text("$totalLessons lessons",
                            style: const TextStyle(fontSize: 12)),

                        const SizedBox(width: 12),

                        const Icon(Icons.timer, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(duration,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}