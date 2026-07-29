import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/use_case/delete_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/create_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_courses_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_demo_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/get_demo_courses_usecase.dart';
import 'package:project1/features/course/domain/use_case/publish_course_usecase.dart';
import 'package:project1/features/course/domain/use_case/update_course_usecase.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CreateCourseUseCase createCourseUseCase;
  final GetCourseUseCase getCourseUseCase;
  final GetCoursesUseCase getCoursesUseCase;
  final GetDemoCoursesUseCase getDemoCoursesUseCase;
  final GetDemoCourseUseCase getDemoCourseUseCase;
  final UpdateCourseUseCase updateCourseUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;
  final PublishCourseUseCase publishCourseUseCase;

  CourseCubit({
    required this.createCourseUseCase,
    required this.getCourseUseCase,
    required this.getCoursesUseCase,
    required this.getDemoCoursesUseCase,
    required this.getDemoCourseUseCase,
    required this.updateCourseUseCase,
    required this.deleteCourseUseCase,
    required this.publishCourseUseCase,
  }) : super(const CourseInitial());

  List<String> _errorsOf(Failure failure) {
    return failure.errors ?? [failure.message];
  }

  Future<void> createCourse(CourseEntity course) async {
    emit(const CourseCreating());
    final result = await createCourseUseCase(course);
    result.fold(
      (failure) => emit(CourseCreateError(_errorsOf(failure))),
      (createdCourse) => emit(CourseCreated(createdCourse)),
    );
  }

  Future<void> getCourses({
  String? search,
  List<String>? tagIds,
}) async {
  emit(const PublicCoursesLoading());
  final result = await getCoursesUseCase(
    search: search,
    tagIds: tagIds,
  );
  result.fold(
    (failure) {
      emit(PublicCoursesError(_errorsOf(failure)));
    },
    (courses) {
      emit(PublicCoursesLoaded(courses));
    },

  );
}

  Future<void> getCourse(String courseId) async {
    emit(const CourseDetailsLoading());
    final result = await getCourseUseCase(courseId);
    result.fold(
      (failure) => emit(CourseDetailsError(_errorsOf(failure))),
      (course) => emit(CourseDetailsLoaded(course)),
    );
  }

  Future<void> getDemoCourses(String demoId) async {
    emit(const CourseLoading());
    final result = await getDemoCoursesUseCase(demoId);
    result.fold(
      (failure) => emit(CourseError(_errorsOf(failure))),
      (courses) => emit(CourseLoaded(courses)),
    );
  }

  Future<void> getDemoCourse({
    required String demoId,
    required String assetId,
  }) async {
    emit(const CourseAssetLoading());
    final result = await getDemoCourseUseCase(demoId: demoId, assetId: assetId);
    result.fold(
      (failure) => emit(CourseAssetError(_errorsOf(failure))),
      (course) => emit(CourseAssetLoaded(course)),
    );
  }

  Future<void> updateCourse(String courseId, CourseEntity course) async {
    emit(const CourseUpdating());
    final result = await updateCourseUseCase(courseId, course);
    result.fold(
      (failure) => emit(CourseUpdateError(_errorsOf(failure))),
      (updated) => emit(CourseUpdated(updated)),
    );
  }

  Future<void> deleteCourse(String courseId) async {
    emit(const CourseDeleting());
    final result = await deleteCourseUseCase(courseId);
    result.fold(
      (failure) => emit(CourseDeleteError(_errorsOf(failure))),
      (_) => emit(const CourseDeleted()),
    );
  }

  Future<void> publishCourse(String courseId) async {
    emit(const CoursePublishing());

    final result = await publishCourseUseCase(courseId);

    result.fold(
      (failure) => emit(CoursePublishError(_errorsOf(failure))),
      (course) => emit(CoursePublished(course)),
    );
  }
}
