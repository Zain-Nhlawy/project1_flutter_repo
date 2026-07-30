import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_cubit.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/main_action_sheet.dart';

class DemoFabWidget extends StatelessWidget {
  final DemoEntity demo;

  const DemoFabWidget({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    if (demo.isOwner != true) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = AppColors.buttonGradientOf(context);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkSecondary : AppColors.primary)
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
            final demoUserCubit = context.read<DemoUserCubit>();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (BuildContext sheetContext) {
                return BlocProvider.value(
                  value: demoUserCubit,
                  child: MainActionsSheet(demoId: demo.id!, isOwner: demo.isOwner),
                );
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
