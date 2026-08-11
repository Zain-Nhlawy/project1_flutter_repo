import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/pages/courses_inProgress_screen.dart';
import 'package:project1/features/course/presentation/pages/demo_courses_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursesSelectionScreen extends StatefulWidget {
  final String demoId;

  const CoursesSelectionScreen({super.key, required this.demoId});

  @override
  State<CoursesSelectionScreen> createState() => _CoursesSelectionScreenState();
}

class _CoursesSelectionScreenState extends State<CoursesSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;

    return BlocProvider(
      create: (_) => getIt<CourseCubit>()..getDemoCourses(widget.demoId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        body: Column(
          children: [
            _CoursesHeader(
              topPadding: topPadding,
              title: localizations.courses,
              subtitle: localizations.coursesOptionDesc,
              tabController: _tabController,
              firstTab: localizations.demoCourses,
              secondTab: localizations.ongoingCourses,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  DemoCoursesScreen(demoId: widget.demoId, showAppBar: true),
                  CoursesInProgressScreen(demoId: widget.demoId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoursesHeader extends StatelessWidget {
  final double topPadding;
  final String title;
  final String subtitle;
  final TabController tabController;
  final String firstTab;
  final String secondTab;

  const _CoursesHeader({
    required this.topPadding,
    required this.title,
    required this.subtitle,
    required this.tabController,
    required this.firstTab,
    required this.secondTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding > 0 ? topPadding + 8 : 32,
          left: 20,
          right: 20,
          bottom: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 38,
                      height: 38,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.surface,
                      size: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.surface.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                indicator: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(11),
                ),
                labelColor: AppColors.surface,
                unselectedLabelColor: AppColors.surface.withValues(alpha: 0.7),
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: firstTab),
                  Tab(text: secondTab),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
