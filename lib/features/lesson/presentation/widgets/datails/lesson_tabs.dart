import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/cubit/lesson_attachment_cubit.dart';
import 'package:project1/features/attachment/presentation/widgets/details/attachments_tab.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';
import 'package:project1/features/q&a/presentation/cubit/discussion_cubit.dart';
import 'package:project1/features/q&a/presentation/widgets/discussion_composer.dart';
import 'package:project1/features/q&a/presentation/widgets/qa_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonTabs extends StatefulWidget {
  final String lessonId;
  final String demoId;

  const LessonTabs({
    super.key,
    required this.lessonId,
    required this.demoId,
  });

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttachments();
      _loadQuestions();
    });
  }

  Future<void> _loadAttachments() async {
    final result =
        await context.read<LessonAttachmentCubit>().getAttachments(
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
          demoId: widget.demoId,
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
          demoId: widget.demoId,
        );

    await _loadQuestions();
  }

  void _onQuestionDeleted(String questionId) {
    setState(() {
      _questions.removeWhere((q) => q.id == questionId);
    });
  }

  void _onQuestionUpdated(String questionId, String newContent) {
    setState(() {
      final i = _questions.indexWhere((q) => q.id == questionId);
      if (i != -1) {
        _questions[i] = _questions[i].copyWith(content: newContent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.backgroundOf(context),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.borderOf(context).withValues(alpha: 0.70),
              ),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: AppColors.buttonGradientOf(context),
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondaryOf(context),
              labelStyle: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelStyle: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  height: 42,
                  icon: const Icon(
                    Icons.forum_outlined,
                    size: 18,
                  ),
                  text: localizations.questionsCount,
                  iconMargin: const EdgeInsets.only(bottom: 2),
                ),
                Tab(
                  height: 42,
                  icon: const Icon(
                    Icons.attach_file_rounded,
                    size: 18,
                  ),
                  text: localizations.lessonAttachments,
                  iconMargin: const EdgeInsets.only(bottom: 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              children: [
                _QuestionsTab(
                  lessonId: widget.lessonId,
                  demoId: widget.demoId,
                  questions: _questions,
                  loading: _loadingQuestions,
                  onPostQuestion: _postQuestion,
                  onQuestionDeleted: _onQuestionDeleted,
                  onQuestionUpdated: _onQuestionUpdated,
                ),
                _LessonAttachmentsTab(
                  attachments: _attachments,
                  loading: _loadingAttachments,
                ),
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
  final String demoId;
  final List<DiscussionQuestionModel> questions;
  final bool loading;
  final ValueChanged<String> onPostQuestion;
  final ValueChanged<String> onQuestionDeleted;
  final void Function(String questionId, String newContent) onQuestionUpdated;

  const _QuestionsTab({
    required this.lessonId,
    required this.demoId,
    required this.questions,
    required this.loading,
    required this.onPostQuestion,
    required this.onQuestionDeleted,
    required this.onQuestionUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (loading) {
      return const _LessonTabStatus(
        isLoading: true,
      );
    }

    return Column(
      children: [
        Expanded(
          child: questions.isEmpty
              ? _LessonTabStatus(
                  icon: Icons.chat_bubble_outline_rounded,
                  message: localizations.noQuestionsYet,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    8,
                    10,
                    12,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];

                    return BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                        final currentUserId = userState is UserLoaded
                            ? userState.user.id
                            : null;

                        return QaCard(
                          key: ValueKey(question.id),
                          questionId: question.id,
                          demoId: demoId,
                          lessonId: lessonId,
                          userName: question.authorName,
                          avatarUrl: question.authorAvatarUrl,
                          question: question.content,
                          createdAt: question.createdAt,
                          isOwner: currentUserId != null &&
                              question.authorId == currentUserId,
                          currentUserId: currentUserId,
                          onSubmitReply: (questionId, content) async {
                            await context.read<DiscussionCubit>().postAnswer(
                                  questionId: questionId,
                                  content: content,
                                  demoId: demoId,
                                );
                          },
                          onQuestionDeleted: () =>
                              onQuestionDeleted(question.id),
                          onQuestionUpdated: (newContent) =>
                              onQuestionUpdated(question.id, newContent),
                        );
                      },
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

class _LessonAttachmentsTab extends StatelessWidget {
  final List<LessonAttachmentEntity> attachments;
  final bool loading;

  const _LessonAttachmentsTab({
    required this.attachments,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const _LessonTabStatus(
        isLoading: true,
      );
    }

    if (attachments.isEmpty) {
      return _LessonTabStatus(
        icon: Icons.attach_file_rounded,
        message: AppLocalizations.of(context)!.noAttachments,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: AttachmentsTab(
        attachments: attachments,
        loading: false,
      ),
    );
  }
}

class _LessonTabStatus extends StatelessWidget {
  final bool isLoading;
  final IconData icon;
  final String? message;

  const _LessonTabStatus({
    this.isLoading = false,
    this.icon = Icons.info_outline_rounded,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: isLoading
            ? SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  color: primary,
                  strokeWidth: 2.5,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      icon,
                      color: primary,
                      size: 25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondaryOf(context),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}