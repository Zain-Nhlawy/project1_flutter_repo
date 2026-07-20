import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/faq/domain/entities/course_faq_entity.dart';
import 'package:project1/features/faq/presentation/cubit/course_faq_cubit.dart';
import 'package:project1/features/faq/presentation/cubit/course_faq_state.dart';
import 'package:project1/features/faq/presentation/widgets/details/Faq_item.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/presentation/cubit/lesson_cubit.dart';
import 'package:project1/features/lesson/presentation/pages/lesson_details_screen.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_connector.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_tile.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';
import 'package:project1/features/section/presentation/cubit/section_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseTabs extends StatefulWidget {
  final String courseId;

  const CourseTabs({super.key, required this.courseId});

  @override
  State<CourseTabs> createState() => _CourseTabsState();
}

class _CourseTabsState extends State<CourseTabs> {
  late final CourseFaqCubit _faqCubit;

  @override
  void initState() {
    super.initState();
    context.read<SectionCubit>().getSections(courseId: widget.courseId);
    _faqCubit = getIt<CourseFaqCubit>()
      ..getCourseFaqs(courseId: widget.courseId);
  }

  @override
  void dispose() {
    _faqCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.lessons),
              Tab(text: AppLocalizations.of(context)!.faq),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: BlocBuilder<SectionCubit, SectionState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.errors != null && state.errors!.isNotEmpty) {
                        return Center(
                          child: Text(
                            state.errors!.first,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state.sections.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.noSectionsAvailable,
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        children: state.sections.map((section) {
                          return Column(
                            children: [
                              _SectionLessonsExpansionTile(section: section),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                BlocProvider.value(
                  value: _faqCubit,
                  child: BlocBuilder<CourseFaqCubit, CourseFaqState>(
                    builder: (context, state) {
                      if (state is CourseFaqLoading ||
                          state is CourseFaqInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is CourseFaqError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final faqs = state is CourseFaqLoaded
                          ? state.faqs
                          : <CourseFaqEntity>[];

                      if (faqs.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.noFaqAvailable,
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: faqs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final faq = faqs[index];
                          return FaqItem(
                            question: faq.question,
                            answer: faq.answer,
                          );
                        },
                      );
                    },
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

class _SectionLessonsExpansionTile extends StatefulWidget {
  final SectionEntity section;

  const _SectionLessonsExpansionTile({required this.section});

  @override
  State<_SectionLessonsExpansionTile> createState() =>
      _SectionLessonsExpansionTileState();
}

class _SectionLessonsExpansionTileState
    extends State<_SectionLessonsExpansionTile> {
  late final LessonCubit _lessonCubit;
  List<LessonEntity> _lessons = [];
  bool _loading = false;
  bool _loadedOnce = false;

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
    setState(() => _loading = true);

    final lessons = await _lessonCubit.getLessons(sectionId: widget.section.id);

    if (!mounted) return;
    setState(() {
      _lessons = lessons..sort((a, b) => a.order.compareTo(b.order));
      _loading = false;
      _loadedOnce = true;
    });
  }

  void _openLesson(LessonEntity lesson) {
    final index = _lessons.indexWhere((l) => l.id == lesson.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LessonDetailsScreen(lessons: _lessons, initialIndex: index),
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
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
              children: _lessons.asMap().entries.map((entry) {
                final index = entry.key;
                final lesson = entry.value;
                final isLast = index == _lessons.length - 1;

                return LessonConnector(
                  num: index + 1,
                  isLast: isLast,
                  showTopLine: index != 0,
                  child: GestureDetector(
                    onTap: () => _openLesson(lesson),
                    child: LessonTile(num: index + 1, title: lesson.title),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
