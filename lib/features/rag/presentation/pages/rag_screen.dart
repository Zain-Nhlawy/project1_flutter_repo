import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/rag/data/models/ask_answer_model.dart';
import 'package:project1/features/rag/data/models/quiz_question_model.dart';
import 'package:project1/features/rag/data/models/quiz_response_model.dart';
import 'package:project1/features/rag/presentation/cubit/rag_cubit.dart';
import 'package:project1/features/rag/presentation/cubit/rag_state.dart';
import 'package:project1/features/rag/presentation/widgets/build_gradient_button.dart';
import 'package:project1/features/rag/presentation/widgets/build_section_card.dart';
import 'package:project1/features/rag/presentation/widgets/input_decoration.dart';
import 'package:project1/l10n/app_localizations.dart';

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

  @override
  void dispose() {
    _questionController.dispose();
    _topicController.dispose();
    _topicCountController.dispose();
    _randomCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.aiAssistantTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionCard(
                title: localizations.askQuestionSection,
                icon: Icons.psychology_rounded,
                children: [
                  TextField(
                    controller: _questionController,
                    style: AppTextStyles.bodyMedium.copyWith(color: textPrimaryColor),
                    decoration: inputDecoration(
                      hint: localizations.askQuestionHint,
                      borderColor: borderColor,
                      textColor: textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildGradientButton(
                    context,
                    label: localizations.askButton,
                    icon: Icons.send_rounded,
                    onPressed: () {
                      context.read<RagCubit>().askQuestion(
                            courseId: widget.courseId,
                            question: _questionController.text,
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SectionCard(
                title: localizations.topicQuizSection,
                icon: Icons.quiz_rounded,
                children: [
                  TextField(
                    controller: _topicController,
                    style: AppTextStyles.bodyMedium.copyWith(color: textPrimaryColor),
                    decoration: inputDecoration(
                      hint: localizations.topicHint,
                      borderColor: borderColor,
                      textColor: textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _topicCountController,
                    style: AppTextStyles.bodyMedium.copyWith(color: textPrimaryColor),
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration(
                      hint: localizations.questionCountHint,
                      borderColor: borderColor,
                      textColor: textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildGradientButton(
                    context,
                    label: localizations.generateTopicQuizButton,
                    icon: Icons.auto_awesome_rounded,
                    onPressed: () {
                      context.read<RagCubit>().generateTopicQuiz(
                            courseId: widget.courseId,
                            topic: _topicController.text,
                            questionCount: int.tryParse(_topicCountController.text) ?? 2,
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SectionCard(
                title: localizations.randomQuizSection,
                icon: Icons.shuffle_rounded,
                children: [
                  TextField(
                    controller: _randomCountController,
                    style: AppTextStyles.bodyMedium.copyWith(color: textPrimaryColor),
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration(
                      hint: localizations.questionCountHint,
                      borderColor: borderColor,
                      textColor: textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildGradientButton(
                    context,
                    label: localizations.generateRandomQuizButton,
                    icon: Icons.bolt_rounded,
                    onPressed: () {
                      context.read<RagCubit>().generateRandomQuiz(
                            courseId: widget.courseId,
                            questionCount: int.tryParse(_randomCountController.text) ?? 3,
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.terminal_rounded, color: AppColors.primaryOf(context), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          localizations.aiResponseTitle,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: textPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: SingleChildScrollView(
                        child: BlocBuilder<RagCubit, RagState>(
                          builder: (context, state) {
                            if (state is RagLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (state is RagError) {
                              return SelectableText(
                                '${localizations.errorPrefix}${state.message}',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                              );
                            }
                            if (state is RagLoaded) {
                              return _buildLoadedContent(
                                state.rawResponse,
                                textPrimaryColor,
                                textSecondaryColor,
                                isDark,
                              );
                            }
                            return Center(
                              child: Text(
                                localizations.noDataYet,
                                style: AppTextStyles.bodyMedium.copyWith(color: textSecondaryColor),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// يفحص نوع البيانات القادمة (سؤال عادي / كويز) ويعرض الواجهة المناسبة
  Widget _buildLoadedContent(
    dynamic data,
    Color textPrimaryColor,
    Color textSecondaryColor,
    bool isDark,
  ) {
    if (data is AskAnswerModel) {
      return SelectableText(
        data.answer,
        style: AppTextStyles.bodyMedium.copyWith(color: textPrimaryColor, height: 1.5),
      );
    }

    if (data is QuizResponseModel) {
      if (data.questions.isEmpty) {
        return Text(
          'No questions generated.',
          style: AppTextStyles.bodyMedium.copyWith(color: textSecondaryColor),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < data.questions.length; i++) ...[
            _buildQuizCard(data.questions[i], i + 1, textPrimaryColor, textSecondaryColor, isDark),
            if (i != data.questions.length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    }

    // fallback احتياطي لأي نوع غير متوقع
    return SelectableText(
      data.toString(),
      style: AppTextStyles.bodyMedium.copyWith(
        fontFamily: 'monospace',
        color: textPrimaryColor,
      ),
    );
  }

  Widget _buildQuizCard(
    QuizQuestionModel q,
    int index,
    Color textPrimaryColor,
    Color textSecondaryColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${q.question}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          for (final option in q.options)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                option,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: option.trim().startsWith(q.correctAnswer)
                      ? AppColors.success
                      : textSecondaryColor,
                  fontWeight: option.trim().startsWith(q.correctAnswer)
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          if (q.explanation.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              q.explanation,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textSecondaryColor,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}