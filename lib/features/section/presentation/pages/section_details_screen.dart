import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
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
  final String? demoId;
  final bool lessonsLocked;

  const SectionLessonsExpansionTile({
    required this.section,
    this.demoId,
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
    _lessonCubit = getIt();
    _examCubit = getIt();
  }

  @override
  void dispose() {
    _lessonCubit.close();
    _examCubit.close();
    super.dispose();
  }

  Future<void> _fetchLessons() async {
    setState(() => _loading = true);

    final lessons = await _lessonCubit.getLessons(
      sectionId: widget.section.id,
    );

    final exams = await _examCubit.fetchExams(
      sectionId: widget.section.id,
    );

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
    if (widget.lessonsLocked) {
      SnackbarTheme().newSnackBarInfo(
        context,
        AppLocalizations.of(context)!.enrollToWatchLesson,
      );
      return;
    }

    final index = _lessons.indexWhere((l) => l.id == lesson.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailsScreen(
          lessons: _lessons,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.section.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onExpansionChanged: (expanded) {
        if (expanded && !_loadedOnce) {
          _fetchLessons();
        }
      },
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_lessons.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              AppLocalizations.of(context)!.noLessonsYet,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                ..._lessons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lesson = entry.value;
                  final isLast = index == _lessons.length - 1;

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
                            locked: widget.lessonsLocked,
                          ),
                        ),
                        if (isLast && _hasExam && _examId != null)
                          QuizTile(
                            examId: _examId!,
                            demoId: widget.demoId!,
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}