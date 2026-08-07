import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/questions_bank/data/models/question_bank_model.dart';
import 'package:project1/features/questions_bank/data/models/question_choice_model.dart';
import 'package:project1/features/questions_bank/presentation/cubit/question_bank_cubit.dart';
import 'package:project1/features/questions_bank/presentation/cubit/question_bank_state.dart';
import 'package:project1/features/questions_bank/presentation/widgets/question_bank_header.dart';
import 'package:project1/features/questions_bank/presentation/widgets/question_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuestionBankManagementScreen extends StatefulWidget {
  final String sectionId;
  const QuestionBankManagementScreen({super.key, required this.sectionId});

  @override
  State<QuestionBankManagementScreen> createState() =>
      _QuestionBankManagementScreenState();
}

class _QuestionBankManagementScreenState
    extends State<QuestionBankManagementScreen> {
  late final QuestionBankCubit _cubit;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = getIt<QuestionBankCubit>();
    _cubit.fetchQuestionBanks(sectionId: widget.sectionId);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadMore(sectionId: widget.sectionId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _confirmDelete(QuestionBankModel question) async {
    final localizations = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(localizations.deleteQuestion),
          content: Text(localizations.deleteQuestionConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                localizations.delete,
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    final success = await _cubit.deleteQuestionBank(
      sectionId: widget.sectionId,
      questionBankId: question.id,
    );

    if (!mounted) return;

    if (!success) {
      SnackbarTheme().newSnackBarError(context, localizations.deleteQuestionFailed);
    }
  }

  Future<void> _openAddQuestionSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _AddQuestionSheet(cubit: _cubit, sectionId: widget.sectionId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            localizations.questionsBank,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddQuestionSheet,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            localizations.addQuestion,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<QuestionBankCubit, QuestionBankState>(
            builder: (context, state) {
              if (state is QuestionBankLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is QuestionBankError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                    ),
                  ),
                );
              }

              if (state is QuestionBankLoaded) {
                return ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    QuestionBankHeader(questionsCount: state.questions.length),
                    const SizedBox(height: 18),
                    if (state.questions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            localizations.noQuestionsYet,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary.withOpacity(.7),
                            ),
                          ),
                        ),
                      )
                    else
                      ...[
                        for (int i = 0; i < state.questions.length; i++)
                          QuestionCard(
                            question: state.questions[i],
                            onDelete: () => _confirmDelete(state.questions[i]),
                          ),
                        if (state.hasNextPage)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      ],
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

const int kMinChoices = 2;
const int kMaxChoices = 6;

class _AddQuestionSheet extends StatefulWidget {
  final QuestionBankCubit cubit;
  final String sectionId;

  const _AddQuestionSheet({required this.cubit, required this.sectionId});

  @override
  State<_AddQuestionSheet> createState() => _AddQuestionSheetState();
}

class _AddQuestionSheetState extends State<_AddQuestionSheet> {
  final _questionController = TextEditingController();
  final _noteController = TextEditingController();
  final List<TextEditingController> _choiceControllers = List.generate(
    kMinChoices,
    (_) => TextEditingController(),
  );
  final List<bool> _isCorrectFlags = List.generate(kMinChoices, (_) => false);
  final List<bool> _choiceErrors = List.generate(kMinChoices, (_) => false);

  bool _questionHasError = false;
  bool _correctAnswerError = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _questionController.dispose();
    _noteController.dispose();
    for (final controller in _choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  OutlineInputBorder _buildBorder(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: hasError ? Colors.red.shade400 : AppColors.border,
        width: hasError ? 1.4 : 1,
      ),
    );
  }

  void _addChoice() {
    if (_choiceControllers.length >= kMaxChoices) return;
    setState(() {
      _choiceControllers.add(TextEditingController());
      _isCorrectFlags.add(false);
      _choiceErrors.add(false);
    });
  }

  void _removeChoice(int index) {
    if (_choiceControllers.length <= kMinChoices) return;
    final removed = _choiceControllers.removeAt(index);
    setState(() {
      _isCorrectFlags.removeAt(index);
      _choiceErrors.removeAt(index);
    });
    removed.dispose();
  }

  Future<void> _save() async {
    final localizations = AppLocalizations.of(context)!;
    final question = _questionController.text.trim();
    final note = _noteController.text.trim();
    final rawChoices = _choiceControllers.map((c) => c.text.trim()).toList();

    bool hasError = false;

    setState(() {
      _questionHasError = question.isEmpty;
      if (_questionHasError) hasError = true;

      for (int i = 0; i < rawChoices.length; i++) {
        _choiceErrors[i] = rawChoices[i].isEmpty;
      }

      final seen = <String, int>{};
      for (int i = 0; i < rawChoices.length; i++) {
        final text = rawChoices[i];
        if (text.isEmpty) continue;
        if (seen.containsKey(text)) {
          _choiceErrors[i] = true;
          _choiceErrors[seen[text]!] = true;
        } else {
          seen[text] = i;
        }
      }

      if (_choiceErrors.any((e) => e)) hasError = true;

      _correctAnswerError = !_isCorrectFlags.contains(true);
      if (_correctAnswerError) hasError = true;
    });

    if (hasError) return;

    setState(() => _isSaving = true);

    final choices = List.generate(
      rawChoices.length,
      (i) => QuestionChoiceModel(
        choice: rawChoices[i],
        isCorrect: _isCorrectFlags[i],
      ),
    );

    final success = await widget.cubit.createQuestionBank(
      sectionId: widget.sectionId,
      question: question,
      note: note,
      choices: choices,
    );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      SnackbarTheme().newSnackBarError(context, localizations.deleteQuestionFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text(
                    localizations.addQuestion,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _questionController,
                    maxLines: 2,
                    style: const TextStyle(color: AppColors.textPrimary),
                    onChanged: (_) {
                      if (_questionHasError) {
                        setState(() => _questionHasError = false);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: localizations.questionHint,
                      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(.7)),
                      filled: true,
                      fillColor: AppColors.background,
                      border: _buildBorder(_questionHasError),
                      enabledBorder: _buildBorder(_questionHasError),
                      focusedBorder: _buildBorder(_questionHasError),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Note',
                      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(.7)),
                      filled: true,
                      fillColor: AppColors.background,
                      border: _buildBorder(false),
                      enabledBorder: _buildBorder(false),
                      focusedBorder: _buildBorder(false),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.choicesLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_choiceControllers.length}/$kMaxChoices',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary.withOpacity(.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (int i = 0; i < _choiceControllers.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isCorrectFlags[i],
                            activeColor: AppColors.success,
                            side: _correctAnswerError
                                ? BorderSide(color: Colors.red.shade400, width: 1.6)
                                : null,
                            onChanged: (val) {
                              setState(() {
                                _isCorrectFlags[i] = val ?? false;
                                if (_correctAnswerError) {
                                  _correctAnswerError = false;
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: _choiceControllers[i],
                              style: const TextStyle(color: AppColors.textPrimary),
                              onChanged: (_) {
                                if (_choiceErrors[i]) {
                                  setState(() => _choiceErrors[i] = false);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: '${localizations.choiceHint} ${i + 1}',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(.7),
                                ),
                                filled: true,
                                fillColor: AppColors.background,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                border: _buildBorder(_choiceErrors[i]),
                                enabledBorder: _buildBorder(_choiceErrors[i]),
                                focusedBorder: _buildBorder(_choiceErrors[i]),
                              ),
                            ),
                          ),
                          if (_choiceControllers.length > kMinChoices)
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline_rounded,
                                size: 20,
                                color: Colors.red.shade400,
                              ),
                              onPressed: () => _removeChoice(i),
                            )
                          else
                            const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  if (_choiceControllers.length < kMaxChoices)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton.icon(
                        onPressed: _addChoice,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(Icons.add, size: 18, color: AppColors.primary),
                        label: Text(
                          localizations.addChoice,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              localizations.save,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}