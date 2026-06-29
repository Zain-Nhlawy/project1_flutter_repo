import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/upload_photo/domain/use_case/upload_photo_usecase.dart';
import 'upload_photo_state.dart';

class UploadPhotoCubit extends Cubit<UploadPhotoState> {
  final UploadPhotoUseCase uploadPhotoUseCase;

  UploadPhotoCubit(this.uploadPhotoUseCase)
      : super(UploadPhotoInitial());

  Future<String?> uploadPhoto(File file) async {
    emit(UploadPhotoLoading());

    try {
      final url = await uploadPhotoUseCase(file);

      emit(UploadPhotoSuccess(url));

      return url;
    } catch (e) {
      emit(UploadPhotoError(e.toString()));
      return null;
    }
  }
}