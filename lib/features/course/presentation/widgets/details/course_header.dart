import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_theme.dart';

class CourseHeader extends StatelessWidget {
  final String imageUrl;
  final String totalDuration;
  final int totalLessons;

  const CourseHeader({
    super.key,
    required this.imageUrl,
    required this.totalDuration,
    required this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                boxShadow: const [AppTheme.primaryShadow],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoItem(Icons.access_time, totalDuration, "Total Content", context),
                  _infoItem(Icons.play_circle_outline, '$totalLessons', "Lessons", context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String val, String label, BuildContext context) => Column(
        children: [
          Row(children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 28),
            const SizedBox(width: 8),
            Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColor))
          ]),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      );
}