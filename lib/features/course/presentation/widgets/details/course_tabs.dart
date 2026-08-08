import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/faq/domain/entities/course_faq_entity.dart';
import 'package:project1/features/faq/presentation/cubit/course_faq_cubit.dart';
import 'package:project1/features/faq/presentation/cubit/course_faq_state.dart';
import 'package:project1/features/faq/presentation/widgets/details/Faq_item.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';
import 'package:project1/features/section/presentation/cubit/section_state.dart';
import 'package:project1/features/section/presentation/pages/section_details_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseTabs extends StatefulWidget {
  final String demoId;
  final String courseId;
  final bool lessonsLocked;

  const CourseTabs({
    super.key,
    required this.demoId,
    required this.courseId,
    this.lessonsLocked = false,
  });

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
                        children: state.sections.asMap().entries.map((entry) {
                        final index = entry.key;
                        final section = entry.value;
                        final isLastSection = index == state.sections.length - 1;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: isLastSection ? 50 : 0,
                            ),
                            child: Column(
                              children: [
                                SectionLessonsExpansionTile(
                                  section: section,
                                  demoId: widget.demoId,
                                  lessonsLocked: widget.lessonsLocked,
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
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

