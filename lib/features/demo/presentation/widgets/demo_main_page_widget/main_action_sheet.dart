import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/pages/courses_selection_screen.dart';
import 'package:project1/features/course/presentation/pages/public_library_screen.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/pages/demo_users_page.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class MainActionsSheet extends StatelessWidget {
  final String demoId;
  final bool isOwner;

  const MainActionsSheet({
    super.key,
    required this.demoId,
    this.isOwner = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final headerGradient = AppColors.headerGradientOf(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag bar handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Sheet Header
              Padding(
                padding: const EdgeInsets.only(bottom: 14, left: 4, right: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        gradient: headerGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.demoOptions,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Material(
                      color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.close_rounded, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Options Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
                children: [
                  _GridActionTile(
                    icon: Icons.menu_book_rounded,
                    title: l10n.courses,
                    gradient: headerGradient,
                    colors: colors,
                    onTap: () {
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      navigator.push(
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
                  _GridActionTile(
                    icon: Icons.local_library_rounded,
                    title: l10n.publicLibrary,
                    gradient: headerGradient,
                    colors: colors,
                    onTap: () {
                      final navigator = Navigator.of(context);
                      navigator.pop();

                      navigator.push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              PublicLibraryScreen(demoId: demoId),
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
                  _GridActionTile(
                    icon: Icons.people_alt_rounded,
                    title: l10n.usersTab,
                    gradient: headerGradient,
                    colors: colors,
                    onTap: () {
                      DemoUserCubit demoUserCubit;
                      try {
                        demoUserCubit = context.read<DemoUserCubit>();
                      } catch (_) {
                        demoUserCubit = getIt<DemoUserCubit>()..fetchUsers(demoId);
                      }

                      final navigator = Navigator.of(context);
                      navigator.pop();

                      navigator.push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (routeContext, animation, secondaryAnimation) =>
                                  BlocProvider.value(
                                    value: demoUserCubit,
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
                  _GridActionTile(
                    icon: Icons.bar_chart_rounded,
                    title: l10n.demoStats,
                    gradient: headerGradient,
                    colors: colors,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _GridActionTile(
                    icon: Icons.mark_unread_chat_alt_rounded,
                    title: l10n.inquiries,
                    gradient: headerGradient,
                    colors: colors,
                    onTap: () {
                      Navigator.pop(context);
                      SnackbarTheme().newSnackBarInfo(
                        context,
                        l10n.inquiriesComingSoon,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _GridActionTile({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: gradient.colors.first.withValues(alpha: 0.1),
          highlightColor: gradient.colors.first.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                      height: 1.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
