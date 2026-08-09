import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/pages/course_details_screen.dart';
import 'package:project1/features/course/presentation/widgets/details/course_card.dart';

class LibraryCoursesGrid extends StatelessWidget {
  final List<CourseEntity> courses;
  final String userDemoId;

  const LibraryCoursesGrid({
    super.key,
    required this.courses,
    required this.userDemoId,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.crossAxisExtent;
        final contentWidth = viewportWidth > 920 ? 920.0 : viewportWidth;
        final outerPadding = viewportWidth > 920
            ? (viewportWidth - 920) / 2
            : 0.0;
        final contentPadding = contentWidth >= 700 ? 56.0 : 12.0;

        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            outerPadding + contentPadding,
            10,
            outerPadding + contentPadding,
            40,
          ),
          sliver: SliverList.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                id: course.id,
                title: course.title,
                companyName: course.demo?.name ?? '',
                imageUrl: course.imagePath,
                price: course.price,
                description: course.description,
                tags: course.tags,
                visibility: course.visibility,
                mode: CourseCardMode.library,
                onSeeMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => getIt<CourseCubit>(),
                        child: CourseDetailsScreen.fromLibrary(
                          courseId: course.id,
                          userDemoId: userDemoId,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
