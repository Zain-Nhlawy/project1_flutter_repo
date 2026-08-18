import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/upload_photo/presentation/cubit/upload_photo_course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/pages/course_management_screen.dart';
import 'package:project1/features/course/presentation/pages/create_course_screen.dart';
import 'package:project1/features/course/presentation/widgets/details/course_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursesInProgressScreen extends StatelessWidget {
  final String demoId;
  const CoursesInProgressScreen({super.key, required this.demoId});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<CourseCubit>()),
                  BlocProvider(create: (_) => getIt<TagsCubit>()..fetchTags()),
                  BlocProvider(create: (_) => getIt<UploadPhotoCourseCubit>()),
                ],
                child: CreateCourseScreen(demoId: demoId),
              ),
            ),
          );

          if (result == true && context.mounted) {
            context.read<CourseCubit>().getDemoCourses(demoId);
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          localizations.createCourse,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CourseError) {
            return Center(
              child: Text(
                state.errors.isNotEmpty ? state.errors.first : '',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final courses = state is CourseLoaded ? state.courses : <dynamic>[];
          final ongoingCourses =
              courses.where((course) => !course.isPublished).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
            children: [
              Text(
                localizations.ongoingCourses,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                localizations.manageCoursesDescription,
                style: TextStyle(fontSize: 14, color:AppColors.textSecondaryOf(
                    context,
                  ).withValues(alpha: 0.8),),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${ongoingCourses.length} ${localizations.coursesInProgress}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
                ...ongoingCourses.map((course) {
                  return CourseCard(
                    id: course.id,
                    title: course.title,
                    companyName: course.demo?.name ?? '',
                    imageUrl: course.imagePath,
                    price: course.price,
                    description: course.description,
                    tags: course.tags,
                    visibility: course.visibility,
                    isPublished: course.isPublished,
                    mode: CourseCardMode.ongoing,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<CourseCubit>(),
                              ),
                              BlocProvider(
                                create: (_) => getIt<TagsCubit>()..fetchTags(),
                              ),
                              BlocProvider(
                                create: (_) => getIt<UploadPhotoCourseCubit>(),
                              ),
                            ],
                            child: CourseManagementScreen(
                              courseId: course.id,
                              assetId: course.assetId!,
                              demoId: demoId,
                              title: course.title,
                              company: course.demo?.name ?? '',
                              image: course.imagePath,
                              lessons: course.totalLessons,
                              duration: course.totalDuration,
                              description: course.description,
                              price: course.price,
                              visibility: course.visibility,
                              tagIds: course.tagIds,
                            ),
                          ),
                        ),
                      );
                      if (result == true && context.mounted) {
                        context.read<CourseCubit>().getDemoCourses(demoId);
                      }
                    },
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}