import 'package:flutter/material.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_card.dart';
import 'package:project1/features/home/presentation/widgets/main_header.dart';
import '../widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardHeader(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: "My Demos"),
                  SizedBox(height: size.height * 0.015),
                  const DemoCard(
                    title: "Customer Service Training",
                    description:
                        "Complete onboarding flow for new customer service reps",
                    author: "Alex Johnson",
                    buttonText: "Manage",
                    usersCount: 12,
                  ),
                  const DemoCard(
                    title: "Product Knowledge Base",
                    description: "Comprehensive guide to all our products",
                    author: "Alex Johnson",
                    buttonText: "Manage",
                    usersCount: 24,
                  ),
                  SizedBox(height: size.height * 0.02),
                  const SectionHeader(title: "Demos I'm In"),
                  SizedBox(height: size.height * 0.015),
                  const DemoCard(
                    title: "Leadership Essentials",
                    description:
                        "Advanced leadership and management strategies",
                    author: "Sarah Mitchell",
                    buttonText: "Continue",
                  ),
                  const DemoCard(
                    title: "Data Analytics Fundamentals",
                    description:
                        "Introduction to data analysis tools and methodologies",
                    author: "James Chen",
                    buttonText: "Continue",
                  ),
                  SizedBox(height: size.height * 0.12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
