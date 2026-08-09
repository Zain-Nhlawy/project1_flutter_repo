import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/attachment/presentation/widgets/details/attachments_tab.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/presentation/cubit/discussion_cubit.dart';
import 'package:project1/features/q&a/presentation/widgets/discussion_composer.dart';
import 'package:project1/features/q&a/presentation/widgets/qa_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonTabs extends StatefulWidget {
  final String lessonId;

  const LessonTabs({super.key, required this.lessonId});

  @override
  State<LessonTabs> createState() => _LessonTabsState();
}

class _LessonTabsState extends State<LessonTabs> {
  List<LessonAttachmentEntity> _attachments = [];
  bool _loadingAttachments = true;

  List<DiscussionQuestionModel> _questions = [];
  bool _loadingQuestions = true;

  @override
  void initState() {
    super.initState();
    _loadAttachments();
    _loadQuestions();
  }

  Future<void> _loadAttachments() async {
    final result = await context.read<LessonAttachmentCubit>().getAttachments(
      lessonId: widget.lessonId,
    );

    if (!mounted) return;
    setState(() {
      _attachments = result;
      _loadingAttachments = false;
    });
  }

  Future<void> _loadQuestions() async {
    final result = await context.read<DiscussionCubit>().getQuestions(
      lessonId: widget.lessonId,
    );

    if (!mounted) return;
    setState(() {
      _questions = result;
      _loadingQuestions = false;
    });
  }

  Future<void> _postQuestion(String content) async {
    await context.read<DiscussionCubit>().postQuestion(
      lessonId: widget.lessonId,
      content: content,
    );
    await _loadQuestions();
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
                _QuestionsTab(
                  lessonId: widget.lessonId,
                  questions: _questions,
                  loading: _loadingQuestions,
                  onPostQuestion: _postQuestion,
                ),
                AttachmentsTab(attachments: _attachments, loading: _loadingAttachments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionsTab extends StatelessWidget {
  final String lessonId;
  final List<DiscussionQuestionModel> questions;
  final bool loading;
  final ValueChanged<String> onPostQuestion;

  const _QuestionsTab({
    required this.lessonId,
    required this.questions,
    required this.loading,
    required this.onPostQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: questions.isEmpty
              ? Center(
                  child: Text(
                    localizations.noQuestionsYet,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontFamily: AppTextStyles.fontFamily,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];

                    return QaCard(
                      questionId: question.id,
                      userName: question.authorName,
                      avatarUrl: question.authorAvatarUrl,
                      question: question.content,
                      createdAt: question.createdAt,
                    );
                  },
                ),
        ),
        DiscussionComposer(
          hintText: localizations.askAQuestion,
          isPosting: false,
          onSubmit: onPostQuestion,
        ),
      ],
    );
  }
}