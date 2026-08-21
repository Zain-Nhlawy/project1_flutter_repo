import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
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
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.backgroundOf(context),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.borderOf(context).withValues(alpha: 0.70),
              ),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: AppColors.buttonGradientOf(context),
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondaryOf(context),
              labelStyle: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelStyle: AppTextStyles.label.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  height: 42,
                  icon: const Icon(Icons.play_lesson_outlined, size: 18),
                  text: localizations.lessons,
                  iconMargin: const EdgeInsets.only(bottom: 2),
                ),
                Tab(
                  height: 42,
                  icon: const Icon(Icons.help_outline_rounded, size: 18),
                  text: localizations.faq,
                  iconMargin: const EdgeInsets.only(bottom: 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              children: [
                BlocBuilder<SectionCubit, SectionState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return AppSkeletonizer(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 90),
                          itemCount: 4,
                          itemBuilder: (context, index) =>
                              SectionLessonsExpansionTile(
                                section: dummySection,
                                demoId: widget.demoId,
                                lessonsLocked: widget.lessonsLocked,
                              ),
                        ),
                      );
                    }

                    if (state.errors != null && state.errors!.isNotEmpty) {
                      return _CourseTabStatus(
                        message: state.errors!.first,
                        isError: true,
                      );
                    }

                    if (state.sections.isEmpty) {
                      return _CourseTabStatus(
                        icon: Icons.account_tree_outlined,
                        message: localizations.noSectionsAvailable,
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 90),
                      itemCount: state.sections.length,
                      itemBuilder: (context, index) {
                        return SectionLessonsExpansionTile(
                          section: state.sections[index],
                          demoId: widget.demoId,
                          lessonsLocked: widget.lessonsLocked,
                        );
                      },
                    );
                  },
                ),
                BlocProvider.value(
                  value: _faqCubit,
                  child: BlocBuilder<CourseFaqCubit, CourseFaqState>(
                    builder: (context, state) {
                      if (state is CourseFaqLoading ||
                          state is CourseFaqInitial) {
                        return AppSkeletonizer(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
                            itemCount: 4,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) => FaqItem(
                              question: dummyCourseFaq.question,
                              answer: dummyCourseFaq.answer,
                            ),
                          ),
                        );
                      }

                      if (state is CourseFaqError) {
                        return _CourseTabStatus(
                          message: state.message,
                          isError: true,
                        );
                      }

                      final faqs = state is CourseFaqLoaded
                          ? state.faqs
                          : <CourseFaqEntity>[];

                      if (faqs.isEmpty) {
                        return _CourseTabStatus(
                          icon: Icons.question_answer_outlined,
                          message: localizations.noFaqAvailable,
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
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

class _CourseTabStatus extends StatelessWidget {
  final bool isError;
  final IconData icon;
  final String? message;

  const _CourseTabStatus({
    this.isError = false,
    this.icon = Icons.info_outline_rounded,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.error : AppColors.primaryOf(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(
                isError ? Icons.error_outline_rounded : icon,
                color: color,
                size: 25,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryOf(context),
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
