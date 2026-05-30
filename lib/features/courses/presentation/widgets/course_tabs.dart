import 'package:flutter/material.dart';
import 'package:project1/features/courses/presentation/widgets/lesson_connector.dart';

class CourseTabs extends StatelessWidget {
  const CourseTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [Tab(text: "Lessons"), Tab(text: "FAQ")],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    ExpansionTile(
                      title: const Text("Phase 1: Foundations", style: TextStyle(fontWeight: FontWeight.bold)),
                      shape: Border.all(color: Colors.transparent),
                      initiallyExpanded: true,
                      children: List.generate(3, (i) => LessonConnector(
                        isLast: i == 2, 
                        child: LessonTile(num: i + 1)
                      )),
                    ),
                    ExpansionTile(
                      title: const Text("Phase 2: Advanced Data", style: TextStyle(fontWeight: FontWeight.bold)),
                      shape: Border.all(color: Colors.transparent),
                      children: List.generate(2, (i) => LessonConnector(
                        isLast: i == 1, 
                        child: LessonTile(num: i + 4)
                      )),
                    ),
                  ],
                ),
                const Center(child: Text("FAQ Content")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LessonTile extends StatelessWidget {
  final int num;
  const LessonTile({super.key, required this.num});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text("$num", style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 15),
          Text("Deep Sea Logic Lesson $num", style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}