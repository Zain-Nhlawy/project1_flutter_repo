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

  const LessonTabs({super.key, required this.lessonId, required this.demoId});

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
                  icon: const Icon(Icons.forum_outlined, size: 18),
                  text: localizations.questionsCount,
                  iconMargin: const EdgeInsets.only(bottom: 2),
                ),
                Tab(
                  height: 42,
                  icon: const Icon(Icons.attach_file_rounded, size: 18),
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

class _QuestionsTab extends StatefulWidget {
  final String lessonId;
  final String demoId;
  final List<DiscussionQuestionModel> questions;
  final bool loading;
  final Future<void> Function(String content) onPostQuestion;
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
  State<_QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<_QuestionsTab> {
  final Set<String> _activeAnswerEditors = <String>{};
  final Map<String, int> _replyRefreshVersions = <String, int>{};
  final TextEditingController _composerController = TextEditingController();
  final FocusNode _composerFocusNode = FocusNode();

  _ReplyTarget? _replyTarget;
  bool _isPosting = false;

  @override
  void dispose() {
    _composerController.dispose();
    _composerFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _QuestionsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    final questionIds = widget.questions.map((question) => question.id).toSet();
    _activeAnswerEditors.retainWhere(questionIds.contains);
    _replyRefreshVersions.removeWhere(
      (questionId, _) => !questionIds.contains(questionId),
    );

    if (_replyTarget != null &&
        !questionIds.contains(_replyTarget!.questionId)) {
      _replyTarget = null;
      _composerController.clear();
    }
  }

  void _startReply(String questionId, String userName) {
    if (_replyTarget?.questionId != questionId) {
      _composerController.clear();
    }

    setState(() {
      _replyTarget = _ReplyTarget(questionId: questionId, userName: userName);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _composerFocusNode.requestFocus();
      }
    });
  }

  void _cancelReply() {
    _composerFocusNode.unfocus();
    _composerController.clear();
    setState(() => _replyTarget = null);
  }

  void _setAnswerEditorOpen(String questionId, bool isOpen) {
    if (isOpen) {
      _composerFocusNode.unfocus();
    }

    setState(() {
      if (isOpen) {
        _activeAnswerEditors.add(questionId);
        _replyTarget = null;
        _composerController.clear();
      } else {
        _activeAnswerEditors.remove(questionId);
      }
    });
  }

  void _handleQuestionDeleted(String questionId) {
    _activeAnswerEditors.remove(questionId);
    _replyRefreshVersions.remove(questionId);
    if (_replyTarget?.questionId == questionId) {
      _replyTarget = null;
      _composerController.clear();
    }
    widget.onQuestionDeleted(questionId);
  }

  Future<void> _submitComposer(String content) async {
    if (_isPosting) return;

    final replyTarget = _replyTarget;
    setState(() => _isPosting = true);

    if (replyTarget == null) {
      await widget.onPostQuestion(content);
    } else {
      await context.read<DiscussionCubit>().postAnswer(
        questionId: replyTarget.questionId,
        content: content,
        demoId: widget.demoId,
      );
    }

    if (!mounted) return;

    if (replyTarget != null) {
      _composerFocusNode.unfocus();
    }

    setState(() {
      _isPosting = false;
      if (replyTarget != null) {
        _replyTarget = null;
        _replyRefreshVersions[replyTarget.questionId] =
            (_replyRefreshVersions[replyTarget.questionId] ?? 0) + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (widget.loading) {
      return const _LessonTabStatus(isLoading: true);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.forum_outlined,
                  color: AppColors.primaryOf(context),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  localizations.questionsCount,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.questions.length}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primaryOf(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.questions.isEmpty
              ? _LessonTabStatus(
                  icon: Icons.chat_bubble_outline_rounded,
                  message: localizations.noQuestionsYet,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    final question = widget.questions[index];

                    return BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                        final currentUserId = userState is UserLoaded
                            ? userState.user.id
                            : null;

                        return QaCard(
                          key: ValueKey(question.id),
                          questionId: question.id,
                          demoId: widget.demoId,
                          lessonId: widget.lessonId,
                          userName: question.authorName,
                          avatarUrl: question.authorAvatarUrl,
                          question: question.content,
                          createdAt: question.createdAt,
                          isOwner:
                              currentUserId != null &&
                              question.authorId == currentUserId,
                          currentUserId: currentUserId,
                          isReplyTarget:
                              _replyTarget?.questionId == question.id,
                          replyRefreshVersion:
                              _replyRefreshVersions[question.id] ?? 0,
                          onReply: () =>
                              _startReply(question.id, question.authorName),
                          onAnswerEditorChanged: (isOpen) =>
                              _setAnswerEditorOpen(question.id, isOpen),
                          onQuestionDeleted: () =>
                              _handleQuestionDeleted(question.id),
                          onQuestionUpdated: (newContent) =>
                              widget.onQuestionUpdated(question.id, newContent),
                        );
                      },
                    );
                  },
                ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _activeAnswerEditors.isNotEmpty
              ? const SizedBox.shrink(key: ValueKey('answer-editor-active'))
              : Container(
                  key: const ValueKey('bottom-composer'),
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.borderOf(
                          context,
                        ).withValues(alpha: 0.72),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_replyTarget != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                localizations.chatReplyingTo(
                                  _replyTarget!.userName,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondaryOf(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _isPosting ? null : _cancelReply,
                              tooltip: localizations.cancel,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 24,
                                height: 24,
                              ),
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.close_rounded,
                                size: 15,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      DiscussionComposer(
                        controller: _composerController,
                        focusNode: _composerFocusNode,
                        hintText: _replyTarget == null
                            ? localizations.askAQuestion
                            : localizations.replyHint,
                        isPosting: _isPosting,
                        onSubmit: _submitComposer,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _ReplyTarget {
  final String questionId;
  final String userName;

  const _ReplyTarget({required this.questionId, required this.userName});
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
      return const _LessonTabStatus(isLoading: true);
    }

    if (attachments.isEmpty) {
      return _LessonTabStatus(
        icon: Icons.attach_file_rounded,
        message: AppLocalizations.of(context)!.noAttachments,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: AttachmentsTab(attachments: attachments, loading: false),
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
                    child: Icon(icon, color: primary, size: 25),
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
