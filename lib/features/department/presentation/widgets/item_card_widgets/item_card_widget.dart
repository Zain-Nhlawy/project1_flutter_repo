import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
import 'package:project1/features/department/presentation/pages/department_main_page.dart';
import 'package:project1/features/department/presentation/widgets/item_card_widgets/item_card_header.dart';
import 'package:project1/features/department/presentation/widgets/item_card_widgets/item_card_info.dart';
import 'package:project1/features/department/presentation/widgets/item_card_widgets/item_card_member_badge.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class ItemCardWidget extends StatefulWidget {
  final IconData icon;
  final DepartmentEntity departmentEntity;
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String demoId;
  final bool isManager;

  const ItemCardWidget({
    super.key,
    required this.icon,
    required this.departmentEntity,
    this.isOwner = false,
    this.isManager = false,
    this.onEdit,
    this.onDelete,
    required this.demoId,
  });

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRestricted =
        (widget.departmentEntity.isJoined == false) &&
        !widget.isOwner &&
        !widget.isManager;

    return Container(
      decoration: BoxDecoration(
        gradient: isRestricted
            ? LinearGradient(
                colors: [
                  AppColors.primaryOf(context).withValues(alpha: 0.5),
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.headerGradientOf(context),
        borderRadius: BorderRadius.circular(20),
        border: isRestricted
            ? Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(
              context,
            ).withValues(alpha: isRestricted ? 0.12 : 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isRestricted) {
                SnackbarTheme().newSnackBarError(
                  context,
                  localizations.restrictedSections,
                );
                return;
              }

              final demoUserCubit = context.read<DemoUserCubit>();
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BlocProvider.value(
                        value: demoUserCubit,
                        child: DepartmentMainPage(
                          department: widget.departmentEntity,
                          demoId: widget.demoId,
                          canManage: widget.isOwner || widget.isManager,
                        ),
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: child,
                        );
                      },
                ),
              );
            },
            child: Stack(
              children: [
                Positioned(
                  right: -16,
                  bottom: -16,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(
                      isRestricted ? Icons.lock_outline_rounded : widget.icon,
                      size: 90,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ItemCardHeader(
                        icon: widget.icon,
                        isOwner: widget.isOwner,
                        isRestricted: isRestricted,
                        onEdit: widget.onEdit,
                        onDelete: widget.onDelete,
                      ),
                      ItemCardInfo(
                        name: widget.departmentEntity.name,
                        description: widget.departmentEntity.description,
                      ),
                      ItemCardMemberBadge(
                        memberCount: widget.departmentEntity.memberCount ?? 0,
                      ),
                    ],
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
