import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/home/presentation/cubit/navigation_tabs_state.dart';
import 'package:project1/features/home/presentation/pages/home_page.dart';
import 'package:project1/features/profile/presentation/pages/profile_screen.dart';

class NavigationTabsCubit extends Cubit<NavigationTabsState> {
  NavigationTabsCubit() : super(const NavigationTabsState(0));

  final pages = [HomePage(), const Placeholder(), ProfileScreen()];

  void changePage(int index) {
    emit(NavigationTabsState(index));
  }

  void updateIndex(int index) {
    emit(NavigationTabsState(index));
  }
}
