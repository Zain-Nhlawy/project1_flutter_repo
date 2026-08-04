import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/pages/department_courses_screen.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
import 'package:project1/features/department/presentation/cubit/department_navigation_cubit.dart';
import 'package:project1/features/department/presentation/pages/sidebar%20screens/department_members_screen.dart';
import 'package:project1/features/department/presentation/pages/sidebar%20screens/roadmap_screen.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';
import 'package:project1/features/department_chat/presentation/pages/department_chat_screen.dart';
import '../widgets/department_main_page/department_nav_item.dart';
import '../widgets/department_main_page/department_sidebar.dart';
import '../widgets/department_main_page/department_empty_page.dart';

class DepartmentMainPage extends StatelessWidget {
  final DepartmentEntity? department;
  final String? demoId;
  final bool canManage;

  const DepartmentMainPage({
    super.key,
    this.department,
    this.demoId,
    this.canManage = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DepartmentNavigationCubit(),
      child: _DepartmentMainPageView(
        department: department,
        demoId: demoId,
        canManage: canManage,
      ),
    );
  }
}

class _DepartmentMainPageView extends StatefulWidget {
  final DepartmentEntity? department;
  final String? demoId;
  final bool canManage;

  const _DepartmentMainPageView({
    this.department,
    this.demoId,
    required this.canManage,
  });

  @override
  State<_DepartmentMainPageView> createState() =>
      _DepartmentMainPageViewState();
}

class _DepartmentMainPageViewState extends State<_DepartmentMainPageView> {
  bool _isSidebarVisible = true;

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final navItems = [
      DepartmentNavItem(
        Icons.dashboard_rounded,
        localizations.departmentMainPage,
      ),
      DepartmentNavItem(
        Icons.menu_book_rounded,
        localizations.departmentCourses,
      ),
      DepartmentNavItem(
        Icons.alt_route_rounded,
        localizations.departmentLearningPath,
      ),
      DepartmentNavItem(
        Icons.people_alt_rounded,
        localizations.departmentMembers,
      ),
      DepartmentNavItem(
        Icons.leaderboard_rounded,
        localizations.departmentLeaderboard,
      ),
      DepartmentNavItem(
        Icons.chat_bubble_outline_rounded,
        localizations.departmentChat,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      if (!_isSidebarVisible)
                        Material(
                          color: AppColors.textSecondaryOf(
                            context,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            onTap: _toggleSidebar,
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.menu_rounded,
                                color: AppColors.textPrimaryOf(context),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      if (!_isSidebarVisible) const SizedBox(width: 12),
                      Material(
                        color: AppColors.textSecondaryOf(
                          context,
                        ).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.textPrimaryOf(context),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<DepartmentNavigationCubit, int>(
                    builder: (context, currentIndex) {
                      return PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (child, primaryAnimation, secondaryAnimation) {
                              return FadeThroughTransition(
                                animation: primaryAnimation,
                                secondaryAnimation: secondaryAnimation,
                                fillColor: Colors.transparent,
                                child: child,
                              );
                            },
                        child: _getPage(currentIndex, localizations),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          IgnorePointer(
            ignoring: !_isSidebarVisible,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              opacity: _isSidebarVisible ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: Container(color: Colors.black.withValues(alpha: 0.35)),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            left: Directionality.of(context) == TextDirection.rtl
                ? null
                : (_isSidebarVisible ? 0 : -95),
            right: Directionality.of(context) == TextDirection.rtl
                ? (_isSidebarVisible ? 0 : -95)
                : null,
            top: 0,
            bottom: 0,
            child: DepartmentSidebar(
              isVisible: _isSidebarVisible,
              currentIndex: context.watch<DepartmentNavigationCubit>().state,
              navItems: navItems,
              onPageChanged: (index) {
                context.read<DepartmentNavigationCubit>().changePage(index);
                _toggleSidebar();
              },
              onToggle: _toggleSidebar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index, AppLocalizations localizations) {
    switch (index) {
      case 0:
        return DepartmentEmptyPage(
          key: const ValueKey(0),
          title: localizations.departmentMainPage,
        );
      case 1:
        return DepartmentCoursesPage(
          key: const ValueKey(1),
          demoId: widget.demoId!,
          departmentId: widget.department!.id!,
          canManage: widget.canManage,
        );
      case 2:
        return RoadmapScreen(
          key: const ValueKey(2),
          departmentId: widget.department?.id,
          demoId: widget.demoId,
        );
      case 3:
        return DepartmentMembersPage(
          key: const ValueKey(3),
          demoId: widget.demoId ?? '',
          departmentId: widget.department?.id ?? '',
          canManage: widget.canManage,
        );
      case 4:
        return DepartmentEmptyPage(
          key: const ValueKey(4),
          title: localizations.departmentLeaderboard,
        );
      case 5:
        return DepartmentChatScreen(
          key: const ValueKey(5),
          departmentId: widget.department?.id ?? '',
          demoId: widget.demoId ?? '',
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
