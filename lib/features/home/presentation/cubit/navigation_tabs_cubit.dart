import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/home/presentation/cubit/navigation_tabs_state.dart';
import 'package:project1/features/home/presentation/pages/home_page.dart';
import 'package:project1/features/profile/presentation/pages/profile_screen.dart';

class NavigationTabsCubit extends Cubit<NavigationTabsState> {
  NavigationTabsCubit() : super(const NavigationTabsState(0));

  final PageController pageController = PageController();

  final pages = [HomePage(), Placeholder(), ProfileScreen()];

  void changePage(int index) {
    final int pageDifference = (state.currentIndex - index).abs();
    emit(NavigationTabsState(index));

    if (pageDifference == 1) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      pageController.jumpToPage(index);
    }
  }

  void updateIndex(int index) {
    emit(NavigationTabsState(index));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
