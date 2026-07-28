import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/domain/use_case/create_department_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/delete_department_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_department_courses_usecase.dart';
import 'department_course_state.dart';

class DepartmentCourseCubit extends Cubit<DepartmentCourseState> {
  final GetDepartmentCoursesUseCase getDepartmentCoursesUseCase;
  final CreateDepartmentCourseUseCase createDepartmentCourseUseCase;
  final DeleteDepartmentCourseUseCase deleteDepartmentCourseUseCase;

  DepartmentCourseCubit({
    required this.getDepartmentCoursesUseCase,
    required this.createDepartmentCourseUseCase,
    required this.deleteDepartmentCourseUseCase,
  }) : super(const DepartmentCourseInitial());

  Future<void> getDepartmentCourses({
    required String demoId,
    required String departmentId,
    String? cursor,
  }) async {
    emit(const DepartmentCourseLoading());

    final result = await getDepartmentCoursesUseCase(
      demoId: demoId,
      departmentId: departmentId,
      cursor: cursor,
    );

    result.fold(
      (failure) => emit(DepartmentCourseError(failure.message)),
      (courses) => emit(DepartmentCourseLoaded(courses)),
    );
  }

  Future<void> createDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String assetId,
  }) async {
    emit(const DepartmentCourseLoading());

    final result = await createDepartmentCourseUseCase(
      demoId: demoId,
      departmentId: departmentId,
      assetId: assetId,
    );

    result.fold(
      (failure) => emit(DepartmentCourseError(failure.message)),
      (_) => emit(const DepartmentCourseActionSuccess('Course added successfully')),
    );
  }

  Future<void> deleteDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  }) async {
    emit(const DepartmentCourseLoading());

    final result = await deleteDepartmentCourseUseCase(
      demoId: demoId,
      departmentId: departmentId,
      departmentCourseId: departmentCourseId,
    );

    result.fold(
      (failure) => emit(DepartmentCourseError(failure.message)),
      (_) => emit(const DepartmentCourseActionSuccess('Course removed successfully')),
    );
  }
}