import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/main_action_sheet.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoFabWidget extends StatelessWidget {
  final DemoEntity demo;

  const DemoFabWidget({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = AppColors.headerGradientOf(context);
    final l10n = AppLocalizations.of(context)!;
    final isOwner = demo.isOwner == true;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkSecondary : AppColors.secondary)
                .withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            if (isOwner) {
              final demoUserCubit = context.read<DemoUserCubit>();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext sheetContext) {
                  return BlocProvider.value(
                    value: demoUserCubit,
                    child: MainActionsSheet(
                      demoId: demo.id!,
                      isOwner: true,
                    ),
                  );
                },
              );
            } else {
              // Member view: Direct action for Inquiries
              SnackbarTheme().newSnackBarInfo(
                context,
                l10n.inquiriesComingSoon,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isOwner ? 16 : 20,
              vertical: 14,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOwner
                      ? Icons.tune_rounded
                      : Icons.mark_unread_chat_alt_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                if (!isOwner) ...[
                  const SizedBox(width: 8),
                  Text(
                    l10n.sendInquiries,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

