import 'package:project1/features/department/domain/entities/department_entity.dart';

abstract class DepartmentState {}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<DepartmentEntity> departments;

  DepartmentLoaded(this.departments);
}

class DepartmentError extends DepartmentState {
  final String message;

  DepartmentError(this.message);
}

class DepartmentCreated extends DepartmentState {}
