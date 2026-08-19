import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/integrations/drawio/presentation/pages/diagram_page.dart';
import 'package:project1/features/integrations/photopea/presentation/pages/photopea_editor_page.dart';
import 'package:project1/l10n/app_localizations.dart';

class GroupFeaturesScreen extends StatelessWidget {
  const GroupFeaturesScreen({super.key});

  void _openDrawio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DrawioPage()),
    );
  }

  void _openPhotopea(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PhotopeaEditorPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Header Banner ───
            _FeaturesHeaderBanner(
              title: l10n?.groupFeaturesTitle ?? 'Group Tools',
              subtitle: l10n?.groupFeaturesSubtitle ??
                  'Integrated tools to enhance collaboration, diagramming, and visual design.',
              badgeText: l10n?.featuresBadge ?? 'Integrated Suite',
            ),
            const SizedBox(height: 18),

            // ─── Feature 1: Draw.io ───
            _FeatureCard(
              title: l10n?.drawioFeatureTitle ?? 'Draw.io',
              category: l10n?.drawioFeatureTag ?? 'Flowcharts & Architecture',
              description: l10n?.drawioFeatureDescription ??
                  'Create professional diagrams, system architecture blueprints, flowcharts, UML diagrams, and mind maps.',
              actionLabel: l10n?.openFeatureTool ?? 'Open Tool',
              icon: Icons.account_tree_rounded,
              gradientColors: isDark
                  ? const [Color(0xFF1E3A5F), Color(0xFF132338)]
                  : const [Color(0xFF0A2A54), Color(0xFF1E4E8C)],
              accentColor: const Color(0xFF38BDF8),
              chips: const [
                _FeatureChipData(
                  icon: Icons.schema_outlined,
                  label: 'Flowcharts',
                ),
                _FeatureChipData(
                  icon: Icons.code_rounded,
                  label: 'XML & PNG',
                ),
                _FeatureChipData(
                  icon: Icons.hub_outlined,
                  label: 'Architecture',
                ),
              ],
              onTap: () => _openDrawio(context),
            ),
            const SizedBox(height: 16),

            // ─── Feature 2: Photopea ───
            _FeatureCard(
              title: l10n?.photopeaFeatureTitle ?? 'Photopea',
              category: l10n?.photopeaFeatureTag ?? 'Graphic & Photo Editor',
              description: l10n?.photopeaFeatureDescription ??
                  'Advanced graphic design and photo editing suite. Work with layers, edit PSD files, and export visual assets.',
              actionLabel: l10n?.openFeatureTool ?? 'Open Tool',
              icon: Icons.auto_fix_high_rounded,
              gradientColors: isDark
                  ? const [Color(0xFF2A2045), Color(0xFF1A142E)]
                  : const [Color(0xFF2E1A47), Color(0xFF4A2574)],
              accentColor: const Color(0xFFA78BFA),
              chips: const [
                _FeatureChipData(
                  icon: Icons.photo_filter_rounded,
                  label: 'Photo Retouch',
                ),
                _FeatureChipData(
                  icon: Icons.layers_rounded,
                  label: 'PSD & Layers',
                ),
                _FeatureChipData(
                  icon: Icons.brush_rounded,
                  label: 'Graphic Design',
                ),
              ],
              onTap: () => _openPhotopea(context),
            ),
            const SizedBox(height: 16),

            // ─── Footer Collaboration Note ───
            _FeaturesFooterTip(
              message: l10n?.featuresFooterNote ??
                  'All files and diagrams created with these tools can be saved and shared with your group members.',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header Banner Widget ───
class _FeaturesHeaderBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;

  const _FeaturesHeaderBanner({
    required this.title,
    required this.subtitle,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.25
                  : 0.05,
            ),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradientOf(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.widgets_rounded,
                  color: AppColors.primaryOf(context),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feature Card Widget ───
class _FeatureChipData {
  final IconData icon;
  final String label;

  const _FeatureChipData({required this.icon, required this.label});
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final String actionLabel;
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;
  final List<_FeatureChipData> chips;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.category,
    required this.description,
    required this.actionLabel,
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
    required this.chips,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withValues(alpha: 0.12),
            highlightColor: Colors.white.withValues(alpha: 0.06),
            child: Stack(
              children: [
                // Subtle decorative background icon
                PositionedDirectional(
                  end: -18,
                  bottom: -18,
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Icon(
                      icon,
                      size: 130,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Icon + Category + Title + Action Arrow
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.22),
                              ),
                            ),
                            child: Icon(icon, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: accentColor.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: accentColor,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Description
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.84),
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Feature Tags Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: chips.map((chip) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.09),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.14),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  chip.icon,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  size: 13,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  chip.label,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Open Action Button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              actionLabel,
                              style: TextStyle(
                                color: gradientColors.first,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.launch_rounded,
                              color: gradientColors.first,
                              size: 16,
                            ),
                          ],
                        ),
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

// ─── Footer Tip Widget ───
class _FeaturesFooterTip extends StatelessWidget {
  final String message;

  const _FeaturesFooterTip({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryOf(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: AppColors.primaryOf(context),
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondaryOf(context),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
