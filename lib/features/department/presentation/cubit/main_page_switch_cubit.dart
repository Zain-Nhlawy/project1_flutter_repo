import 'package:flutter_bloc/flutter_bloc.dart';
  
enum DemoTab { sections, groups }

class DemoMainPageSwitchCubit extends Cubit<DemoTab> {
  DemoMainPageSwitchCubit() : super(DemoTab.sections);

  void toggleTab(bool isSections) {
    if (isSections) {
      emit(DemoTab.sections);
    } else {
      emit(DemoTab.groups);
    }
  }
}