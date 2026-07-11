import 'package:flutter/material.dart';
import 'package:project1/features/course/presentation/widgets/course_tag.dart';
import '../widgets/lesson_tabs.dart';
import '../widgets/lesson_video_header.dart';

class LessonDetailsScreen extends StatelessWidget {
  const LessonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LessonVideoHeader(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Introduction to Deep Learning",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      CourseTag(
                        text: "45 min",
                      ),
                      CourseTag(
                        text: "Lesson 3",
                      ),
                      CourseTag(
                        text: "12.5K Views",
                      ),
                      CourseTag(
                        text: "Completed",
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Lesson Overview",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "This lesson introduces the fundamentals of deep learning, neural networks, training strategies, and real-world applications.",
                    style: TextStyle(
                      height: 1.6,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const SizedBox(
                    height: 500,
                    child: LessonTabs(),
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