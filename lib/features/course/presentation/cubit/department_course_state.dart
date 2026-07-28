import '../../domain/entities/department_course_entity.dart';

abstract class DepartmentCourseState {
  const DepartmentCourseState();
}

class DepartmentCourseInitial extends DepartmentCourseState {
  const DepartmentCourseInitial();
}

class DepartmentCourseLoading extends DepartmentCourseState {
  const DepartmentCourseLoading();
}

class DepartmentCourseLoaded extends DepartmentCourseState {
  final List<DepartmentCourseEntity> courses;

  const DepartmentCourseLoaded(this.courses);
}

class DepartmentCourseActionSuccess extends DepartmentCourseState {
  final String message;

  const DepartmentCourseActionSuccess(this.message);
}

class DepartmentCourseError extends DepartmentCourseState {
  final String message;

  const DepartmentCourseError(this.message);
}