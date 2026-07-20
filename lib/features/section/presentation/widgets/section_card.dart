import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
import 'package:project1/features/lesson/presentation/pages/lesson_management_screen.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/presentation/widgets/lesson_tile.dart';
import 'package:project1/features/section/presentation/widgets/section_sub_row.dart';
import 'package:project1/l10n/app_localizations.dart';

class SectionCard extends StatefulWidget {
  final SectionEntity section;

  final VoidCallback onAddLesson;
  final void Function(LessonEntity lesson) onEditLesson;
  final VoidCallback onManageQuestionsBank;
  final VoidCallback onManageQuiz;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback? onLessonsChanged;

  const SectionCard({
    super.key,
    required this.section,
    required this.onAddLesson,
    required this.onEditLesson,
    required this.onManageQuestionsBank,
    required this.onManageQuiz,
    required this.onRename,
    required this.onDelete,
    this.onLessonsChanged,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool expanded = false;
  bool _lessonsLoaded = false;
  bool _loadingLessons = false;
  List<LessonEntity> _lessons = [];

  late final LessonCubit _lessonCubit;

  @override
  void initState() {
    super.initState();
    _lessonCubit = getIt<LessonCubit>();
  }

  @override
  void dispose() {
    _lessonCubit.close();
    super.dispose();
  }

  Future<void> _fetchLessons() async {
    setState(() => _loadingLessons = true);

    final lessons = await _lessonCubit.getLessons(sectionId: widget.section.id);

    if (!mounted) return;

    setState(() {
      _lessons = lessons;
      _lessonsLoaded = true;
      _loadingLessons = false;
    });
  }

  Future<void> _toggleExpand() async {
    setState(() => expanded = !expanded);

    if (expanded && !_lessonsLoaded) {
      await _fetchLessons();
    }
  }

  Future<void> refreshLessons() => _fetchLessons();

  Future<void> _navigateToEditLesson(LessonEntity lesson) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LessonManagementScreen(
          sectionId: widget.section.id,
          lessonId: lesson.id,
          lessonTitle: lesson.title,
          lessonDescription: lesson.description,
          videoUrl: lesson.videoUrl,
          initialAttachments: const [],
        ),
      ),
    );

    if (result == true) {
      await _fetchLessons();
      widget.onLessonsChanged?.call();
    }
  }

  Future<void> _confirmDeleteLesson(LessonEntity lesson) async {
    final localizations = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(localizations.deleteLesson),
          content: Text(localizations.deleteLessonConfirmation),
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

    final result = await _lessonCubit.deleteLessonAndReturn(
      sectionId: widget.section.id,
      lessonId: lesson.id,
    );

    if (!mounted) return;

    if (result) {
      setState(() {
        _lessons.removeWhere((l) => l.id == lesson.id);
        widget.onLessonsChanged?.call();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localizations.deleteLessonFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _toggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.folder_copy_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.section.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    "#${widget.section.order}",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(width: 6),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    splashRadius: 18,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'rename':
                          widget.onRename();
                          break;
                        case 'delete':
                          widget.onDelete();
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(localizations.renameSection),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              localizations.deleteSection,
                              style: TextStyle(color: Colors.red.shade400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            sizeCurve: Curves.easeInOut,
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 16),

                  if (_loadingLessons)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (_lessons.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        localizations.noLessonsYet,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary.withOpacity(.7),
                        ),
                      ),
                    )
                  else
                    ...(_lessons..sort((a, b) => a.order.compareTo(b.order)))
                        .map(
                          (lesson) => LessonTile(
                            title: lesson.title,
                            onEdit: () => _navigateToEditLesson(lesson),
                            onDelete: () => _confirmDeleteLesson(lesson),
                          ),
                        ),

                  const SizedBox(height: 12),
                  InkWell(
                    onTap: widget.onAddLesson,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            localizations.addLesson,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionSubRow(
                    icon: Icons.quiz_outlined,
                    label: localizations.questionsBank,
                    onEdit: widget.onManageQuestionsBank,
                  ),
                  const SizedBox(height: 8),
                  SectionSubRow(
                    icon: Icons.fact_check_outlined,
                    label: localizations.quiz,
                    onEdit: widget.onManageQuiz,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
