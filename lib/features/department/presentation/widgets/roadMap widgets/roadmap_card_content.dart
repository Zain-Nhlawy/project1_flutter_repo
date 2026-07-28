import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/department/domain/entities/roadmap_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class RoadmapCardContent extends StatefulWidget {
  final RoadmapStepEntity step;

  const RoadmapCardContent({
    super.key,
    required this.step,
  });

  @override
  State<RoadmapCardContent> createState() => _RoadmapCardContentState();
}

class _RoadmapCardContentState extends State<RoadmapCardContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);

    final step = widget.step;
    final hasDetails = step.skills.isNotEmpty ||
        step.projects.isNotEmpty ||
        step.deliverables.isNotEmpty ||
        step.resources.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded ? primaryColor : borderColor,
          width: _isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: _isExpanded ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: hasDetails
              ? () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Icon, Topic & Goal, Expand Arrow
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.headerGradientOf(context),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.topic,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          if (step.goal.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              step.goal,
                              style: TextStyle(
                                fontSize: 13,
                                color: textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (hasDetails) ...[
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ],
                ),

                // Skills preview (chips) when collapsed
                if (step.skills.isNotEmpty && !_isExpanded) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: step.skills.take(3).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Expanded Section details
                if (_isExpanded) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(height: 1),
                  ),

                  // Skills
                  if (step.skills.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      icon: Icons.auto_awesome_rounded,
                      title: l10n.skillsCovered,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Projects
                  if (step.projects.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      icon: Icons.folder_special_rounded,
                      title: l10n.practicalProjects,
                    ),
                    const SizedBox(height: 6),
                    ...step.projects.map((project) => _buildBulletItem(
                          context,
                          text: project,
                          iconColor: AppColors.success,
                        )),
                    const SizedBox(height: 14),
                  ],

                  // Deliverables
                  if (step.deliverables.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      icon: Icons.task_alt_rounded,
                      title: l10n.deliverables,
                    ),
                    const SizedBox(height: 6),
                    ...step.deliverables.map((item) => _buildBulletItem(
                          context,
                          text: item,
                          iconColor: AppColors.warning,
                        )),
                    const SizedBox(height: 14),
                  ],

                  // Resources
                  if (step.resources.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      icon: Icons.menu_book_rounded,
                      title: l10n.resources,
                    ),
                    const SizedBox(height: 6),
                    ...step.resources.map((res) => _buildBulletItem(
                          context,
                          text: res,
                          iconColor: AppColors.primaryOf(context),
                        )),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.headerGradientOf(context).createShader(bounds),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletItem(
    BuildContext context, {
    required String text,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondaryOf(context),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}