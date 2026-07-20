import 'package:project1/features/demo/domain/entities/user_entity.dart';

enum AddDepartmentStatus { initial, loading, success, error }

class AddDepartmentState {
  final String name;
  final String description;
  final MembersEntity? selectedManager;
  final AddDepartmentStatus status;
  final String? errorMessage;
  final bool showValidationErrors;

  const AddDepartmentState({
    this.name = '',
    this.description = '',
    this.selectedManager,
    this.status = AddDepartmentStatus.initial,
    this.errorMessage,
    this.showValidationErrors = false,
  });

  AddDepartmentState copyWith({
    String? name,
    String? description,
    MembersEntity? selectedManager,
    AddDepartmentStatus? status,
    String? errorMessage,
    bool? showValidationErrors,
  }) {
    return AddDepartmentState(
      name: name ?? this.name,
      description: description ?? this.description,
      selectedManager: selectedManager ?? this.selectedManager,
      status: status ?? this.status,
      errorMessage: errorMessage,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
    );
  }
}
