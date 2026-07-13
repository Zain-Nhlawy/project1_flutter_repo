import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
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

  List<String> _errorsOf(Failure failure) {
    return failure.errors ?? [failure.message];
  }

  Future<void> createSection({
    required String courseId,
    required String title,
    required int order,
  }) async {
    emit(state.copyWith(isLoading: true, errors: null));

    final result = await createSectionUseCase(
      courseId: courseId,
      title: title,
      order: order,
    );

    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, errors: _errorsOf(failure)));
      },
      (section) async {
        emit(state.copyWith(isLoading: false, section: section));
        await getSections(courseId: courseId);
      },
    );
  }

  Future<void> getSection({
    required String courseId,
    required String sectionId,
  }) async {
    emit(state.copyWith(isLoading: true, errors: null));

    final result = await getSectionUseCase(
      courseId: courseId,
      sectionId: sectionId,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errors: _errorsOf(failure))),
      (section) => emit(state.copyWith(isLoading: false, section: section)),
    );
  }

  Future<void> updateSection({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  }) async {
    emit(state.copyWith(isLoading: true, errors: null));

    final result = await updateSectionUseCase(
      courseId: courseId,
      sectionId: sectionId,
      title: title,
      order: order,
    );

    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, errors: _errorsOf(failure)));
      },
      (section) async {
        emit(state.copyWith(isLoading: false, section: section));
        await getSections(courseId: courseId);
      },
    );
  }

  Future<void> deleteSection({
    required String courseId,
    required String sectionId,
  }) async {
    emit(state.copyWith(isLoading: true, errors: null));

    final result = await deleteSectionUseCase(
      courseId: courseId,
      sectionId: sectionId,
    );

    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, errors: _errorsOf(failure)));
      },
      (_) async {
        emit(state.copyWith(isLoading: false, section: null));
        await getSections(courseId: courseId);
      },
    );
  }

  Future<void> getSections({
    required String courseId,
  }) async {
    emit(state.copyWith(isLoading: true, errors: null));

    final result = await getSectionsUseCase(courseId: courseId);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errors: _errorsOf(failure))),
      (sections) => emit(state.copyWith(isLoading: false, sections: sections)),
    );
  }
}