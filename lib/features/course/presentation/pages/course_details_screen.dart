import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/data/data_sources/payment_remote_data_source.dart';
import 'package:project1/features/course/domain/use_case/get_demo_courses_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/cubit/payment_cubit.dart';
import 'package:project1/features/course/presentation/pages/checkout_webview_screen.dart';
import 'package:project1/features/course/presentation/pages/course_purchase_success_screen.dart';
import 'package:project1/features/course/presentation/widgets/custom_button.dart';
import 'package:project1/features/course/presentation/widgets/details/course_header.dart';
import 'package:project1/features/course/presentation/widgets/details/course_tabs.dart';
import 'package:project1/features/course/presentation/widgets/course_tag.dart';
import 'package:project1/features/rag/presentation/cubit/rag_cubit.dart';
import 'package:project1/features/rag/presentation/pages/rag_screen.dart';
import 'package:project1/features/section/presentation/cubit/section_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

enum CourseDetailsMode { library, demo }

class CourseDetailsScreen extends StatefulWidget {
  final CourseDetailsMode mode;

  final String? courseId;
  final String? demoId;
  final String? assetId;
  final String? userDemoId;

  const CourseDetailsScreen.fromLibrary({
    super.key,
    required this.courseId,
    required this.userDemoId,
  }) : mode = CourseDetailsMode.library,
       demoId = null,
       assetId = null;

  const CourseDetailsScreen.fromDemo({
    super.key,
    required this.demoId,
    required this.assetId,
  }) : mode = CourseDetailsMode.demo,
       courseId = null,
       userDemoId = null;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool _checkingOwnership = false;
  bool _ownershipChecked = false;
  bool _alreadyOwned = false;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<CourseCubit>();

    if (widget.mode == CourseDetailsMode.library) {
      cubit.getCourse(widget.courseId!);
    } else {
      cubit.getDemoCourse(demoId: widget.demoId!, assetId: widget.assetId!);
    }
  }

  Future<void> _checkIfAlreadyOwned(String demoId, String courseId) async {
    if (_checkingOwnership || _ownershipChecked) return;
    _checkingOwnership = true;

    try {
      final demoCoursesUseCase = getIt<GetDemoCoursesUseCase>();
      final result = await demoCoursesUseCase(demoId);

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _alreadyOwned = false;
              _checkingOwnership = false;
              _ownershipChecked = true;
            });
          }
        },
        (demoCourses) {
          if (mounted) {
            setState(() {
              _alreadyOwned = demoCourses.any((c) => c.id == courseId);
              _checkingOwnership = false;
              _ownershipChecked = true;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _alreadyOwned = false;
          _checkingOwnership = false;
          _ownershipChecked = true;
        });
      }
    }
  }

  Future<void> _handleEnroll(dynamic course) async {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final session = await getIt<PaymentRemoteDataSource>().checkoutCourse(
        demoId: widget.userDemoId ?? '',
        courseId: course.id,
      );

      if (!context.mounted) return;
      Navigator.pop(context);

      final bool isFreeCourse = course.price == null || course.price == 0;
      final bool hasCheckoutUrl = session.url.isNotEmpty;

      if (isFreeCourse && !hasCheckoutUrl) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CoursePurchaseSuccessScreen(courseTitle: course.title),
          ),
        );
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PaymentCubit>(),
            child: CheckoutWebViewScreen(
              checkoutUrl: session.url,
              courseTitle: course.title,
            ),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      SnackbarTheme().newSnackBarError(context, localizations.checkoutError);
    }
  }

  void _openRagScreen(String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<RagCubit>(),
          child: RagScreen(courseId: courseId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: Column(
        children: [
          _CourseDetailsPageHeader(
            topPadding: topPadding,
            title: localizations.courseDetails,
            subtitle: localizations.aboutThisCourse,
          ),
          Expanded(
            child: BlocBuilder<CourseCubit, CourseState>(
              builder: (context, state) {
                if (state is CourseDetailsLoading ||
                    state is CourseAssetLoading) {
                  return const Center(child: CircularProgressIndicator());
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

                  final bool needsOwnershipCheck =
                      widget.mode == CourseDetailsMode.library &&
                      widget.userDemoId != null;

                  if (needsOwnershipCheck && !_ownershipChecked) {
                    if (!_checkingOwnership) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _checkIfAlreadyOwned(widget.userDemoId!, course.id);
                      });
                    }
                    return const Center(child: CircularProgressIndicator());
                  }

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
                                    color: Colors.grey.withValues(alpha: 0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.1),
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
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
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
                                    demoId: widget.demoId ?? '',
                                    courseId: course.id,
                                    lessonsLocked:
                                        widget.mode ==
                                            CourseDetailsMode.library &&
                                        !_alreadyOwned,
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
          ),
        ],
      ),
      floatingActionButton: widget.mode == CourseDetailsMode.demo
          ? BlocBuilder<CourseCubit, CourseState>(
              builder: (context, state) {
                if (state is! CourseAssetLoaded) {
                  return const SizedBox.shrink();
                }
                final course = state.course;
                return FloatingActionButton(
                  heroTag: 'rag_fab',
                  backgroundColor: AppColors.primary,
                  onPressed: () => _openRagScreen(course.id),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (widget.mode != CourseDetailsMode.library) {
            return const SizedBox.shrink();
          }

          if (state is! CourseDetailsLoaded) {
            return const SizedBox.shrink();
          }

          if (!_ownershipChecked) {
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
                  color: Colors.black.withValues(alpha: 0.08),
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
                        text: _alreadyOwned
                            ? localizations.alreadyEnrolled
                            : localizations.enrollNow,
                        height: 46,
                        gradient: _alreadyOwned
                            ? LinearGradient(
                                colors: [
                                  Colors.grey.shade400,
                                  Colors.grey.shade500,
                                ],
                              )
                            : AppColors.buttonGradient,
                        expand: true,
                        onPressed: _alreadyOwned
                            ? null
                            : () => _handleEnroll(course),
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

class _CourseDetailsPageHeader extends StatelessWidget {
  final double topPadding;
  final String title;
  final String subtitle;

  const _CourseDetailsPageHeader({
    required this.topPadding,
    required this.title,
    required this.subtitle,
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
          bottom: 18,
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
          ],
        ),
      ),
    );
  }
}
