import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class CourseImagePicker extends StatelessWidget {
  final File? selectedImage;
  final String? initialImageUrl; 
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final String uploadLabel;
  final bool enabled;

  const CourseImagePicker({
    super.key,
    required this.selectedImage,
    this.initialImageUrl,
    required this.onTap,
    required this.onRemove,
    required this.uploadLabel,
    this.enabled = true,
  });

  DecorationImage? _resolveImage() {
    if (selectedImage != null) {
      return DecorationImage(image: FileImage(selectedImage!), fit: BoxFit.cover);
    }
    if (initialImageUrl != null && initialImageUrl!.isNotEmpty) {
      final isNetwork = initialImageUrl!.startsWith('http');
      return DecorationImage(
        image: isNetwork ? NetworkImage(initialImageUrl!) : AssetImage(initialImageUrl!) as ImageProvider,
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final image = _resolveImage();
    final hasImage = image != null;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enabled ? onTap : null,
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: !hasImage
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.08),
                    AppColors.primary.withOpacity(0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          image: image,
          border: Border.all(
            color: AppColors.primary.withOpacity(enabled ? 0.4 : 0.15),
            width: 1.4,
          ),
        ),
        child: !hasImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 34,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    uploadLabel,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG / JPG',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : (enabled
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 18),
                          onPressed: onRemove,
                        ),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_outlined, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                  )),
      ),
    );
  }
}