import 'package:project1/features/section/domain/entities/section_entity.dart';

class SectionState {
  final bool isLoading;
  final List<String>? errors;
  final SectionEntity? section;
  final List<SectionEntity> sections;

  const SectionState({
    this.isLoading = false,
    this.errors,
    this.section,
    this.sections = const [],
  });

  SectionState copyWith({
    bool? isLoading,
    List<String>? errors,
    SectionEntity? section,
    List<SectionEntity>? sections,
  }) {
    return SectionState(
      isLoading: isLoading ?? this.isLoading,
      errors: errors,
      section: section ?? this.section,
      sections: sections ?? this.sections,
    );
  }
}
