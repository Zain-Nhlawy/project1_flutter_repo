import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;
  final VoidCallback onImageTap;

  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: size.width * 0.22,
                height: size.width * 0.22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.headerGradient,
                ),
                child: ClipOval(
                  child: imagePath.isNotEmpty
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallback(name),
                        )
                      : _fallback(name),
                ),
              ),

              GestureDetector(
                onTap: onImageTap,
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.015),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 3),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.surface,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),

          Text(
            name,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: size.height * 0.005),

          Text(
            email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '',
        style: const TextStyle(
          fontSize: 28,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}