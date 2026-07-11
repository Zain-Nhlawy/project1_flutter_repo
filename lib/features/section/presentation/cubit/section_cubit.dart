import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/section/domain/use_case/create_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/delete_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/get_section_usecase.dart';
import 'package:project1/features/section/domain/use_case/get_sections_usecase.dart';
import 'package:project1/features/section/domain/use_case/update_section_usecase.dart';
import 'section_state.dart';

class SectionCubit extends Cubit<SectionState> {
  final CreateSectionUseCase createSectionUseCase;
  final UpdateSectionUseCase updateSectionUseCase;
  final DeleteSectionUseCase deleteSectionUseCase;
  final GetSectionUseCase getSectionUseCase;
  final GetSectionsUseCase getSectionsUseCase;

  SectionCubit({
    required this.createSectionUseCase,
    required this.updateSectionUseCase,
    required this.deleteSectionUseCase,
    required this.getSectionUseCase,
    required this.getSectionsUseCase,
  }) : super(const SectionState());

  Future<void> createSection({
    required String courseId,
    required String title,
    required int order,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final section = await createSectionUseCase(
        courseId: courseId,
        title: title,
        order: order,
      );

      emit(state.copyWith(
        isLoading: false,
        section: section,
      ));
      await getSections(courseId: courseId);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> getSection({
    required String courseId,
    required String sectionId,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final section = await getSectionUseCase(
        courseId: courseId,
        sectionId: sectionId,
      );

      emit(state.copyWith(
        isLoading: false,
        section: section,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final section = await updateSectionUseCase(
        courseId: courseId,
        sectionId: sectionId,
        title: title,
        order: order,
      );

      emit(state.copyWith(
        isLoading: false,
        section: section,
      ));
      await getSections(courseId: courseId);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> deleteSection({
    required String courseId,
    required String sectionId,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      await deleteSectionUseCase(
        courseId: courseId,
        sectionId: sectionId,
      );

      emit(state.copyWith(
        isLoading: false,
        section: null,
      ));
      await getSections(courseId: courseId);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> getSections({
  required String courseId,
}) async {
  emit(state.copyWith(
    isLoading: true,
    error: null,
  ));

  try {
    final sections = await getSectionsUseCase(
      courseId: courseId,
    );

    emit(state.copyWith(
      isLoading: false,
      sections: sections,
    ));
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: e.toString(),
    ));
  }
}
}