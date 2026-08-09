import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/presentation/widgets/library/library_courses_grid.dart';
import 'package:project1/features/course/presentation/widgets/library/library_filters.dart';
import 'package:project1/features/course/presentation/widgets/library/library_result_header.dart';
import 'package:project1/features/course/presentation/widgets/library/library_search_bar.dart';
import 'package:project1/l10n/app_localizations.dart';

class PublicLibraryScreen extends StatelessWidget {
  final String demoId;

  const PublicLibraryScreen({super.key, required this.demoId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CourseCubit>()),
        BlocProvider(create: (_) => getIt<TagsCubit>()),
      ],
      child: _PublicLibraryView(demoId: demoId),
    );
  }
}

class _PublicLibraryView extends StatefulWidget {
  final String demoId;

  const _PublicLibraryView({required this.demoId});

  @override
  State<_PublicLibraryView> createState() => _PublicLibraryViewState();
}

class _PublicLibraryViewState extends State<_PublicLibraryView> {
  String search = "";
  List<String>? selectedTagIds;

  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().getCourses();
    context.read<TagsCubit>().fetchTags();
  }

  void _search(String value) {
    search = value;
    context.read<CourseCubit>().getCourses(
      search: value,
      tagIds: selectedTagIds,
    );
  }

  void _filterByTags(List<String>? tagIds) {
    final cleanedTagIds = tagIds?.map((id) => id.trim()).toList();
    selectedTagIds = cleanedTagIds;
    context.read<CourseCubit>().getCourses(
      search: search,
      tagIds: cleanedTagIds,
    );
  }

  void _retry() {
    context.read<CourseCubit>().getCourses(
      search: search,
      tagIds: selectedTagIds,
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
          _LibraryPageHeader(
            topPadding: topPadding,
            title: localizations.publicLibrary,
            subtitle: localizations.publicLibraryOptionDesc,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    LibrarySearchBar(onChanged: _search),
                    LibraryFilters(onTagSelected: _filterByTags),
                    Expanded(
                      child: BlocBuilder<CourseCubit, CourseState>(
                        builder: (context, state) {
                          if (state is PublicCoursesLoading) {
                            return const _LibraryLoadingState();
                          }

                          if (state is PublicCoursesError) {
                            return _LibraryErrorState(
                              message: state.errors.isEmpty
                                  ? localizations.somethingWentWrong
                                  : state.errors.first,
                              retryLabel: localizations.retry,
                              onRetry: _retry,
                            );
                          }

                          if (state is PublicCoursesLoaded) {
                            return Column(
                              children: [
                                LibraryResultHeader(
                                  count: state.courses.length,
                                ),
                                Expanded(
                                  child: state.courses.isEmpty
                                      ? _LibraryEmptyState(
                                          title: localizations.noCoursesFound,
                                          subtitle: localizations
                                              .publicLibraryOptionDesc,
                                        )
                                      : LibraryCoursesGrid(
                                          courses: state.courses,
                                          userDemoId: widget.demoId,
                                        ),
                                ),
                              ],
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryPageHeader extends StatelessWidget {
  final double topPadding;
  final String title;
  final String subtitle;

  const _LibraryPageHeader({
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

class _LibraryLoadingState extends StatelessWidget {
  const _LibraryLoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primaryOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryErrorState extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _LibraryErrorState({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 38,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimaryOf(context),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryOf(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 19),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _LibraryEmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: AppColors.headerGradientOf(context),
                shape: BoxShape.circle,
                boxShadow: [AppColors.primaryShadowOf(context)],
              ),
              child: const Icon(
                Icons.auto_stories_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimaryOf(context),
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryOf(context),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
