import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class OnboardingCardVisual extends StatelessWidget {
  final int index;
  final double textScale;

  const OnboardingCardVisual({
    super.key,
    required this.index,
    required this.textScale,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cardHeight = size.height * 0.38;

    switch (index) {
      case 0:
        return _buildSlideOne(context, cardHeight);
      case 1:
        return _buildSlideTwo(context, cardHeight);
      case 2:
      default:
        return _buildSlideThree(context, cardHeight);
    }
  }

  Widget _buildSlideOne(BuildContext context, double height) {
    const primaryGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0A2A54), Color(0xFF1E4E8C), Color(0xFF2F6FB3)],
    );

    return _buildContainer(
      context: context,
      height: height,
      gradient: primaryGrad,
      accentColor: const Color(0xFF4A90D9),
      mainIcon: Icons.school_rounded,
      secondaryIcon: Icons.play_circle_filled_rounded,
      pill1Icon: Icons.video_library_rounded,
      pill1Text: 'Courses & Demos',
      pill1Align: const Alignment(-0.85, 0.75),
      pill2Icon: Icons.groups_rounded,
      pill2Text: 'Live Interactive Rooms',
      pill2Align: const Alignment(0.85, -0.65),
    );
  }

  Widget _buildSlideTwo(BuildContext context, double height) {
    const purpleGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3B1260), Color(0xFF5E178A), Color(0xFF7E22CE)],
    );

    return _buildContainer(
      context: context,
      height: height,
      gradient: purpleGrad,
      accentColor: const Color(0xFFA855F7),
      mainIcon: Icons.smart_toy_rounded,
      secondaryIcon: Icons.auto_awesome_rounded,
      pill1Icon: Icons.psychology_rounded,
      pill1Text: 'Instant AI Answers',
      pill1Align: const Alignment(-0.85, -0.65),
      pill2Icon: Icons.forum_rounded,
      pill2Text: 'Active Q&A Forum',
      pill2Align: const Alignment(0.85, 0.75),
    );
  }

  Widget _buildSlideThree(BuildContext context, double height) {
    const emeraldGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF0D9488)],
    );

    return _buildContainer(
      context: context,
      height: height,
      gradient: emeraldGrad,
      accentColor: const Color(0xFF34D399),
      mainIcon: Icons.workspace_premium_rounded,
      secondaryIcon: Icons.verified_rounded,
      pill1Icon: Icons.quiz_rounded,
      pill1Text: 'Questions Bank & Tests',
      pill1Align: const Alignment(-0.85, 0.75),
      pill2Icon: Icons.military_tech_rounded,
      pill2Text: 'Verified Certificates',
      pill2Align: const Alignment(0.85, -0.65),
    );
  }

  Widget _buildContainer({
    required BuildContext context,
    required double height,
    required LinearGradient gradient,
    required Color accentColor,
    required IconData mainIcon,
    required IconData secondaryIcon,
    required IconData pill1Icon,
    required String pill1Text,
    required Alignment pill1Align,
    required IconData pill2Icon,
    required String pill2Text,
    required Alignment pill2Align,
  }) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        children: [
          // Background decorative ambient circles
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Central Main Icon Hero with Ripples
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow circle
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                // Inner ring
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                ),
                // Core avatar
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      mainIcon,
                      size: 44,
                      color: gradient.colors.first,
                    ),
                  ),
                ),
                // Mini badge overlay
                Positioned(
                  right: 28,
                  bottom: 28,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      secondaryIcon,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Feature Pill 1
          Align(
            alignment: pill1Align,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: gradient.colors.first.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      pill1Icon,
                      size: 14,
                      color: gradient.colors.first,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pill1Text,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w700,
                      fontSize: 11 * textScale,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Feature Pill 2
          Align(
            alignment: pill2Align,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      pill2Icon,
                      size: 14,
                      color: gradient.colors.last,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pill2Text,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w700,
                      fontSize: 11 * textScale,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
