import 'package:flutter/material.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/department/presentation/widgets/roadMap widgets/roadmap_stats_bar.dart';
import 'package:project1/features/department/presentation/widgets/roadMap widgets/roadmap_timeline_item.dart';

class RoadmapLoadingState extends StatelessWidget {
  const RoadmapLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = List.filled(3, dummyRoadmapStep);

    return AppSkeletonizer(
      child: Column(
        children: [
          RoadmapStatsBar(
            totalSteps: steps.length,
            totalWeeks: steps.length,
            onExportPdfPressed: () {},
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: steps.length,
              itemBuilder: (context, index) => RoadmapTimelineItem(
                step: steps[index],
                isFirst: index == 0,
                isLast: index == steps.length - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
