import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/domain/use_case/get_tags_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';


class CourseCubit extends Cubit<CourseState> {
  final GetTagsUseCase getTagsUseCase;

  CourseCubit({required this.getTagsUseCase}) : super(CourseInitial());

  Future<void> fetchTags() async {
    emit(CourseTagsLoading());
    try {
      final tags = await getTagsUseCase();
      emit(CourseTagsLoaded(tags));
    } catch (e) {
      emit(CourseTagsError(e.toString()));
    }
  }
}