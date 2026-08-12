import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_cubit.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class ExamManagementScreen extends StatefulWidget {
  final String sectionId;
  const ExamManagementScreen({super.key, required this.sectionId});

  @override
  State<ExamManagementScreen> createState() => _ExamManagementScreenState();
}

class _ExamManagementScreenState extends State<ExamManagementScreen> {
  late final ExamCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ExamCubit>();
    _cubit.fetchExams(sectionId: widget.sectionId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        appBar: GradientPageAppBar(
          title: localizations.quizInformation,
          subtitle: localizations.enterExamDetailsDescription,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: SafeArea(
          child: BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              if (state is ExamLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOf(context),
                  ),
                );
              }

              if (state is ExamError) {
                return _ExamStatusView(
                  message: state.message,
                  retryLabel: localizations.retry,
                  onRetry: () => _cubit.fetchExams(sectionId: widget.sectionId),
                );
              }

              if (state is ExamLoaded) {
                final ExamModel? exam = state.exams.isEmpty
                    ? null
                    : state.exams.first;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 54),
                  child: _ExamFormContent(
                    cubit: _cubit,
                    sectionId: widget.sectionId,
                    exam: exam,
                  ),
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

class _ExamFormContent extends StatefulWidget {
  final ExamCubit cubit;
  final String sectionId;
  final ExamModel? exam;

  const _ExamFormContent({
    required this.cubit,
    required this.sectionId,
    this.exam,
  });

  @override
  State<_ExamFormContent> createState() => _ExamFormContentState();
}

class _ExamFormContentState extends State<_ExamFormContent> {
  late final TextEditingController _titleController;
  late final TextEditingController _questionsController;
  late final TextEditingController _durationController;
  late final TextEditingController _passingScoreController;

  bool _titleError = false;
  bool _questionsError = false;
  bool _durationError = false;
  bool _passingScoreError = false;
  bool _isSaving = false;

  bool get _isEditing => widget.exam != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.exam?.title ?? '');
    _questionsController = TextEditingController(
      text: widget.exam != null ? '${widget.exam!.numberOfQuestions}' : '',
    );
    _durationController = TextEditingController(
      text: widget.exam != null ? '${widget.exam!.durationMinutes}' : '',
    );
    _passingScoreController = TextEditingController(
      text: widget.exam != null ? '${widget.exam!.passingScore}' : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionsController.dispose();
    _durationController.dispose();
    _passingScoreController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final localizations = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    final numberOfQuestions = int.tryParse(_questionsController.text.trim());
    final durationMinutes = int.tryParse(_durationController.text.trim());
    final passingScore = int.tryParse(_passingScoreController.text.trim());

    setState(() {
      _titleError = title.isEmpty;
      _questionsError = numberOfQuestions == null || numberOfQuestions <= 0;
      _durationError = durationMinutes == null || durationMinutes <= 0;
      _passingScoreError = passingScore == null || passingScore < 0 || passingScore > 100;
    });

    if (_titleError || _questionsError || _durationError || _passingScoreError) return;

    setState(() => _isSaving = true);

    final success = _isEditing
        ? await widget.cubit.updateExam(
            sectionId: widget.sectionId,
            examId: widget.exam!.id,
            title: title,
            numberOfQuestions: numberOfQuestions!,
            durationMinutes: durationMinutes!,
            passingScore: passingScore!,
          )
        : await widget.cubit.createExam(
            sectionId: widget.sectionId,
            title: title,
            numberOfQuestions: numberOfQuestions!,
            durationMinutes: durationMinutes!,
            passingScore: passingScore!,
          );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      widget.cubit.fetchExams(sectionId: widget.sectionId);
      SnackbarTheme().newSnackBarSuccess(
        context,
        _isEditing
            ? localizations.examUpdatedSuccessfully
            : localizations.examCreatedSuccessfully,
      );
    } else {
      SnackbarTheme().newSnackBarError(
        context,
        _isEditing
            ? localizations.failedToUpdateExam
            : localizations.failedToCreateExam,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ExamIntroCard(
          title: _isEditing ? localizations.editExam : localizations.addExam,
          description: localizations.enterExamDetailsDescription,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.borderOf(context).withValues(alpha: 0.82),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ExamFormField(
                label: localizations.examTitle,
                hintText: localizations.examTitleHint,
                icon: Icons.title_rounded,
                controller: _titleController,
                hasError: _titleError,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  if (_titleError) setState(() => _titleError = false);
                },
              ),
              const SizedBox(height: 18),
              _ExamFormField(
                label: localizations.numberOfQuestions,
                hintText: localizations.numberOfQuestionsHint,
                icon: Icons.format_list_numbered_rounded,
                controller: _questionsController,
                hasError: _questionsError,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  if (_questionsError) {
                    setState(() => _questionsError = false);
                  }
                },
              ),
              const SizedBox(height: 18),
              _ExamFormField(
                label: localizations.durationMinutes,
                hintText: localizations.durationMinutesHint,
                icon: Icons.timer_outlined,
                controller: _durationController,
                hasError: _durationError,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  if (_durationError) {
                    setState(() => _durationError = false);
                  }
                },
              ),
              const SizedBox(height: 18),
              _ExamFormField(
                label: 'Passing Score (%)',
                hintText: 'Enter passing score (0-100)',
                icon: Icons.trending_up_rounded,
                controller: _passingScoreController,
                hasError: _passingScoreError,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (_) {
                  if (_passingScoreError) {
                    setState(() => _passingScoreError = false);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        GradientActionButton(
          label: localizations.saveChanges,
          icon: Icons.check_circle_outline_rounded,
          isLoading: _isSaving,
          expand: true,
          onPressed: _isSaving ? null : _save,
        ),
      ],
    );
  }
}

class _ExamIntroCard extends StatelessWidget {
  final String title;
  final String description;

  const _ExamIntroCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.82),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradientOf(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.18),
                  blurRadius: 11,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryOf(context),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool hasError;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String> onChanged;

  const _ExamFormField({
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.hasError,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction,
  });

  OutlineInputBorder _border(BuildContext context, {bool focused = false}) {
    final color = hasError
        ? AppColors.error
        : focused
        ? AppColors.primaryOf(context)
        : AppColors.borderOf(context);

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: color,
        width: hasError || focused ? 1.7 : 1.1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: TextStyle(color: AppColors.textPrimaryOf(context)),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondaryOf(context).withValues(alpha: 0.72),
            ),
            filled: true,
            fillColor: AppColors.backgroundOf(context),
            prefixIcon: Icon(icon, color: primary, size: 21),
            border: _border(context),
            enabledBorder: _border(context),
            focusedBorder: _border(context, focused: true),
            errorBorder: _border(context),
            focusedErrorBorder: _border(context, focused: true),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExamStatusView extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ExamStatusView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderOf(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 29,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryOf(context),
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            GradientActionButton(
              label: retryLabel,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
