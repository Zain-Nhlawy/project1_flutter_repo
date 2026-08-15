import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_state.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemosPage extends StatelessWidget {
  final String title;
  final List<DemoEntity> demos;

  const DemosPage({super.key, required this.title, required this.demos});

  Future<void> _refresh(BuildContext context) async {
    if (getIt.isRegistered<DemoCubit>()) {
      await getIt<DemoCubit>().fetchDemos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;
    final isOnlyOwner = demos.isNotEmpty && demos.every((d) => d.isOwner);
    final isOnlyJoined = demos.isNotEmpty && demos.every((d) => !d.isOwner);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        ),
        title: Text(
          title,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
            fontSize: 20 * textScale,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DemoCubit, DemoState>(
        bloc: getIt.isRegistered<DemoCubit>() ? getIt<DemoCubit>() : null,
        builder: (context, state) {
          List<DemoEntity> currentDemos = demos;
          if (state is GetDemosLoaded) {
            if (isOnlyOwner) {
              currentDemos = state.demos.where((d) => d.isOwner).toList();
            } else if (isOnlyJoined) {
              currentDemos = state.demos.where((d) => !d.isOwner).toList();
            } else {
              currentDemos = state.demos;
            }
          }

          return SafeArea(
            child: RefreshIndicator(
              color: AppColors.primaryOf(context),
              backgroundColor: AppColors.surfaceOf(context),
              onRefresh: () => _refresh(context),
              child: currentDemos.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Text(
                              localizations.noDemosAvailable,
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.textPrimaryOf(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 20 * textScale,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: currentDemos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: DemoCard(demo: currentDemos[index]),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
