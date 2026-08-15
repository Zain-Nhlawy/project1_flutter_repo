import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/domain/entities/department_course_entity.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/department_course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/department_course_state.dart';
import 'package:project1/features/course/presentation/pages/course_details_screen.dart';
import 'package:project1/features/course/presentation/pages/demo_courses_screen.dart';
import 'package:project1/features/course/presentation/widgets/details/course_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class DepartmentCoursesPage extends StatelessWidget {
  final String demoId;
  final String departmentId;
  final bool canManage;

  const DepartmentCoursesPage({
    super.key,
    required this.demoId,
    required this.departmentId,
    required this.canManage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (_) => getIt<DepartmentCourseCubit>()
        ..getDepartmentCourses(
          demoId: demoId,
          departmentId: departmentId,
        ),
    ),
    BlocProvider(
      create: (_) => getIt<CourseCubit>()
        ..getDemoCourses(demoId),
    ),
  ],
  child: _DepartmentCoursesView(
        demoId: demoId,
        departmentId: departmentId,
        canManage: canManage,
      ),
    );
  }
}

class _DepartmentCoursesView extends StatelessWidget {
  final String demoId;
  final String departmentId;
  final bool canManage;

  const _DepartmentCoursesView({
    required this.demoId,
    required this.departmentId,
    required this.canManage,
  });

  void _refresh(BuildContext context) {
    context.read<DepartmentCourseCubit>().getDepartmentCourses(
          demoId: demoId,
          departmentId: departmentId,
        );
  }

  Future<void> _openManageScreen(
  BuildContext context,
  List<DepartmentCourseEntity> currentCourses,
) async {
  final assetIdToDepartmentCourseId = <String, String>{
    for (final dc in currentCourses) dc.asset.id: dc.id,
  };

  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => getIt<CourseCubit>()
          ..getDemoCourses(demoId),
        child: DemoCoursesScreen(
          demoId: demoId,
          showAppBar: false,
          departmentId: departmentId,
          initialAssetIdToDepartmentCourseId:
              assetIdToDepartmentCourseId,
        ),
      ),
    ),
  );

  if (result == true && context.mounted) {
    _refresh(context);
  }
}

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: BlocConsumer<DepartmentCourseCubit, DepartmentCourseState>(
        listener: (context, state) {
          if (state is DepartmentCourseActionSuccess) {
            SnackbarTheme().newSnackBarSuccess(context, state.message);
            _refresh(context);
          } else if (state is DepartmentCourseError) {
            SnackbarTheme().newSnackBarError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is DepartmentCourseLoading || state is DepartmentCourseInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DepartmentCourseError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 40, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _refresh(context),
                      child: Text(localizations.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          List<DepartmentCourseEntity> courses = [];
          if (state is DepartmentCourseLoaded) {
            courses = state.courses;
          }

          return Stack(
            children: [
              if (courses.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 48,
                          color: AppColors.textSecondaryOf(context).withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          localizations.noCoursesInDepartment,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: courses.map((dc) {
                    final course = dc.asset.course;
                    return Stack(
                      children: [
                        CourseCard(
                          id: course.id,
                          title: course.title,
                          companyName: '',
                          imageUrl: course.imagePath ?? '',
                          price: course.price,
                          description: course.description,
                          visibility: course.visibility,
                          isPublished: course.isPublished,
                          mode: CourseCardMode.demoView,
                          onSeeMore: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => getIt<CourseCubit>(),
                                  child: CourseDetailsScreen.fromDemo(
                                    demoId: demoId,
                                    assetId: dc.asset.id,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              if (canManage)
                Positioned(
                  right: 20,
                  bottom: 30,
                  child: FloatingActionButton(
                    heroTag: 'edit_courses',
                    backgroundColor: AppColors.primaryOf(context),
                    onPressed: () => _openManageScreen(context, courses),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}