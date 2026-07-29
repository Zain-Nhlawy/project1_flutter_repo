import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/presentation/widgets/library/library_courses_grid.dart';
import 'package:project1/features/course/presentation/widgets/library/library_filters.dart';
import 'package:project1/features/course/presentation/widgets/library/library_header.dart';
import 'package:project1/features/course/presentation/widgets/library/library_result_header.dart';
import 'package:project1/features/course/presentation/widgets/library/library_search_bar.dart';
import 'package:project1/l10n/app_localizations.dart';

class PublicLibraryScreen extends StatelessWidget {
  const PublicLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<CourseCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<TagsCubit>(),
        ),
      ],
      child: const _PublicLibraryView(),
    );
  }
}

class _PublicLibraryView extends StatefulWidget {
  const _PublicLibraryView();

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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          localizations.publicLibrary,
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
      body: Column(
        children: [
          const LibraryHeader(),
          LibrarySearchBar(
            onChanged: _search,
          ),
          LibraryFilters(
            onTagSelected: _filterByTags,
          ),
          Expanded(
            child: BlocBuilder<CourseCubit, CourseState>(
              builder: (context, state) {
                if (state is PublicCoursesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PublicCoursesError) {
                  return Center(
                    child: Text(
                      state.errors.first,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                if (state is PublicCoursesLoaded) {
                  return Column(
                    children: [
                      LibraryResultHeader(
                        count: state.courses.length,
                      ),
                      Expanded(
                        child: LibraryCoursesGrid(
                          courses: state.courses,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}