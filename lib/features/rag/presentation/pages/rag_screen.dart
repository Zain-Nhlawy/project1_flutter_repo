import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/rag/data/models/ask_answer_model.dart';
import 'package:project1/features/rag/data/models/quiz_response_model.dart';
import 'package:project1/features/rag/presentation/cubit/rag_cubit.dart';
import 'package:project1/features/rag/presentation/cubit/rag_state.dart';
import 'package:project1/features/rag/presentation/widgets/build_gradient_button.dart';
import 'package:project1/features/rag/presentation/widgets/build_quiz_card.dart';
import 'package:project1/features/rag/presentation/widgets/input_decoration.dart';
import 'package:project1/l10n/app_localizations.dart';

enum _RagAction { askQuestion, topicQuiz, randomQuiz }

class RagScreen extends StatefulWidget {
  final String courseId;

  const RagScreen({super.key, required this.courseId});

  @override
  State<RagScreen> createState() => _RagScreenState();
}

class _RagScreenState extends State<RagScreen> {
  final _questionController = TextEditingController();
  final _topicController = TextEditingController();
  final _topicCountController = TextEditingController(text: '2');
  final _randomCountController = TextEditingController(text: '3');
  final _scrollController = ScrollController();
  final _responseKey = GlobalKey();
  _RagAction _selectedAction = _RagAction.askQuestion;

