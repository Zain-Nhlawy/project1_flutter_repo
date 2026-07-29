import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/widgets/custom_button.dart';
import 'package:project1/features/course/presentation/widgets/details/course_header.dart';
import 'package:project1/features/course/presentation/widgets/details/course_tabs.dart';
import 'package:project1/features/course/presentation/widgets/course_tag.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';


enum CourseDetailsMode {
  library,
  demo,
}

class CourseDetailsScreen extends StatefulWidget {
  final CourseDetailsMode mode;

  final String? courseId;
  final String? demoId;
  final String? assetId;

  const CourseDetailsScreen.fromLibrary({
    super.key,
    required this.courseId,
  })  : mode = CourseDetailsMode.library,
        demoId = null,
        assetId = null;

  const CourseDetailsScreen.fromDemo({
    super.key,
    required this.demoId,
    required this.assetId,
  })  : mode = CourseDetailsMode.demo,
        courseId = null;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();

    final cubit = context.read<CourseCubit>();

    if (widget.mode == CourseDetailsMode.library) {
      cubit.getCourse(widget.courseId!);
    } else {
      cubit.getDemoCourse(
        demoId: widget.demoId!,
        assetId: widget.assetId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.courseDetails,
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
      ),
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseDetailsLoading ||
              state is CourseAssetLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CourseDetailsError) {
            return Center(
              child: Text(
                state.errors.first,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is CourseAssetError) {
            return Center(
              child: Text(
                state.errors.first,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is CourseDetailsLoaded ||
              state is CourseAssetLoaded) {
            final course = state is CourseDetailsLoaded
                ? state.course
                : (state as CourseAssetLoaded).course;

            final bool isFree = course.price == null || course.price == 0;
            final bool showEnrollBar =
                widget.mode == CourseDetailsMode.library;

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: showEnrollBar ? 90 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CourseHeader(
                    imageUrl: course.imagePath,
                    totalLessons: course.totalLessons,
                    totalDurationSeconds: course.totalDuration,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                course.title,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isFree) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.green.shade400,
                                  ),
                                ),
                                child: Text(
                                  localizations.free,
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 15),

                        if (course.tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: course.tags
                                .map((tag) => CourseTag(text: tag))
                                .toList(),
                          ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                child: Icon(
                                  Icons.business,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.producedBy,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    course.demo?.name ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          localizations.aboutThisCourse,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          course.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.6,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          localizations.courseContent,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          height: 400,
                          child: BlocProvider(
                            create: (_) => getIt<SectionCubit>(),
                            child: CourseTabs(
                              courseId: course.id,
                              lessonsLocked:
                                  widget.mode == CourseDetailsMode.library,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (widget.mode != CourseDetailsMode.library) {
            return const SizedBox.shrink();
          }

          if (state is! CourseDetailsLoaded) {
            return const SizedBox.shrink();
          }

          final course = state.course;
          final bool isFree = course.price == null || course.price == 0;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  if (isFree)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade400),
                      ),
                      child: Text(
                        localizations.free,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    )
                  else
                    Text(
                      '\$${course.price!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: CustomButton(
                        text: localizations.enrollNow,
                        height: 46,
                        gradient: AppColors.buttonGradient,
                        expand: true,
                        onPressed: () {
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}