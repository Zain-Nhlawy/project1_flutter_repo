import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/department/presentation/cubit/roadmap_cubit/roadmap_cubit.dart';
import 'package:project1/features/department/presentation/cubit/roadmap_cubit/roadmap_state.dart';
import 'package:project1/features/department/presentation/widgets/roadMap%20widgets/roadmap_empty_state.dart';
import 'package:project1/features/department/presentation/widgets/roadMap%20widgets/roadmap_error_state.dart';
import 'package:project1/features/department/presentation/widgets/roadMap%20widgets/roadmap_generate_dialog.dart';
import 'package:project1/features/department/presentation/widgets/roadMap%20widgets/roadmap_loading_state.dart';
import 'package:project1/features/department/presentation/widgets/roadMap%20widgets/roadmap_pdf_service.dart';
import 'package:project1/features/department/presentation/widgets/roadMap%20widgets/roadmap_stats_bar.dart';
import 'package:project1/features/department/presentation/widgets/roadMap%20widgets/roadmap_timeline_item.dart';

class RoadmapScreen extends StatelessWidget {
  final String? departmentId;
  final String? demoId;

  const RoadmapScreen({super.key, this.departmentId, this.demoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoadmapCubit>(
      create: (_) => getIt<RoadmapCubit>(),
      child: RoadmapScreenContent(departmentId: departmentId, demoId: demoId),
    );
  }
}

class RoadmapScreenContent extends StatelessWidget {
  final String? departmentId;
  final String? demoId;

  const RoadmapScreenContent({super.key, this.departmentId, this.demoId});

  void _openGenerateDialog(BuildContext context) {
    RoadmapGenerateDialog.show(
      context,
      departmentId: departmentId ?? '',
      demoId: demoId ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<RoadmapCubit, RoadmapState>(
                builder: (context, state) {
                  if (state is RoadmapLoading) {
                    return const RoadmapLoadingState();
                  }

                  if (state is RoadmapError) {
                    return RoadmapErrorState(
                      error: state.error,
                      onRetryPressed: () => _openGenerateDialog(context),
                    );
                  }

                  if (state is RoadmapLoaded) {
                    final steps = state.roadmapSteps;

                    if (steps.isEmpty) {
                      return RoadmapEmptyState(
                        onGeneratePressed: () => _openGenerateDialog(context),
                      );
                    }

                    return Column(
                      children: [
                        RoadmapStatsBar(
                          totalSteps: steps.length,
                          totalWeeks: steps.length,
                          onExportPdfPressed: () {
                            RoadmapPdfService.exportPdf(
                              context,
                              steps: steps,
                              title: 'Department Learning Roadmap',
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: steps.length,
                            itemBuilder: (context, index) {
                              return RoadmapTimelineItem(
                                step: steps[index],
                                isFirst: index == 0,
                                isLast: index == steps.length - 1,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return RoadmapEmptyState(
                    onGeneratePressed: () => _openGenerateDialog(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
