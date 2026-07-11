import 'package:project1/features/section/domain/entities/section_entity.dart';

class SectionState {
  final bool isLoading;
  final String? error;
  final SectionEntity? section;
  final List<SectionEntity> sections;

  const SectionState({
    this.isLoading = false,
    this.error,
    this.section,
    this.sections = const [],
  });

  SectionState copyWith({
    bool? isLoading,
    String? error,
    SectionEntity? section,
    List<SectionEntity>? sections,
  }) {
    return SectionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      section: section ?? this.section,
      sections: sections ?? this.sections,
    );
  }
}