import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/pages/course_management_screen.dart';
import 'package:project1/features/course/presentation/widgets/course_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursesInProgressScreen extends StatelessWidget {
  const CoursesInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = Localizations.of(context, AppLocalizations)!;

    /// dummy data 
    final courses = [
      {
        "title": "Flutter Basics",
        "company": "Google",
        "image": "assets/images/test1.jpg",
        "lessons": 12,
        "duration": "3h 20m",
      },
      {
        "title": "Advanced JS",
        "company": "Meta",
        "image": "assets/images/test1.jpg",
        "lessons": 18,
        "duration": "5h 10m",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
      title: Text(
        localizations.myOngoingCourses,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
      ),
    ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final c = courses[index];

          return CourseCard(
            title: c["title"] as String,
            companyName: c["company"] as String,
            imageUrl: c["image"] as String,
            totalLessons: c["lessons"] as int,
            duration: c["duration"] as String,
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseManagementScreen(
                  title: c["title"] as String,
                  company: c["company"] as String,
                  image: c["image"] as String,
                  lessons: c["lessons"] as int,
                  duration: c["duration"] as String,
                ),
              ),
            );
          },
          );
        },
      ),
    );
  }
}