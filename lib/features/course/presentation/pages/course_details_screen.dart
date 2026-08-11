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
                  return const _CourseDetailsStatus(isLoading: true);
                }

                if (state is CourseDetailsError) {
                  return _CourseDetailsStatus(
                    message: state.errors.first,
                    accentColor: AppColors.error,
                  );
                }

                if (state is CourseAssetError) {
                  return _CourseDetailsStatus(
                    message: state.errors.first,
                    accentColor: AppColors.error,
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
                    return const _CourseDetailsStatus(isLoading: true);
                  }

                  final bool isFree = course.price == null || course.price == 0;
                  final bool showEnrollBar =
                      widget.mode == CourseDetailsMode.library;

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: showEnrollBar ? 112 : 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseHeader(
                          imageUrl: course.imagePath,
                          totalLessons: course.totalLessons,
                          totalDurationSeconds: course.totalDuration,
                        ),
                        const SizedBox(height: 26),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      course.title,
                                      style: AppTextStyles.h2.copyWith(
                                        color: AppColors.textPrimaryOf(context),
                                        fontSize: 26,
                                        height: 1.2,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.45,
                                      ),
                                    ),
                                  ),
                                  if (isFree) ...[
                                    const SizedBox(width: 10),
                                    _FreeCourseBadge(label: localizations.free),
                                  ],
                                ],
                              ),
                              if (course.tags.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: course.tags
                                      .map((tag) => CourseTag(text: tag))
                                      .toList(),
                                ),
                              ],
                              if ((course.demo?.name ?? '')
                                  .trim()
                                  .isNotEmpty) ...[
                                const SizedBox(height: 18),
                                _CourseProducerCard(
                                  label: localizations.producedBy,
                                  name: course.demo!.name,
                                ),
                              ],
                              const SizedBox(height: 28),
                              _CourseDetailsSectionTitle(
                                icon: Icons.subject_rounded,
                                title: localizations.aboutThisCourse,
                              ),
                              const SizedBox(height: 12),
                              _CourseDescriptionCard(
                                description: course.description,
                              ),
                              const SizedBox(height: 28),
                              _CourseDetailsSectionTitle(
                                icon: Icons.account_tree_outlined,
                                title: localizations.courseContent,
                              ),
                              const SizedBox(height: 14),
                              Container(
                                height: 480,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceOf(context),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: AppColors.borderOf(
                                      context,
                                    ).withValues(alpha: 0.82),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? 0.18
                                            : 0.05,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
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
                  tooltip: localizations.aiAssistantTitle,
                  backgroundColor: AppColors.primaryOf(context),
                  elevation: 5,
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
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              border: Border(
                top: BorderSide(
                  color: AppColors.borderOf(context).withValues(alpha: 0.76),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.26
                        : 0.09,
                  ),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
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
                        color: AppColors.success.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Text(
                        localizations.free,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                    )
                  else
                    Text(
                      '\$${course.price!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryOf(context),
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
                            : AppColors.buttonGradientOf(context),
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

class _CourseDetailsStatus extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final Color? accentColor;

  const _CourseDetailsStatus({
    this.isLoading = false,
    this.message,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primaryOf(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(22),
        constraints: const BoxConstraints(minWidth: 150, minHeight: 112),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.borderOf(context).withValues(alpha: 0.78),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: color,
                    strokeWidth: 2.6,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: color,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: Text(
                      message ?? '',
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryOf(context),
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FreeCourseBadge extends StatelessWidget {
  final String label;

  const _FreeCourseBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.success,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseProducerCard extends StatelessWidget {
  final String label;
  final String name;

  const _CourseProducerCard({required this.label, required this.name});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradientOf(context),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondaryOf(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w800,
                    height: 1.25,
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

class _CourseDetailsSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CourseDetailsSectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryOf(context).withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primaryOf(context), size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseDescriptionCard extends StatelessWidget {
  final String description;

  const _CourseDescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
      ),
      child: Text(
        description,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondaryOf(context),
          fontSize: 15,
          height: 1.65,
        ),
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
