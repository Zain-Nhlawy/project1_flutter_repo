import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/pages/courses_selection_screen.dart';
import 'package:project1/features/demo/presentation/cubit/demo users cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/pages/demo_users_page.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class MainActionsSheet extends StatelessWidget {
  final String demoId;
  const MainActionsSheet({super.key, required this.demoId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              _CircleActionButton(
                icon: Icons.menu_book_outlined,
                label: l10n.courses,
                theme: theme,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CoursesSelectionScreen(demoId: demoId),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeThroughTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            _CircleActionButton(
              icon: Icons.people_alt_outlined,
              label: l10n.usersTab,
              theme: theme,
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BlocProvider(
                      create: (_) =>
                          getIt<DemoUserCubit>()..fetchUsers(demoId),
                      child: DemoUsersScreen(demoId: demoId),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            _CircleActionButton(
              icon: Icons.bar_chart_outlined,
              label: l10n.demoStats,
              theme: theme,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.label,
    required this.theme,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.tertiary,
            ),
            child: Icon(icon, color: theme.colorScheme.surface, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
