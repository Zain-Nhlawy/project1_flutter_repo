import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/domain/use_case/create_department_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/delete_department_course_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/pages/course_details_screen.dart';
import 'package:project1/features/course/presentation/widgets/details/course_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoCoursesScreen extends StatefulWidget {
  final String demoId;
  final bool showAppBar;
  final String? departmentId;
  final Map<String, String> initialAssetIdToDepartmentCourseId;

  const DemoCoursesScreen({
    super.key,
    required this.demoId,
    this.showAppBar = false,
    this.departmentId,
    this.initialAssetIdToDepartmentCourseId = const {},
  });

  @override
  State<DemoCoursesScreen> createState() => _DemoCoursesScreenState();
}

class _DemoCoursesScreenState extends State<DemoCoursesScreen> {
  late Set<String> _selectedAssetIds;
  late Map<String, String> _assetIdToDepartmentCourseId;
  final Set<String> _pendingAssetIds = <String>{};

  late final CreateDepartmentCourseUseCase _createUseCase;
  late final DeleteDepartmentCourseUseCase _deleteUseCase;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _selectedAssetIds = {...widget.initialAssetIdToDepartmentCourseId.keys};
    _assetIdToDepartmentCourseId = {...widget.initialAssetIdToDepartmentCourseId};
    _createUseCase = getIt<CreateDepartmentCourseUseCase>();
    _deleteUseCase = getIt<DeleteDepartmentCourseUseCase>();
  }

  bool get _isSelectionMode => widget.departmentId != null;

  Future<void> _toggleCourse(String assetId) async {
  if (widget.departmentId == null) return;
  if (_pendingAssetIds.contains(assetId)) return;
  final isSelected = _selectedAssetIds.contains(assetId);
  setState(() {
    _pendingAssetIds.add(assetId);
    if (isSelected) {
      _selectedAssetIds.remove(assetId);
    } else {
      _selectedAssetIds.add(assetId);
    }
  });


  if (isSelected) {
    final departmentCourseId =
        _assetIdToDepartmentCourseId[assetId];
    if (departmentCourseId == null) {
      setState(() {
        _pendingAssetIds.remove(assetId);
        _selectedAssetIds.add(assetId);
      });
      return;
    }
    final result = await _deleteUseCase(
      demoId: widget.demoId,
      departmentId: widget.departmentId!,
      departmentCourseId: departmentCourseId,
    );
    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _selectedAssetIds.add(assetId);
        });
        SnackbarTheme()
            .newSnackBarError(context, failure.message);
      },
      (_) {
        _assetIdToDepartmentCourseId.remove(assetId);
        _hasChanges = true;
      },
    );
  }
  else {
    final result = await _createUseCase(
      demoId: widget.demoId,
      departmentId: widget.departmentId!,
      assetId: assetId,
    );
    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _selectedAssetIds.remove(assetId);
        });
        SnackbarTheme()
            .newSnackBarError(context, failure.message);
      },
      (departmentCourse) {
        _assetIdToDepartmentCourseId[assetId] =
            departmentCourse.id;
        _hasChanges = true;
      },
    );
  }
  if (mounted) {
    setState(() {
      _pendingAssetIds.remove(assetId);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final body = BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CourseLoaded) {
          final demoCourses =
              state.courses.where((course) => course.isPublished).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
            children: [
              Text(
                localizations.demoCourses,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                localizations.demoCoursesDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryOf(context).withOpacity(0.8),
                ),
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
                      Icons.auto_stories_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${demoCourses.length} ${localizations.availableCourses}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...demoCourses.map((course) {
                final assetId = course.assetId;
                final isSelected =
                    assetId != null && _selectedAssetIds.contains(assetId);
                final isPending =
                    assetId != null && _pendingAssetIds.contains(assetId);

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
                  mode: widget.showAppBar
                      ? CourseCardMode.demoView
                      : CourseCardMode.demoSelection,
                  isSelected: isSelected,
                  onSelect: (!widget.showAppBar && _isSelectionMode && assetId != null && !isPending)
                      ? () => _toggleCourse(assetId)
                      : null,
                  onSeeMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => getIt<CourseCubit>(),
                          child: CourseDetailsScreen.fromDemo(
                            demoId: course.demoId!,
                            assetId: course.assetId!,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        }

        if (state is CourseError) {
          return Center(child: Text(state.errors.first));
        }

        return const SizedBox();
      },
    );

    if (widget.showAppBar) {
      return body;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _hasChanges);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context, _hasChanges),
          ),
          title: Text(
            localizations.demoCourses,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          ),
        ),
        body: body,
      ),
    );
  }
}