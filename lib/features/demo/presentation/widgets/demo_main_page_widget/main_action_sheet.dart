import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/pages/courses_selection_screen.dart';
import 'package:project1/features/demo/presentation/cubit/demo users cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/pages/demo_users_page.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class MainActionsSheet extends StatelessWidget {
  final String demoId;
  final bool isOwner;
  const MainActionsSheet({super.key, required this.demoId , this.isOwner = true});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final gradient = AppColors.buttonGradientOf(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag bar handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colors.outlineVariant.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Action tiles list
              _ActionTile(
                icon: Icons.menu_book_rounded,
                title: l10n.courses,
                gradient: gradient,
                colors: colors,
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

              const SizedBox(height: 12),

              _ActionTile(
                icon: Icons.people_alt_rounded,
                title: l10n.usersTab,
                gradient: gradient,
                colors: colors,
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BlocProvider.value(
                          value: context.read<DemoUserCubit>(),
                          child: DemoUsersScreen(
                            demoId: demoId,
                          ),
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

              const SizedBox(height: 12),

              _ActionTile(
                icon: Icons.bar_chart_rounded,
                title: l10n.demoStats,
                gradient: gradient,
                colors: colors,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.onSurfaceVariant.withOpacity(0.7),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
