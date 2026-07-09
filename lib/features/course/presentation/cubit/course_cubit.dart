import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/use_case/get_tags_usecase.dart';
import 'package:project1/features/course/domain/use_case/create_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_demo_courses_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final GetTagsUseCase getTagsUseCase;
  final CreateCourseUseCase createCourseUseCase;
  final GetDemoCoursesUseCase getDemoCoursesUseCase;

  CourseCubit({
    required this.getTagsUseCase,
    required this.createCourseUseCase,
    required this.getDemoCoursesUseCase,
  }) : super(CourseInitial());

  Future<void> fetchTags() async {
    emit(CourseTagsLoading());
    try {
      final tags = await getTagsUseCase();
      emit(
        CourseTagsLoaded(tags),
      );
    } catch (e) {
      emit(
        CourseTagsError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> createCourse(CourseEntity course) async {
    emit(CourseCreating());
    try {
      final createdCourse = await createCourseUseCase(course);
      emit(
        CourseCreated(createdCourse),
      );
    } catch (e) {
      emit(
        CourseCreateError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getDemoCourses(String demoId) async {
    emit(CourseLoading());
    try {
      final courses = await getDemoCoursesUseCase(demoId);
      emit(
        CourseLoaded(courses),
      );
    } catch (e) {
      emit(
        CourseError(
          e.toString(),
        ),
      );
    }
  }
}