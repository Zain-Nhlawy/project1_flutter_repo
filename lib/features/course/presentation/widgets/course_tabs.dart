import 'package:flutter/material.dart';
import 'package:project1/features/course/presentation/widgets/lesson_connector.dart';
import 'lesson_tile.dart';

class CourseTabs extends StatelessWidget {
  const CourseTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: "Lessons"),
              Tab(text: "FAQ"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      Column(
                        children: [
                          ExpansionTile(
                            title: const Text(
                              "Phase 1: Foundations",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: List.generate(
                              3,
                              (i) => LessonConnector(
                                num: i + 1,
                                isLast: i == 2,
                                showTopLine: false,
                                child: LessonTile(num: i + 1),
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ExpansionTile(
                            title: const Text(
                              "Phase 2: Foundations",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: List.generate(
                              3,
                              (i) => LessonConnector(
                                num: i + 1,
                                isLast: i == 2,
                                showTopLine: false,
                                child: LessonTile(num: i + 1),
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _FaqItem(
                      question: "Who is this course designed for?",
                      answer:
                          "This course is designed for students, developers, and anyone interested in mastering data structures and algorithmic thinking.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "Do I need prior programming experience?",
                      answer:
                          "Basic programming knowledge is recommended, but the course starts from the fundamentals and gradually moves to advanced topics.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "Will I receive a certificate?",
                      answer:
                          "Yes, you will receive a certificate of completion after successfully finishing the course requirements.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "Can I access the course on mobile?",
                      answer:
                          "Absolutely. The course is optimized for desktop, tablet, and mobile devices.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "How long do I have access to the course?",
                      answer:
                          "You will have lifetime access to all lessons, updates, and supporting materials.",
                      primary: primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final Color primary;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 4,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          iconColor: primary,
          collapsedIconColor: primary,
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primary,
              fontSize: 15,
            ),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}