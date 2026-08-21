import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/quiz/data/models/exam_model.dart';
import 'package:project1/features/quiz/domain/entities/exam_entity.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_cubit.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_state.dart';
import 'package:project1/features/quiz/presentation/widgets/management/exam_form_field.dart';
import 'package:project1/features/quiz/presentation/widgets/management/exam_intro_card.dart';
import 'package:project1/features/quiz/presentation/widgets/management/exam_status_view.dart';
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
                return AppSkeletonizer(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 54),
                    child: _ExamFormContent(
                      cubit: _cubit,
                      sectionId: widget.sectionId,
                      exam: dummyExam,
                    ),
                  ),
                );
              }

              if (state is ExamError) {
                return ExamStatusView(
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
  final ExamEntity? exam;

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
      _passingScoreError =
          passingScore == null || passingScore < 0 || passingScore > 100;
    });

    if (_titleError ||
        _questionsError ||
        _durationError ||
        _passingScoreError) {
      return;
    }

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
      Navigator.pop(context, true);
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
        ExamIntroCard(
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
              ExamFormField(
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
              ExamFormField(
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
              ExamFormField(
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
              ExamFormField(
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
