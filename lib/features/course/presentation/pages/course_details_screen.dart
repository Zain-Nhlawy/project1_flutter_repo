import 'package:flutter/material.dart';
import 'package:project1/features/course/presentation/widgets/course_header.dart';
import 'package:project1/features/course/presentation/widgets/course_tabs.dart';
import 'package:project1/features/course/presentation/widgets/course_tag.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CourseHeader(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mastering Deep Sea Data Structures",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      CourseTag(
                        text: "Intermediate",
                        icon: Icons.trending_up,
                      ),
                      CourseTag(
                        text: "Machine Learning",
                        icon: Icons.psychology,
                      ),
                      CourseTag(
                        text: "Programming",
                        icon: Icons.code,
                      ),
                      CourseTag(
                        text: "Data Structures",
                        icon: Icons.account_tree,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.business,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Produced by",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Oceanic Tech Academy",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "About this course",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Dive deep into the core of oceanic data processing. This course provides a comprehensive roadmap...",
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.6,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Course Content",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(
                    height: 400,
                    child: CourseTabs(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

