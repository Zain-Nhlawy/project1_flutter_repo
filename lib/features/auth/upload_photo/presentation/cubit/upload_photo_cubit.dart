import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/upload_photo/domain/use_case/upload_photo_usecase.dart';
import 'upload_photo_state.dart';

class UploadPhotoCubit extends Cubit<UploadPhotoState> {
  final UploadPhotoUseCase uploadPhotoUseCase;

  UploadPhotoCubit(this.uploadPhotoUseCase)
      : super(UploadPhotoInitial());

  Future<String?> uploadPhoto(File file) async {
    emit(UploadPhotoLoading());

    final result = await uploadPhotoUseCase(file);

    return result.fold(
      (failure) {
        _emitFailure(failure);
        return null;
      },
      (url) {
        emit(UploadPhotoSuccess(url));
        return url;
      },
    );
  }

  void _emitFailure(Failure failure) {
    emit(
      UploadPhotoError(
        failure.errors ?? [failure.message],
      ),
    );
  }
}