import 'package:flutter/material.dart';
import 'package:project1/features/Q&A/presentation/widgets/qa_card.dart';
import 'package:project1/features/attachment/presentation/widgets/attachment_tile.dart';

class LessonTabs extends StatelessWidget {
  const LessonTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TabBar(
              tabs: [
                Tab(text: "Q&A"),
                Tab(text: "Attachments"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: TabBarView(
              children: [
                _QuestionsTab(),
                _AttachmentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionsTab extends StatelessWidget {
  const _QuestionsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        QaCard(
          userName: "Mohammed",
          question:
              "Can you explain the difference between CNN and RNN?",
          replies: [
            "CNN is mainly used for image processing.",
            "RNN is designed for sequential data.",
            "Nowadays transformers are often preferred.",
            "Both are still important concepts to learn.",
          ],
        ),
        QaCard(
          userName: "Sarah",
          question:
              "Will we use TensorFlow later in the course?",
          replies: [
            "Yes, TensorFlow will be introduced in the next section.",
            "You will also see some PyTorch examples.",
          ],
        ),
        QaCard(
          userName: "Ali",
          question:
              "Can I use PyTorch instead of TensorFlow?",
          replies: [
            "Absolutely.",
            "The concepts are framework independent.",
            "Most assignments can be solved using either.",
            "PyTorch is actually very popular nowadays.",
            "Just make sure your output matches the requirements.",
          ],
        ),
      ],
    );
  }
}

class _AttachmentsTab extends StatelessWidget {
  const _AttachmentsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        AttachmentTile(
          title: "Lecture Slides",
          type: "PPTX",
          size: "4.2 MB",
        ),
        AttachmentTile(
          title: "Course Notes",
          type: "PDF",
          size: "1.8 MB",
        ),
        AttachmentTile(
          title: "Source Code",
          type: "ZIP",
          size: "8.4 MB",
        ),
        AttachmentTile(
          title: "Assignment",
          type: "DOCX",
          size: "560 KB",
        ),
      ],
    );
  }
}