import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_theme.dart';

class CourseHeader extends StatelessWidget {
  const CourseHeader({super.key});

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
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/test1.jpg'), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                boxShadow: const [AppTheme.primaryShadow,],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoItem(Icons.access_time, "12h 45m", "Total Content", context),
                  _infoItem(Icons.play_circle_outline, "24", "Videos", context),
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