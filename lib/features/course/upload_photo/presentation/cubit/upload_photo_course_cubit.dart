import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/upload_photo/domain/use_case/upload_photo_course_usecase.dart';
import 'upload_photo_course_state.dart';

class UploadPhotoCourseCubit extends Cubit<UploadPhotoCourseState> {
  final UploadPhotoCourseUseCase uploadPhotoUseCase;

  UploadPhotoCourseCubit(this.uploadPhotoUseCase)
      : super(UploadPhotoCourseInitial());

  Future<String?> uploadPhoto(File file) async {
    emit(UploadPhotoCourseLoading());

    try {
      final url = await uploadPhotoUseCase(file);

      emit(UploadPhotoCourseSuccess(url));

      return url;
    } catch (e) {
      emit(
        UploadPhotoCourseError(e.toString()),
      );

      return null;
    }
  }
}