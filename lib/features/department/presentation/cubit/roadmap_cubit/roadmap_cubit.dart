import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/department/domain/use_case/roadmap_usecase.dart';
import 'package:project1/features/department/presentation/cubit/roadmap_cubit/roadmap_state.dart';

class RoadmapCubit extends Cubit<RoadmapState> {
  final RoadmapUseCase createRoadmapUseCase;

  RoadmapCubit(this.createRoadmapUseCase) : super(RoadmapInitial());

  Future<void> createRoadmap(
    String departmentId,
    String demoId,
    String title,
  ) async {
    emit(RoadmapLoading());

    final result = await createRoadmapUseCase.createRoadmap(
      departmentId,
      demoId,
      title,
    );

    result.fold(
      (error) => emit(RoadmapError(error)),
      (steps) => emit(RoadmapLoaded(steps)),
    );
  }
}
