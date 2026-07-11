import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/lesson/presentation/pages/create_lesson_screen.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';
import 'package:project1/features/section/presentation/cubit/section_state.dart';
import 'package:project1/features/section/presentation/widgets/section_card.dart';
import 'package:project1/l10n/app_localizations.dart';

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

class _SectionManagementScreenState
    extends State<SectionManagementScreen> {
  late final SectionCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = getIt<SectionCubit>();
    cubit.getSections(
      courseId: widget.courseId,
    );
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  Future<void> addLessonTo(SectionEntity section) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateLessonScreen(),
      ),
    );
  }

  void manageQuestionsBank(SectionEntity section) {}

  void manageQuiz(SectionEntity section) {}

  Future<void> renameSection(
    SectionEntity section,
  ) async {
    final localizations = AppLocalizations.of(context)!;

    final controller = TextEditingController(
      text: section.title,
    );

    final newTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(localizations.renameSection),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: localizations.sectionName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              localizations.cancel,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final title = controller.text.trim();

              if (title.isNotEmpty) {
                Navigator.pop(dialogContext, title);
              }
            },
            child: Text(
              localizations.save,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (newTitle == null) return;

    await cubit.updateSection(
      courseId: widget.courseId,
      sectionId: section.id,
      title: newTitle,
      order: section.order,
    );
  }

  Future<void> deleteSection(
    SectionEntity section,
  ) async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(localizations.deleteSection),
        content: Text(
          localizations.deleteSectionConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: Text(
              localizations.cancel,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
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

    await cubit.deleteSection(
      courseId: widget.courseId,
      sectionId: section.id,
    );
  }

  Future<void> addSection() async {
    final localizations = AppLocalizations.of(context)!;

    final controller = TextEditingController();

    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(localizations.addSection),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: localizations.sectionName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext),
            child: Text(
              localizations.cancel,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text.trim();

              if (value.isNotEmpty) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: Text(
              localizations.add,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (title == null) return;

    await cubit.createSection(
      courseId: widget.courseId,
      title: title,
      order: cubit.state.sections.length + 1,
    );
  }
    @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<SectionCubit, SectionState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                localizations.sections,
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
            body: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.sections.isEmpty
                    ? Center(
                        child: Text(
                          localizations.noSectionsYet,
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(.7),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          90,
                        ),
                        itemCount: state.sections.length,
                        itemBuilder: (context, index) {
                          final section = state.sections[index];

                          return SectionCard(
                            section: section,
                            onAddLesson: () =>
                                addLessonTo(section),
                            onEditLesson: () {},
                            onManageQuestionsBank: () =>
                                manageQuestionsBank(section),
                            onManageQuiz: () =>
                                manageQuiz(section),
                            onRename: () =>
                                renameSection(section),
                            onDelete: () =>
                                deleteSection(section),
                          );
                        },
                      ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: addSection,
              backgroundColor: AppColors.primary,
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
              label: Text(
                localizations.addSection,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}