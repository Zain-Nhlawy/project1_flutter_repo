import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/presentation/cubit/add_demo_state.dart';

class AddDemoCubit extends Cubit<AddDemoState> {
  final PageController pageController = PageController();

  AddDemoCubit() : super(AddDemoState());

  void nextPage() {
    if (state.currentPage < 2) {
      final nextPage = state.currentPage + 1;
      emit(state.copyWith(currentPage: nextPage));
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      final prevPage = state.currentPage - 1;
      emit(state.copyWith(currentPage: prevPage));
      pageController.animateToPage(
        prevPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void toggleFeature(int index) {
    final currentSelected = List<int>.from(state.selectedFeatureIndices);
    if (currentSelected.contains(index)) {
      currentSelected.remove(index);
    } else {
      currentSelected.add(index);
    }
    emit(state.copyWith(selectedFeatureIndices: currentSelected));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}