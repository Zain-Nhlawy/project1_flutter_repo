import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            localizations.quizInformation,
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
          child: BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              if (state is ExamLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ExamError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                );
              }

              if (state is ExamLoaded) {
                final ExamModel? exam =
                    state.exams.isEmpty ? null : state.exams.first;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
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

  bool _titleError = false;
  bool _questionsError = false;
  bool _durationError = false;
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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  OutlineInputBorder _buildBorder(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: hasError ? Colors.red.shade400 : AppColors.border,
        width: hasError ? 1.4 : 1,
      ),
    );
  }

  Future<void> _save() async {
    final localizations = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    final numberOfQuestions = int.tryParse(_questionsController.text.trim());
    final durationMinutes = int.tryParse(_durationController.text.trim());

    setState(() {
      _titleError = title.isEmpty;
      _questionsError = numberOfQuestions == null || numberOfQuestions <= 0;
      _durationError = durationMinutes == null || durationMinutes <= 0;
    });

    if (_titleError || _questionsError || _durationError) return;

    setState(() => _isSaving = true);

    final success = _isEditing
        ? await widget.cubit.updateExam(
            sectionId: widget.sectionId,
            examId: widget.exam!.id,
            title: title,
            numberOfQuestions: numberOfQuestions!,
            durationMinutes: durationMinutes!,
          )
        : await widget.cubit.createExam(
            sectionId: widget.sectionId,
            title: title,
            numberOfQuestions: numberOfQuestions!,
            durationMinutes: durationMinutes!,
          );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      widget.cubit.fetchExams(sectionId: widget.sectionId);
      SnackbarTheme().newSnackBarSuccess(
        context,
        _isEditing ? localizations.examUpdatedSuccessfully : localizations.examCreatedSuccessfully,
      );
    } else {
      SnackbarTheme().newSnackBarError(
        context,
        _isEditing ? localizations.failedToUpdateExam : localizations.failedToCreateExam,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.quiz_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditing ? localizations.editExam : localizations.addExam,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations.enterExamDetailsDescription,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(height: 1),
        ),
        Text(
          localizations.examTitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          style: const TextStyle(color: AppColors.textPrimary),
          onChanged: (_) {
            if (_titleError) setState(() => _titleError = false);
          },
          decoration: InputDecoration(
            hintText: localizations.examTitleHint,
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(.7)),
            filled: true,
            fillColor: AppColors.surface,
            border: _buildBorder(_titleError),
            enabledBorder: _buildBorder(_titleError),
            focusedBorder: _buildBorder(_titleError),
            prefixIcon: const Icon(Icons.title, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          localizations.numberOfQuestions,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _questionsController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          onChanged: (_) {
            if (_questionsError) setState(() => _questionsError = false);
          },
          decoration: InputDecoration(
            hintText: localizations.numberOfQuestionsHint,
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(.7)),
            filled: true,
            fillColor: AppColors.surface,
            border: _buildBorder(_questionsError),
            enabledBorder: _buildBorder(_questionsError),
            focusedBorder: _buildBorder(_questionsError),
            prefixIcon: const Icon(Icons.format_list_numbered, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          localizations.durationMinutes,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          onChanged: (_) {
            if (_durationError) setState(() => _durationError = false);
          },
          decoration: InputDecoration(
            hintText: localizations.durationMinutesHint,
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(.7)),
            filled: true,
            fillColor: AppColors.surface,
            border: _buildBorder(_durationError),
            enabledBorder: _buildBorder(_durationError),
            focusedBorder: _buildBorder(_durationError),
            prefixIcon: const Icon(Icons.timer_outlined, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    localizations.saveChanges,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}