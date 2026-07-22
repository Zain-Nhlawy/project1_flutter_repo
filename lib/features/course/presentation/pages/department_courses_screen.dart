import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/pages/demo_courses_screen.dart';

class DepartmentCoursesPage extends StatelessWidget {
  final String demoId;
  final bool canManage;

  const DepartmentCoursesPage({
    super.key,
    required this.demoId,
    required this.canManage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseCubit>()
        ..getDemoCourses(demoId),
      child: Stack(
        children: [
          // DemoCoursesScreen(
          //   demoId: demoId,
          //   showAppBar: true,
          // ),

          if (canManage)
            Positioned(
              right: 20,
              bottom: 30,
              child: FloatingActionButton(
                heroTag: 'edit_courses',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => getIt<CourseCubit>()
                          ..getDemoCourses(demoId),
                        child: DemoCoursesScreen(
                          demoId: demoId,
                          showAppBar: false,
                        ),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.edit_rounded),
              ),
            ),
        ],
      ),
    );
  }
}