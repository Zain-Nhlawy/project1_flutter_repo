import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/q&a/presentation/widgets/qa_card.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/attachment/presentation/widgets/details/attachments_tab.dart';

class LessonTabs extends StatefulWidget {
  final String lessonId;

  const LessonTabs({super.key, required this.lessonId});

  @override
  State<LessonTabs> createState() => _LessonTabsState();
}

class _LessonTabsState extends State<LessonTabs> {
  List<LessonAttachmentEntity> _attachments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAttachments();
  }

  Future<void> _loadAttachments() async {
    final result = await context.read<LessonAttachmentCubit>().getAttachments(
      lessonId: widget.lessonId,
    );

    if (!mounted) return;
    setState(() {
      _attachments = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Q&A"),
              Tab(text: "Attachments"),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              children: [
                const _QuestionsTab(),
                AttachmentsTab(attachments: _attachments, loading: _loading),
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
          question: "Can you explain the difference between CNN and RNN?",
          replies: [
            "CNN is mainly used for image processing.",
            "RNN is designed for sequential data.",
            "Nowadays transformers are often preferred.",
            "Both are still important concepts to learn.",
          ],
        ),
        QaCard(
          userName: "Sarah",
          question: "Will we use TensorFlow later in the course?",
          replies: [
            "Yes, TensorFlow will be introduced in the next section.",
            "You will also see some PyTorch examples.",
          ],
        ),
        QaCard(
          userName: "Ali",
          question: "Can I use PyTorch instead of TensorFlow?",
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