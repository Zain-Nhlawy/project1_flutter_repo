import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/pages/courses_inProgress_screen.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/department%20cubit/department_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/department%20cubit/department_state.dart';
import 'package:project1/features/demo/presentation/cubit/main_page_switch_cubit.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/header_widget.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/item_card_widget.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/main_action_sheet.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/toggle_switch_widget.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoMainPage extends StatelessWidget {
  final DemoEntity demo;
  const DemoMainPage({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DemoMainPageSwitchCubit()),
        BlocProvider(
          create: (context) =>
              getIt<DepartmentCubit>()..fetchDepartments(demo.id!),
        ),
      ],
      child: Scaffold(
        floatingActionButton: demo.isOwner == true
            ? FloatingActionButton.extended(
                backgroundColor: theme.colorScheme.tertiary,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return MainActionsSheet(demoId: demo.id!);
                    },
                  );
                },
                label: const Icon(Icons.adjust_outlined, color: Colors.white),
              )
            : null,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocBuilder<DemoMainPageSwitchCubit, DemoTab>(
          builder: (context, currentTab) {
            final isSectionsActive = currentTab == DemoTab.sections;

            return Column(
              children: [
                HeaderWidget(demo: demo),
                SizedBox(height: size.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ToggleSwitchWidget(
                    isSectionsActive: isSectionsActive,
                    onToggle: (isSections) {
                      context.read<DemoMainPageSwitchCubit>().toggleTab(
                        isSections,
                      );
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.05),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                    child: isSectionsActive
                        ? SizedBox(
                            key: const ValueKey('sections_tab'),
                            child: _buildSectionsContent(
                              size,
                              theme,
                              l10n,
                              demo,
                            ),
                          )
                        : SizedBox(
                            key: const ValueKey('groups_tab'),
                            child: _buildGroupsContent(size, theme, l10n),
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

  Widget _buildSectionsContent(
    Size size,
    ThemeData theme,
    AppLocalizations l10n,
    DemoEntity demo,
  ) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading || state is DepartmentInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DepartmentError) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          );
        }

        if (state is DepartmentLoaded) {
          final departments = state.departments;

          final currentPlan = demo.plan?.toLowerCase() ?? 'starter';
          final isFreePlan = currentPlan == 'starter' || currentPlan == 'free';

          final isLimitReached = isFreePlan && departments.length >= 0;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.yourSections,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (demo.isOwner)
                    InkWell(
                      onTap: isLimitReached
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.limitReachedSnackBar),
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            }
                          : () {},
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.008,
                        ),
                        decoration: BoxDecoration(
                          color: isLimitReached
                              ? Colors.grey.withOpacity(0.1)
                              : theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLimitReached ? Icons.lock_outline : Icons.add,
                              color: isLimitReached
                                  ? Colors.grey
                                  : theme.colorScheme.primary,
                              size: 18,
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text(
                              isLimitReached
                                  ? l10n.limitReachedMessage
                                  : l10n.addSection,
                              style: AppTextStyles.label.copyWith(
                                color: isLimitReached
                                    ? Colors.grey
                                    : theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              if (departments.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  child: Center(
                    child: Text(
                      l10n.noSectionFound,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                )
              else
                ...departments.map(
                  (department) => ItemCardWidget(
                    departmentEntity: department,
                    icon: Icons.layers,
                  ),
                ),
            ],
          );
        }

        return Center(
          child: Text(
            l10n.somethingWentWrong,
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsContent(
    Size size,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      children: [],
    );
  }
}
