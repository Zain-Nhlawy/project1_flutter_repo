import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/department/presentation/cubit/department_cubit.dart';
import 'package:project1/features/department/presentation/cubit/department_state.dart';
import 'package:project1/features/department/presentation/cubit/main_page_switch_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';
import '../widgets/header_widget.dart';
import '../widgets/toggle_switch_widget.dart';
import '../widgets/item_card_widget.dart';

final GetIt sl = GetIt.instance;

class DemoMainPage extends StatelessWidget {
  final String demoId;
  const DemoMainPage({super.key, required this.demoId});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DemoMainPageSwitchCubit()),
        BlocProvider(
          create: (context) => sl<DepartmentCubit>()..fetchDepartments(demoId),
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocBuilder<DemoMainPageSwitchCubit, DemoTab>(
          builder: (context, currentTab) {
            final isSectionsActive = currentTab == DemoTab.sections;

            return Column(
              children: [
                const HeaderWidget(),
                SizedBox(height: size.height * 0.03),
                ToggleSwitchWidget(
                  isSectionsActive: isSectionsActive,
                  onToggle: (isSections) {
                    context.read<DemoMainPageSwitchCubit>().toggleTab(
                      isSections,
                    );
                  },
                ),
                SizedBox(height: size.height * 0.03),
                Expanded(
                  child: isSectionsActive
                      ? _buildSectionsContent(size, theme, l10n)
                      : _buildGroupsContent(size, theme, l10n),
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

          if (departments.isEmpty) {
            return Center(
              child: Text(
                'No sections found',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            children: [
              Text(
                l10n.yourSections,
                style: AppTextStyles.titleLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: size.height * 0.02),
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
            'Something went wrong',
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
      children: [
        // Text(
        //   l10n.myGroups,
        //   style: AppTextStyles.titleLarge.copyWith(
        //     color: theme.colorScheme.onSurface,
        //   ),
        // ),
        // SizedBox(height: size.height * 0.02),
        // ItemCardWidget(
        //   title: l10n.project1Team,
        //   subtitle: l10n.project1TeamSubtitle,
        //   count: '5',
        //   icon: Icons.group,
        // ),
        // ItemCardWidget(
        //   title: l10n.project1Team,
        //   subtitle: l10n.project1TeamSubtitle,
        //   count: '5',
        //   icon: Icons.group,
        // ),
      ],
    );
  }
}
