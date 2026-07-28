import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/main_page_switch_cubit.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/demo_fab_widget.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/groups_content_widget.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/header_widget.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/sections_content_widget.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/toggle_switch_widget.dart';
import 'package:project1/features/department/presentation/cubit/department%20cubit/department_cubit.dart';

class DemoMainPage extends StatelessWidget {
  final DemoEntity demo;

  const DemoMainPage({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DemoMainPageSwitchCubit()),
        BlocProvider(
          create: (context) =>
              getIt<DepartmentCubit>()..fetchDepartments(demo.id!),
        ),
        BlocProvider(
          create: (context) {
            return getIt<DemoUserCubit>()
              ..fetchUsers(demo.id!);
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: DemoFabWidget(demo: demo),
        backgroundColor: AppColors.backgroundOf(context),
        body: BlocBuilder<DemoMainPageSwitchCubit, DemoTab>(
          builder: (context, currentTab) {
            final isSectionsActive = currentTab == DemoTab.sections;

            return Column(
              children: [
                HeaderWidget(demo: demo),
                const SizedBox(height: 20),
                ToggleSwitchWidget(
                  isSectionsActive: isSectionsActive,
                  onToggle: (isSections) {
                    context.read<DemoMainPageSwitchCubit>().toggleTab(
                      isSections,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.04),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                    child: isSectionsActive
                        ? SectionsContentWidget(
                            key: const ValueKey('sections_tab'),
                            demo: demo,
                          )
                        : const GroupsContentWidget(
                            key: ValueKey('groups_tab'),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
