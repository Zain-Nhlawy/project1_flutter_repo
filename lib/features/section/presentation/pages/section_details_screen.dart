import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
import 'package:project1/features/lesson/presentation/pages/lesson_details_screen.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_connector.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_tile.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_cubit.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_tile.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class SectionLessonsExpansionTile extends StatefulWidget {
  final SectionEntity section;
  final String demoId;
  final bool lessonsLocked;

  const SectionLessonsExpansionTile({
    super.key,
    required this.section,
    required this.demoId,
    this.lessonsLocked = false,
  });

  @override
  State<SectionLessonsExpansionTile> createState() =>
      _SectionLessonsExpansionTileState();
}

class _SectionLessonsExpansionTileState
    extends State<SectionLessonsExpansionTile> {
  late final LessonCubit _lessonCubit;
  late final ExamCubit _examCubit;

  List<LessonEntity> _lessons = [];

  bool _loading = false;
  bool _loadedOnce = false;
  bool _hasExam = false;

  String? _examId;

  @override
  void initState() {
    super.initState();

    _lessonCubit = getIt<LessonCubit>();
    _examCubit = getIt<ExamCubit>();
  }

  @override
  void dispose() {
    _lessonCubit.close();
    _examCubit.close();
    super.dispose();
  }

  Future<void> _fetchLessons() async {
    setState(() => _loading = true);

    final lessons = await _lessonCubit.getLessons(sectionId: widget.section.id);

    final exams = await _examCubit.fetchExams(sectionId: widget.section.id);

    if (!mounted) return;

    setState(() {
      _lessons = lessons..sort((a, b) => a.order.compareTo(b.order));

      _hasExam = exams?.data.isNotEmpty ?? false;

      _examId = _hasExam ? exams!.data.first.id : null;

      _loading = false;
      _loadedOnce = true;
    });
  }

  void _openLesson(LessonEntity lesson) {
    // Allow first 2 lessons of first section as free trial even if course is locked
    final isFirstSection = widget.section.order == 1;
    final isFreeTrialLesson =
        widget.lessonsLocked && isFirstSection && lesson.order <= 2;

    if (widget.lessonsLocked && !isFreeTrialLesson) {
      SnackbarTheme().newSnackBarInfo(
        context,
        AppLocalizations.of(context)!.enrollToWatchLesson,
      );
      return;
    }

    final index = _lessons.indexWhere((item) => item.id == lesson.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailsScreen(
          lessons: _lessons,
          initialIndex: index,
          demoId: widget.demoId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
          childrenPadding: const EdgeInsets.fromLTRB(13, 0, 13, 14),
          iconColor: primary,
          collapsedIconColor: AppColors.textSecondaryOf(context),
          leading: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradientOf(context),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.16),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.section.order.toString().padLeft(2, '0'),
              style: AppTextStyles.label.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          title: Text(
            widget.section.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          onExpansionChanged: (expanded) {
            if (expanded && !_loadedOnce) {
              _fetchLessons();
            }
          },
          children: [
            Divider(
              height: 1,
              color: AppColors.borderOf(context).withValues(alpha: 0.72),
            ),
            const SizedBox(height: 14),
            if (_loading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: primary,
                      strokeWidth: 2.4,
                    ),
                  ),
                ),
              )
            else if (_lessons.isEmpty)
              if (_hasExam && _examId != null)
                QuizTile(
                  examId: _examId!,
                  demoId: widget.demoId,
                  locked: widget.lessonsLocked,
                )
              else
                const SizedBox.shrink()
            else
              Column(
                children: [
                  ..._lessons.asMap().entries.map((entry) {
                    final index = entry.key;
                    final lesson = entry.value;
                    final isLast = index == _lessons.length - 1;
                    // First 2 lessons in first section are free trial (not locked)
                    final isFirstSection = widget.section.order == 1;
                    final isLockedLesson =
                        widget.lessonsLocked &&
                        (!isFirstSection || lesson.order > 2);

                    return LessonConnector(
                      num: index + 1,
                      isLast: isLast && !_hasExam,
                      showTopLine: index != 0,
                      hasExam: isLast && _hasExam,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _openLesson(lesson),
                            child: LessonTile(
                              num: index + 1,
                              title: lesson.title,
                              locked: isLockedLesson,
                            ),
                          ),
                          if (isLast && _hasExam && _examId != null)
                            QuizTile(
                              examId: _examId!,
                              demoId: widget.demoId,
                              locked: widget.lessonsLocked,
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
