import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/course/domain/use_case/create_department_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/delete_department_course_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/pages/course_details_screen.dart';
import 'package:project1/features/course/presentation/widgets/details/course_card.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/course/domain/use_case/update_course_usecase.dart';
import 'package:project1/features/course/presentation/widgets/details/course_edit_dialog.dart';

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

  late final CreateDepartmentCourseUseCase _createUseCase;
  late final DeleteDepartmentCourseUseCase _deleteUseCase;
  late final UpdateCourseUseCase _updateUseCase;

  bool _isSaving = false;
  bool _hasSavedChanges = false;

  @override
  void initState() {
    super.initState();
    _selectedAssetIds = {...widget.initialAssetIdToDepartmentCourseId.keys};
    _assetIdToDepartmentCourseId = {
      ...widget.initialAssetIdToDepartmentCourseId,
    };
    _createUseCase = getIt<CreateDepartmentCourseUseCase>();
    _deleteUseCase = getIt<DeleteDepartmentCourseUseCase>();
    _updateUseCase = getIt<UpdateCourseUseCase>();
  }

  Future<void> _editCourse(dynamic course) async {
    await showCourseEditDialog(
      context,
      initialPrice: course.price,
      initialVisibility: course.visibility,
      onSave: (price, visibility) async {
        final updated = course.copyWith(
          price: price,
          clearPrice: price == null,
          visibility: visibility,
        );
        final result = await _updateUseCase(course.id, updated);

        return result.fold(
          (failure) {
            if (mounted) {
              SnackbarTheme().newSnackBarError(context, failure.message);
            }
            return false;
          },
          (_) {
            if (mounted) {
              context.read<CourseCubit>().getDemoCourses(widget.demoId);
            }
            return true;
          },
        );
      },
    );
  }

  bool get _isSelectionMode => widget.departmentId != null;

  bool get _hasSelectionChanges {
    final savedAssetIds = _assetIdToDepartmentCourseId.keys.toSet();
    return savedAssetIds.length != _selectedAssetIds.length ||
        !savedAssetIds.containsAll(_selectedAssetIds);
  }

  void _toggleCourse(String assetId) {
    if (!_isSelectionMode || _isSaving) return;

    setState(() {
      if (_selectedAssetIds.contains(assetId)) {
        _selectedAssetIds.remove(assetId);
      } else {
        _selectedAssetIds.add(assetId);
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_isSelectionMode || !_hasSelectionChanges || _isSaving) return;

    final savedAssetIds = _assetIdToDepartmentCourseId.keys.toSet();
    final addedAssetIds = _selectedAssetIds.difference(savedAssetIds);
    final removedAssetIds = savedAssetIds.difference(_selectedAssetIds);
    String? firstError;

    setState(() => _isSaving = true);

    for (final assetId in removedAssetIds) {
      final departmentCourseId = _assetIdToDepartmentCourseId[assetId];
      if (departmentCourseId == null) continue;

      final result = await _deleteUseCase(
        demoId: widget.demoId,
        departmentId: widget.departmentId!,
        departmentCourseId: departmentCourseId,
      );

      result.fold((failure) => firstError ??= failure.message, (_) {
        _assetIdToDepartmentCourseId.remove(assetId);
        _hasSavedChanges = true;
      });
    }

    for (final assetId in addedAssetIds) {
      final result = await _createUseCase(
        demoId: widget.demoId,
        departmentId: widget.departmentId!,
        assetId: assetId,
      );

      result.fold((failure) => firstError ??= failure.message, (
        departmentCourse,
      ) {
        _assetIdToDepartmentCourseId[assetId] = departmentCourse.id;
        _hasSavedChanges = true;
      });
    }

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (firstError != null) {
      SnackbarTheme().newSnackBarError(context, firstError!);
      return;
    }

    Navigator.pop(context, true);
  }

  void _closeSelection() {
    if (_isSaving) return;
    Navigator.pop(context, _hasSavedChanges);
  }

  Widget _buildList(AppLocalizations localizations, List<dynamic> demoCourses) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
      children: [
        if (widget.showAppBar) ...[
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
              color: AppColors.textSecondaryOf(context).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 18),
        ],
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_stories_rounded, color: AppColors.primary),
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
            onEdit: (widget.showAppBar && course.demo?.id == widget.demoId)
                ? () => _editCourse(course)
                : null,
            onSelect:
                (!widget.showAppBar &&
                    _isSelectionMode &&
                    assetId != null &&
                    !_isSaving)
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final body = BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return AppSkeletonizer(
            child: _buildList(localizations, List.filled(2, dummyCourse)),
          );
        }

        if (state is CourseLoaded) {
          final demoCourses = state.courses
              .where((course) => course.isPublished)
              .toList();

          return _buildList(localizations, demoCourses);
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
        _closeSelection();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        appBar: GradientPageAppBar(
          title: localizations.demoCourses,
          subtitle: localizations.demoCoursesDescription,
          onBackPressed: _closeSelection,
        ),
        body: body,
        bottomNavigationBar: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _hasSelectionChanges
              ? Container(
                  key: const ValueKey('save-course-selection'),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    border: Border(
                      top: BorderSide(color: AppColors.borderOf(context)),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: GradientActionButton(
                      label: localizations.saveChanges,
                      icon: Icons.save_outlined,
                      isLoading: _isSaving,
                      expand: true,
                      onPressed: _isSaving ? null : _saveChanges,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
