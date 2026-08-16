import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: Column(
        children: [
          _AboutUsHeader(
            topPadding: topPadding,
            title: local.aboutUsTitle,
            subtitle: local.aboutUsSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Branding Card
                  _buildBrandCard(context, local, textScale),
                  const SizedBox(height: 20),

                  // Mission & Vision Card
                  _buildMissionCard(context, local, textScale),
                  const SizedBox(height: 20),

                  // Key Features Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Text(
                      local.aboutUsFeaturesTitle,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textPrimaryOf(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 18 * textScale,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Feature Cards
                  _buildFeatureTile(
                    context: context,
                    icon: Icons.menu_book_rounded,
                    iconColor: Colors.blueAccent,
                    title: local.aboutUsFeature1Title,
                    description: local.aboutUsFeature1Desc,
                    textScale: textScale,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    context: context,
                    icon: Icons.smart_toy_rounded,
                    iconColor: Colors.purpleAccent,
                    title: local.aboutUsFeature2Title,
                    description: local.aboutUsFeature2Desc,
                    textScale: textScale,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    context: context,
                    icon: Icons.workspace_premium_rounded,
                    iconColor: Colors.amber,
                    title: local.aboutUsFeature3Title,
                    description: local.aboutUsFeature3Desc,
                    textScale: textScale,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    context: context,
                    icon: Icons.groups_rounded,
                    iconColor: Colors.teal,
                    title: local.aboutUsFeature4Title,
                    description: local.aboutUsFeature4Desc,
                    textScale: textScale,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    context: context,
                    icon: Icons.quiz_rounded,
                    iconColor: Colors.orangeAccent,
                    title: local.aboutUsFeature5Title,
                    description: local.aboutUsFeature5Desc,
                    textScale: textScale,
                  ),
                  const SizedBox(height: 28),

                  // Footer / Version Info
                  _buildFooter(context, local, textScale),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard(
    BuildContext context,
    AppLocalizations local,
    double textScale,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundOf(context),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo1.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.school_rounded,
                size: 36,
                color: AppColors.primaryOf(context),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'LinCo',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.bold,
              fontSize: 20 * textScale,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primaryOf(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              local.aboutUsVersion,
              style: AppTextStyles.label.copyWith(
                color: AppColors.primaryOf(context),
                fontWeight: FontWeight.w600,
                fontSize: 12 * textScale,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            local.aboutUsTagline,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 13 * textScale,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(
    BuildContext context,
    AppLocalizations local,
    double textScale,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                local.aboutUsMissionTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimaryOf(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * textScale,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            local.aboutUsMissionDesc,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 14 * textScale,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            local.aboutUsDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 13 * textScale,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required double textScale,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 15 * textScale,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 13 * textScale,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations local,
    double textScale,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_rounded,
              color: Colors.redAccent.withValues(alpha: 0.8),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Crafted for empowering education',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondaryOf(context),
                fontSize: 12 * textScale,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '© ${DateTime.now().year} LinCo. ${local.aboutUsRights}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondaryOf(context).withValues(alpha: 0.7),
            fontSize: 11 * textScale,
          ),
        ),
      ],
    );
  }
}

class _AboutUsHeader extends StatelessWidget {
  final double topPadding;
  final String title;
  final String subtitle;

  const _AboutUsHeader({
    required this.topPadding,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding > 0 ? topPadding + 8 : 32,
          left: 20,
          right: 20,
          bottom: 22,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 38,
                      height: 38,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.surface,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.surface.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
