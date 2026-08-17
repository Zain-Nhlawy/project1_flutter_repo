import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
import 'package:project1/features/lesson/presentation/pages/create_lesson_screen.dart';
import 'package:project1/features/questions_bank/presentation/pages/question_bank_management_screen.dart';
import 'package:project1/features/quiz/presentation/pages/management/exam_management_screen.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';
import 'package:project1/features/section/presentation/cubit/section_state.dart';
import 'package:project1/features/section/presentation/widgets/section_card.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_cubit.dart';

class SectionManagementScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const SectionManagementScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<SectionManagementScreen> createState() =>
      _SectionManagementScreenState();
}

class _SectionManagementScreenState extends State<SectionManagementScreen> {
  late final SectionCubit cubit;
  bool _hasChanges = false;
  int _refreshTick = 0;

  @override
  void initState() {
    super.initState();
    cubit = getIt<SectionCubit>();
    cubit.getSections(courseId: widget.courseId);
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  Future<void> addLessonTo(SectionEntity section) async {
    final lessonCubit = getIt<LessonCubit>();
    final currentLessons = await lessonCubit.getLessons(sectionId: section.id);
    await lessonCubit.close();

    final nextOrder = currentLessons.length + 1;

    if (!mounted) return;

    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateLessonScreen(sectionId: section.id, nextOrder: nextOrder),
      ),
    );

    if (created == true && mounted) {
      setState(() {
        _hasChanges = true;
        _refreshTick++;
      });
      cubit.getSections(courseId: widget.courseId);
    }
  }

  void manageQuestionsBank(SectionEntity section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionBankManagementScreen(sectionId: section.id),
      ),
    );
  }

  void manageQuiz(SectionEntity section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamManagementScreen(sectionId: section.id),
      ),
    );
  }

  Future<void> deleteQuiz(SectionEntity section) async {
    final examCubit = getIt<ExamCubit>();
    final result = await examCubit.fetchExams(sectionId: section.id);

    if (result == null || result.data.isEmpty) {
      await examCubit.close();
      return;
    }

    final examId = result.data.first.id;
    final success = await examCubit.deleteExam(
      sectionId: section.id,
      examId: examId,
    );

    await examCubit.close();

    if (!success && mounted) {
      SnackbarTheme().newSnackBarError(
        context,
        AppLocalizations.of(context)!.failedToDeleteExam,
      );
      return;
    }

    if (mounted) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> renameSection(SectionEntity section) async {
    final localizations = AppLocalizations.of(context)!;

    final controller = TextEditingController(text: section.title);

    final newTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _SectionNameDialog(
        controller: controller,
        title: localizations.renameSection,
        hintText: localizations.sectionName,
        actionLabel: localizations.save,
      ),
    );

    if (newTitle == null) return;

    await cubit.updateSection(
      courseId: widget.courseId,
      sectionId: section.id,
      title: newTitle,
      order: section.order,
    );

    if (mounted) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> deleteSection(SectionEntity section) async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(localizations.deleteSection),
        content: Text(localizations.deleteSectionConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              localizations.cancel,
              style: TextStyle(color: AppColors.textSecondaryOf(context)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              localizations.deleteSection,
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await cubit.deleteSection(courseId: widget.courseId, sectionId: section.id);

    if (mounted) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> addSection() async {
    final localizations = AppLocalizations.of(context)!;

    final controller = TextEditingController();

    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _SectionNameDialog(
        controller: controller,
        title: localizations.addSection,
        hintText: localizations.sectionName,
        actionLabel: localizations.add,
      ),
    );

    if (title == null) return;
    await cubit.createSection(
      courseId: widget.courseId,
      title: title,
      order: cubit.state.sections.length + 1,
    );
    if (mounted) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _hasChanges);
      },
      child: BlocProvider.value(
        value: cubit,
        child: BlocConsumer<SectionCubit, SectionState>(
          listener: (context, state) {
            if (state.errors != null && state.errors!.isNotEmpty) {
              SnackbarTheme().newSnackBarError(context, state.errors!.first);
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.backgroundOf(context),
              appBar: GradientPageAppBar(
                title: localizations.sections,
                subtitle: widget.courseTitle,
                onBackPressed: () => Navigator.pop(context, _hasChanges),
              ),
              body: state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOf(context),
                      ),
                    )
                  : state.sections.isEmpty
                  ? _SectionEmptyState(message: localizations.noSectionsYet)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
                      itemCount: state.sections.length,
                      itemBuilder: (context, index) {
                        final section = state.sections[index];
                        return SectionCard(
                          key: ValueKey('${section.id}-$_refreshTick'),
                          section: section,
                          onAddLesson: () => addLessonTo(section),
                          onEditLesson: (lesson) {},
                          onManageQuestionsBank: () =>
                              manageQuestionsBank(section),
                          onManageQuiz: () => manageQuiz(section),
                          onDeleteQuiz: () => deleteQuiz(section),
                          onRename: () => renameSection(section),
                          onDelete: () => deleteSection(section),
                          onLessonsChanged: () {
                            setState(() => _hasChanges = true);
                          },
                        );
                      },
                    ),
              floatingActionButton: GradientActionButton(
                label: localizations.addSection,
                icon: Icons.add_rounded,
                onPressed: addSection,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionNameDialog extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final String actionLabel;

  const _SectionNameDialog({
    required this.controller,
    required this.title,
    required this.hintText,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return AlertDialog(
      backgroundColor: AppColors.surfaceOf(context),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      actionsPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.folder_copy_outlined, color: primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimaryOf(context),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: TextStyle(color: AppColors.textPrimaryOf(context)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textSecondaryOf(context)),
          prefixIcon: Icon(Icons.title_rounded, color: primary),
          filled: true,
          fillColor: AppColors.backgroundOf(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.borderOf(context)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.borderOf(context)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: primary, width: 1.7),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: TextStyle(color: AppColors.textSecondaryOf(context)),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            final value = controller.text.trim();
            if (value.isNotEmpty) Navigator.pop(context, value);
          },
          child: Text(
            actionLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _SectionEmptyState extends StatelessWidget {
  final String message;

  const _SectionEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderOf(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_copy_outlined, color: primary, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimaryOf(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
