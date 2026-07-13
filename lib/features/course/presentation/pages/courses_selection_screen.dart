import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/pages/courses_inProgress_screen.dart';
import 'package:project1/features/course/presentation/pages/demo_courses_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursesSelectionScreen extends StatefulWidget {
  final String demoId;

  const CoursesSelectionScreen({
    super.key,
    required this.demoId,
  });

  @override
  State<CoursesSelectionScreen> createState() =>
      _CoursesSelectionScreenState();
}

class _CoursesSelectionScreenState
    extends State<CoursesSelectionScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<CourseCubit>()
        ..getDemoCourses(widget.demoId),

      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),

          title: Text(
            localizations.courses,
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

          bottom: TabBar(
            controller: _tabController,

            labelColor: Colors.white,

            unselectedLabelColor: Colors.white70,

            tabs: [

              Tab(
                text: localizations.demoCourses,
              ),

              Tab(
                text: localizations.ongoingCourses,
              ),

            ],
          ),
        ),


        body: TabBarView(
          controller: _tabController,

          children: [

            DemoCoursesScreen(
              demoId: widget.demoId,
            ),

            CoursesInProgressScreen(
              demoId: widget.demoId,
            ),

          ],
        ),
      ),
    );
  }
}