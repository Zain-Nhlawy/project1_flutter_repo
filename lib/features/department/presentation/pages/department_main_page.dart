import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/pages/department_courses_screen.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'package:project1/features/department/presentation/cubit/department_navigation_cubit.dart';
import 'package:project1/features/department/presentation/pages/sidebar%20screens/department_leaderboard_screen.dart';
import 'package:project1/features/department/presentation/pages/sidebar%20screens/department_members_screen.dart';
import 'package:project1/features/department/presentation/pages/sidebar%20screens/group_features_screen.dart';
import 'package:project1/features/department/presentation/pages/sidebar%20screens/roadmap_screen.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';
import 'package:project1/features/department_chat/presentation/pages/department_chat_screen.dart';
import 'package:project1/features/department_chat/presentation/widgets/online_members_header.dart';
import 'package:project1/features/live_stream/presentation/pages/live_streams_page.dart';
import '../widgets/department_main_page/department_nav_item.dart';
import '../widgets/department_main_page/department_sidebar.dart';

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
  List<DepartmentMemberEntity> _onlineChatMembers = const [];

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  void _updateOnlineChatMembers(List<DepartmentMemberEntity> members) {
    if (!mounted) return;
    final hasSameMembers =
        _onlineChatMembers.length == members.length &&
        List.generate(
          members.length,
          (index) => _onlineChatMembers[index].id == members[index].id,
        ).every((isSame) => isSame);
    if (hasSameMembers) return;
    setState(() => _onlineChatMembers = List.unmodifiable(members));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final sidebarWidth = (viewportWidth * 0.72).clamp(0.0, 236.0).toDouble();
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final currentIndex = context.watch<DepartmentNavigationCubit>().state;
    final isGroup = widget.department?.isGroup == true;

    final navItems = isGroup
        ? [
            DepartmentNavItem(
              Icons.chat_bubble_outline_rounded,
              localizations.chat,
            ),
            DepartmentNavItem(
              Icons.widgets_outlined,
              localizations.features,
            ),
            DepartmentNavItem(
              Icons.people_alt_rounded,
              localizations.members,
            ),
          ]
        : [
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
            DepartmentNavItem(
              Icons.sensors_rounded,
              localizations.departmentLives,
            ),
          ];

    final isChatActive = isGroup ? currentIndex == 0 : currentIndex == 4;

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
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.headerGradientOf(context),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOf(
                                  context,
                                ).withValues(alpha: 0.22),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              onTap: _toggleSidebar,
                              borderRadius: BorderRadius.circular(14),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.menu_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!_isSidebarVisible) const SizedBox(width: 12),
                      Material(
                        color: AppColors.surfaceOf(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: AppColors.borderOf(context)),
                        ),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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
                      if (isChatActive &&
                          _onlineChatMembers.isNotEmpty) ...[
                        const Spacer(),
                        OnlineMembersHeader(members: _onlineChatMembers),
                      ],
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
                        child: _getPage(currentIndex, localizations, isGroup),
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
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            left: isRtl ? null : (_isSidebarVisible ? 0 : -(sidebarWidth + 12)),
            right: isRtl
                ? (_isSidebarVisible ? 0 : -(sidebarWidth + 12))
                : null,
            top: 0,
            bottom: 0,
            child: DepartmentSidebar(
              width: sidebarWidth,
              isVisible: _isSidebarVisible,
              currentIndex: currentIndex,
              navItems: navItems,
              isGroup: isGroup,
              departmentName: widget.department?.name ??
                  (isGroup
                      ? localizations.group
                      : localizations.department),
              departmentDescription: widget.department?.description ?? '',
              navigationLabel: isGroup
                  ? localizations.groupJourney
                  : localizations.departmentJourney,
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

  Widget _getPage(
    int index,
    AppLocalizations localizations,
    bool isGroup,
  ) {
    if (isGroup) {
      switch (index) {
        case 0:
          return DepartmentChatScreen(
            key: const ValueKey('group_chat'),
            departmentId: widget.department?.id ?? '',
            demoId: widget.demoId ?? '',
            onOnlineMembersChanged: _updateOnlineChatMembers,
          );
        case 1:
          return const GroupFeaturesScreen(
            key: ValueKey('group_features'),
          );
        case 2:
          return DepartmentMembersPage(
            key: const ValueKey('group_members'),
            demoId: widget.demoId ?? '',
            departmentId: widget.department?.id ?? '',
            canManage: widget.canManage,
            managerId: widget.department?.managerId,
          );
        default:
          return const SizedBox.shrink();
      }
    }

    switch (index) {
      case 0:
        return DepartmentCoursesPage(
          key: const ValueKey(0),
          demoId: widget.demoId ?? '',
          departmentId: widget.department?.id ?? '',
          canManage: widget.canManage,
        );
      case 1:
        return RoadmapScreen(
          key: const ValueKey(1),
          departmentId: widget.department?.id,
          demoId: widget.demoId,
        );
      case 2:
        return DepartmentMembersPage(
          key: const ValueKey(2),
          demoId: widget.demoId ?? '',
          departmentId: widget.department?.id ?? '',
          canManage: widget.canManage,
          managerId: widget.department?.managerId,
        );
      case 3:
        return DepartmentLeaderboardScreen(
          key: const ValueKey(3),
          departmentId: widget.department?.id ?? '',
          demoId: widget.demoId,
        );
      case 4:
        return DepartmentChatScreen(
          key: const ValueKey(4),
          departmentId: widget.department?.id ?? '',
          demoId: widget.demoId ?? '',
          onOnlineMembersChanged: _updateOnlineChatMembers,
        );
      case 5:
        return LiveStreamsPage(
          key: const ValueKey(5),
          departmentId: widget.department?.id ?? '',
          demoId: widget.demoId,
          canManage: widget.canManage,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
