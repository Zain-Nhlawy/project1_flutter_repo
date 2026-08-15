import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class DepartmentEmptyPage extends StatelessWidget {
  final String title;

  const DepartmentEmptyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          color: AppColors.textSecondaryOf(context).withValues(alpha: 0.3),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
