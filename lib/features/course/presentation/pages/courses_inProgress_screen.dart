import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/pages/course_management_screen.dart';
import 'package:project1/features/course/presentation/pages/create_course_screen.dart';
import 'package:project1/features/course/presentation/widgets/course_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursesInProgressScreen extends StatelessWidget {
  const CoursesInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = Localizations.of(context, AppLocalizations)!;

    final courses = [
      {
        "title": "Flutter Basics",
        "company": "Google",
        "description":
            "Learn the fundamentals of Flutter development and Dart programming language effectively.",
        "image": "assets/images/test1.jpg",
        "lessons": 12,
        "duration": "3h 20m",
        "price": "\$49.99",
        "tags": ["Mobile", "Beginner", "Dart"],
      },
      {
        "title": "Advanced JS",
        "company": "Meta",
        "description":
            "Master advanced JavaScript concepts including closures, prototypes, and async programming.",
        "image": "assets/images/test1.jpg",
        "lessons": 18,
        "duration": "5h 10m",
        "price": "\$59.99",
        "tags": ["Web", "Advanced", "JavaScript"],
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.ongoingCourses,
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCourseScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          "Create Course",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffF7F9FC),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
          children: [
            Text(
              localizations.ongoingCourses,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.3,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              localizations.manageCoursesDescription,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book_rounded,
                      color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    "${courses.length} ${localizations.coursesInProgress}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ...courses.map((c) {
              return CourseCard(
                title: c["title"] as String,
                companyName: c["company"] as String,
                imageUrl: c["image"] as String,
                price: c["price"] as String,
                description: c["description"] as String,
                tags: List<String>.from(c["tags"] as List),
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
            }),
          ],
        ),
      ),
    );
  }
}