import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/upload_photo/domain/use_case/upload_photo_usecase.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';
import 'package:project1/features/demo/domain/use%20case/demos_usecase.dart';
import 'demo_state.dart';

class DemoCubit extends Cubit<DemoState> {
  final GetDemosUseCase getDemosUseCase;
  final UploadPhotoUseCase uploadPhotoUseCase;

  DemoCubit({required this.getDemosUseCase, required this.uploadPhotoUseCase})
    : super(DemoInitial());

  Future<void> fetchDemos() async {
    emit(GetDemosLoading());

    try {
      final result = await getDemosUseCase.getDemos();

      result.fold(
        (error) => emit(GetDemosError(error)),
        (demos) => emit(GetDemosLoaded(demos)),
      );
    } catch (e) {
      emit(GetDemosError(e.toString()));
    }
  }

  Future<void> addDemo(DemoModel demo) async {
    emit(AddDemoLoading());

    try {
      String? imageUrl = demo.imagePath;

      if (imageUrl != null &&
          imageUrl.isNotEmpty &&
          !imageUrl.startsWith('http://') &&
          !imageUrl.startsWith('https://') &&
          !imageUrl.startsWith('assets/')) {
        final file = File(imageUrl);
        if (file.existsSync()) {
          final uploadResult = await uploadPhotoUseCase(file);
          final shouldStop = uploadResult.fold(
            (failure) {
              emit(AddDemoError(failure.errors?.join(', ') ?? failure.message));
              return true;
            },
            (url) {
              imageUrl = url;
              return false;
            },
          );
          if (shouldStop) return;
        }
      }

      String? signatureUrl = demo.signatureImagePath;

      if (signatureUrl != null &&
          signatureUrl.isNotEmpty &&
          !signatureUrl.startsWith('http://') &&
          !signatureUrl.startsWith('https://') &&
          !signatureUrl.startsWith('assets/')) {
        final file = File(signatureUrl);
        if (file.existsSync()) {
          final uploadResult = await uploadPhotoUseCase(file);
          final shouldStop = uploadResult.fold(
            (failure) {
              emit(AddDemoError(failure.errors?.join(', ') ?? failure.message));
              return true;
            },
            (url) {
              signatureUrl = url;
              return false;
            },
          );
          if (shouldStop) return;
        }
      }

      final demoToSave = DemoModel(
        id: demo.id,
        name: demo.name,
        description: demo.description,
        imagePath: imageUrl,
        signatureImagePath: signatureUrl,
        ownerName: demo.ownerName,
        isOwner: demo.isOwner,
        plan: demo.plan,
        membersCount: demo.membersCount,
        createdAt: demo.createdAt,
        subscriptionStatus: demo.subscriptionStatus,
      );

      final result = await getDemosUseCase.addDemo(demoToSave);

      result.fold((error) => emit(AddDemoError(error)), (_) {
        emit(AddDemoSuccess());
        fetchDemos();
      });
    } catch (e) {
      emit(AddDemoError(e.toString()));
    }
  }
}