  @override
  void dispose() {
    _questionController.dispose();
    _topicController.dispose();
    _topicCountController.dispose();
    _randomCountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToResponse() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final responseContext = _responseKey.currentContext;
      if (!mounted || responseContext == null) return;

      Scrollable.ensureVisible(
        responseContext,
        alignment: 0.05,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: GradientPageAppBar(
        title: localizations.aiAssistantTitle,
        subtitle: localizations.noDataYet,
        subtitleMaxLines: 2,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<RagCubit, RagState>(
        listener: (context, state) {
          if (state is RagLoading || state is RagLoaded || state is RagError) {
            _scrollToResponse();
          }
        },
        builder: (context, state) {
          final isLoading = state is RagLoading;

          return SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth >= 700
                    ? 32.0
                    : 16.0;

                return SingleChildScrollView(
                  controller: _scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    60,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 920),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _AssistantWorkspace(
                            selectedAction: _selectedAction,
                            isLoading: isLoading,
                            questionController: _questionController,
                            topicController: _topicController,
                            topicCountController: _topicCountController,
                            randomCountController: _randomCountController,
                            onActionChanged: isLoading
                                ? null
                                : (action) {
                                    FocusScope.of(context).unfocus();
                                    setState(() => _selectedAction = action);
                                  },
                            onAsk: isLoading
                                ? null
                                : () {
                                    context.read<RagCubit>().askQuestion(
                                      courseId: widget.courseId,
                                      question: _questionController.text,
                                    );
                                  },
                            onGenerateTopicQuiz: isLoading
                                ? null
                                : () {
                                    context.read<RagCubit>().generateTopicQuiz(
                                      courseId: widget.courseId,
                                      topic: _topicController.text,
                                      questionCount:
                                          int.tryParse(
                                            _topicCountController.text,
                                          ) ??
                                          2,
                                    );
                                  },
                            onGenerateRandomQuiz: isLoading
                                ? null
                                : () {
                                    context.read<RagCubit>().generateRandomQuiz(
                                      courseId: widget.courseId,
                                      questionCount:
                                          int.tryParse(
                                            _randomCountController.text,
                                          ) ??
                                          3,
                                    );
                                  },
                          ),
                          const SizedBox(height: 22),
                          _ResponsePanel(key: _responseKey, state: state),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _AssistantWorkspace extends StatelessWidget {
  final _RagAction selectedAction;
  final bool isLoading;
  final TextEditingController questionController;
  final TextEditingController topicController;
  final TextEditingController topicCountController;
  final TextEditingController randomCountController;
  final ValueChanged<_RagAction>? onActionChanged;
  final VoidCallback? onAsk;
  final VoidCallback? onGenerateTopicQuiz;
  final VoidCallback? onGenerateRandomQuiz;

  const _AssistantWorkspace({
    required this.selectedAction,
    required this.isLoading,
    required this.questionController,
    required this.topicController,
    required this.topicCountController,
    required this.randomCountController,
    required this.onActionChanged,
    required this.onAsk,
    required this.onGenerateTopicQuiz,
    required this.onGenerateRandomQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = AppColors.borderOf(context);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border.withValues(alpha: 0.82)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 82,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.backgroundOf(context),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: border.withValues(alpha: 0.72)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _WorkspaceModeButton(
                    icon: Icons.psychology_alt_outlined,
                    label: localizations.askQuestionSection,
                    selected: selectedAction == _RagAction.askQuestion,
                    onTap: onActionChanged == null
                        ? null
                        : () => onActionChanged!(_RagAction.askQuestion),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _WorkspaceModeButton(
                    icon: Icons.quiz_outlined,
                    label: localizations.topicQuizSection,
                    selected: selectedAction == _RagAction.topicQuiz,
                    onTap: onActionChanged == null
                        ? null
                        : () => onActionChanged!(_RagAction.topicQuiz),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _WorkspaceModeButton(
                    icon: Icons.shuffle_rounded,
                    label: localizations.randomQuizSection,
                    selected: selectedAction == _RagAction.randomQuiz,
                    onTap: onActionChanged == null
                        ? null
                        : () => onActionChanged!(_RagAction.randomQuiz),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Divider(height: 1, color: border.withValues(alpha: 0.72)),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              );
            },
            child: _buildSelectedForm(context, localizations),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedForm(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final textStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textPrimaryOf(context),
      height: 1.45,
    );

    switch (selectedAction) {
      case _RagAction.askQuestion:
        return Column(
          key: const ValueKey(_RagAction.askQuestion),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: questionController,
              enabled: !isLoading,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              style: textStyle,
              decoration: inputDecoration(
                context: context,
                hint: localizations.askQuestionHint,
                icon: Icons.chat_bubble_outline_rounded,
              ),
            ),
            const SizedBox(height: 14),
            buildGradientButton(
              context,
              label: localizations.askButton,
              icon: Icons.send_rounded,
              onPressed: onAsk,
            ),
          ],
        );
      case _RagAction.topicQuiz:
        return Column(
          key: const ValueKey(_RagAction.topicQuiz),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: topicController,
              enabled: !isLoading,
              textInputAction: TextInputAction.next,
              style: textStyle,
              decoration: inputDecoration(
                context: context,
                hint: localizations.topicHint,
                icon: Icons.topic_outlined,
              ),
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: TextField(
                controller: topicCountController,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                style: textStyle,
                decoration: inputDecoration(
                  context: context,
                  hint: localizations.questionCountHint,
                  label: localizations.questionCountHint,
                  icon: Icons.format_list_numbered_rounded,
                ),
              ),
            ),
            const SizedBox(height: 14),
            buildGradientButton(
              context,
              label: localizations.generateTopicQuizButton,
              icon: Icons.auto_awesome_rounded,
              onPressed: onGenerateTopicQuiz,
            ),
          ],
        );
      case _RagAction.randomQuiz:
        return Column(
          key: const ValueKey(_RagAction.randomQuiz),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: TextField(
                controller: randomCountController,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                style: textStyle,
                decoration: inputDecoration(
                  context: context,
                  hint: localizations.questionCountHint,
                  label: localizations.questionCountHint,
                  icon: Icons.format_list_numbered_rounded,
                ),
              ),
            ),
            const SizedBox(height: 14),
            buildGradientButton(
              context,
              label: localizations.generateRandomQuizButton,
              icon: Icons.bolt_rounded,
              onPressed: onGenerateRandomQuiz,
            ),
          ],
        );
    }
  }
}

class _WorkspaceModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _WorkspaceModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 190),
            constraints: const BoxConstraints(minHeight: 70),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.buttonGradientOf(context) : null,
              borderRadius: BorderRadius.circular(13),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.18),
                        blurRadius: 9,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? Colors.white
                      : AppColors.textSecondaryOf(context),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: selected
                        ? Colors.white
                        : AppColors.textPrimaryOf(context),
                    fontSize: 10.5,
                    height: 1.2,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponsePanel extends StatelessWidget {
  final RagState state;

  const _ResponsePanel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = AppColors.borderOf(context);
    final primary = AppColors.primaryOf(context);
    final responseTitle = state is RagLoading
        ? localizations.aiFulfillingRequest
        : localizations.aiResponseTitle;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border.withValues(alpha: 0.82)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  responseTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: border.withValues(alpha: 0.72)),
          const SizedBox(height: 17),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _buildContent(context, localizations),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations localizations) {
    if (state is RagLoading) {
      return _AiResponseLoader(
        key: const ValueKey('rag-loading'),
        message: localizations.aiFulfillingRequest,
      );
    }

    if (state is RagError) {
      return _ResponseStatus(
        key: const ValueKey('rag-error'),
        icon: Icons.error_outline_rounded,
        color: AppColors.error,
        message: '${localizations.errorPrefix}${(state as RagError).message}',
      );
    }

    if (state is RagLoaded) {
      final data = (state as RagLoaded).rawResponse;

      if (data is AskAnswerModel) {
        return Container(
          key: ValueKey(data.timestamp),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundOf(context).withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderOf(context)),
          ),
          child: SelectableText(
            data.answer,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontSize: 14.5,
              height: 1.65,
            ),
          ),
        );
      }

      if (data is QuizResponseModel) {
        if (data.questions.isEmpty) {
          return _ResponseStatus(
            key: ValueKey(data.timestamp),
            icon: Icons.quiz_outlined,
            color: AppColors.primaryOf(context),
            message: localizations.noDataYet,
          );
        }

        return Column(
          key: ValueKey(data.timestamp),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < data.questions.length; i++) ...[
              QuizCard(question: data.questions[i], index: i + 1),
              if (i != data.questions.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      }

      return Container(
        key: const ValueKey('rag-fallback'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundOf(context).withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SelectableText(
          data.toString(),
          style: AppTextStyles.bodyMedium.copyWith(
            fontFamily: 'monospace',
            color: AppColors.textPrimaryOf(context),
            height: 1.5,
          ),
        ),
      );
    }

    return _ResponseStatus(
      key: const ValueKey('rag-empty'),
      icon: Icons.forum_outlined,
      color: AppColors.primaryOf(context),
      message: localizations.noDataYet,
    );
  }
}

class _AiResponseLoader extends StatefulWidget {
  final String message;

  const _AiResponseLoader({super.key, required this.message});

  @override
  State<_AiResponseLoader> createState() => _AiResponseLoaderState();
}

class _AiResponseLoaderState extends State<_AiResponseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: AnimatedBuilder(
              animation: _shakeController,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradientOf(context),
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.24),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              builder: (context, child) {
                final phase = _shakeController.value * math.pi * 2;
                final diagonalOffset = math.sin(phase) * 1.5;
                return Center(
                  child: Transform.translate(
                    offset: Offset(diagonalOffset, diagonalOffset),
                    child: child,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 6,
                color: primary,
                backgroundColor: primary.withValues(alpha: 0.12),
              ),
            ),
          ),
          const SizedBox(height: 17),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponseStatus extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;

  const _ResponseStatus({
    super.key,
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Icon(icon, color: color, size: 27),
          ),
          const SizedBox(height: 13),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
