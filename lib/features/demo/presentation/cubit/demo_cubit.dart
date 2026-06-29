  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:project1/features/demo/data/models/demo_model.dart';
  import 'package:project1/features/demo/domain/use%20case/get_demos_usecase.dart';
  import 'demo_state.dart';

  class DemoCubit extends Cubit<DemoState> {
    final GetDemosUseCase getDemosUseCase;

    DemoCubit({required this.getDemosUseCase}) : super(DemoInitial());

    Future<void> fetchDemos() async {
      emit(GetDemosLoading());

      final result = await getDemosUseCase.getDemos();

      result.fold(
        (error) => emit(GetDemosError(error)),
        (demos) => emit(GetDemosLoaded(demos)),
      );
    }

    Future<void> addDemo(DemoModel demo) async {
      emit(AddDemoLoading());

      final result = await getDemosUseCase.addDemo(demo);

      result.fold(
        (error) => emit(AddDemoError(error)),
        (_) => emit(AddDemoSuccess()),
      );
    }
  }