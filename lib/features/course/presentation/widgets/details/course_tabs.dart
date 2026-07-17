import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
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

  const CourseTabs({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseTabs> createState() => _CourseTabsState();
}

class _CourseTabsState extends State<CourseTabs> {
  @override
  void initState() {
    super.initState();
    context.read<SectionCubit>().getSections(courseId: widget.courseId);
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
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                          child: Text(AppLocalizations.of(context)!.noSectionsAvailable),
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
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _FaqItem(
                      question: "Who is this course designed for?",
                      answer:
                          "This course is designed for students, developers, and anyone interested in mastering data structures and algorithmic thinking.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "Do I need prior programming experience?",
                      answer:
                          "Basic programming knowledge is recommended, but the course starts from the fundamentals and gradually moves to advanced topics.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "Will I receive a certificate?",
                      answer:
                          "Yes, you will receive a certificate of completion after successfully finishing the course requirements.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "Can I access the course on mobile?",
                      answer:
                          "Absolutely. The course is optimized for desktop, tablet, and mobile devices.",
                      primary: primary,
                    ),
                    const SizedBox(height: 12),
                    _FaqItem(
                      question: "How long do I have access to the course?",
                      answer:
                          "You will have lifetime access to all lessons, updates, and supporting materials.",
                      primary: primary,
                    ),
                  ],
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
  State<_SectionLessonsExpansionTile> createState() => _SectionLessonsExpansionTileState();
}

class _SectionLessonsExpansionTileState extends State<_SectionLessonsExpansionTile> {
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
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else if (_lessons.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text("No lessons yet"),
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

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final Color primary;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          iconColor: primary,
          collapsedIconColor: primary,
          title: Text(
            question,
            style: TextStyle(fontWeight: FontWeight.w600, color: primary, fontSize: 15),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(color: Colors.grey.shade700, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}