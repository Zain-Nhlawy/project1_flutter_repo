import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/onboarding/presentation/widgets/onboarding_card_visual.dart';
import 'package:project1/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:project1/features/profile/presentation/cubit/locale_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onFinish;

  const OnboardingScreen({super.key, this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final storage = getIt<AppSecureStorage>();
    await storage.write(StorageKeys.hasSeenOnboarding, 'true');

    if (widget.onFinish != null) {
      widget.onFinish!();
    } else if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final currentLocale = context.watch<LocaleCubit>().state.languageCode;

    final titles = [
      local.onboardingSlide1Title,
      local.onboardingSlide2Title,
      local.onboardingSlide3Title,
    ];

    final subtitles = [
      local.onboardingSlide1Subtitle,
      local.onboardingSlide2Subtitle,
      local.onboardingSlide3Subtitle,
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding > 0 ? topPadding + 10 : 28,
            bottom: bottomPadding > 0 ? bottomPadding + 16 : 28,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              // Top Action Bar (Language Switcher & Skip Button)
              _buildTopBar(context, local, currentLocale, textScale),
              const SizedBox(height: 12),

              // Slide Carousel
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _totalPages,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildSlideContent(
                      context: context,
                      index: index,
                      title: titles[index],
                      subtitle: subtitles[index],
                      textScale: textScale,
                      size: size,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Navigation Section (Indicator + Action Buttons)
              _buildBottomControls(context, local, textScale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    AppLocalizations local,
    String currentLocale,
    double textScale,
  ) {
    final isLastPage = _currentPage == _totalPages - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Language Toggle Chip
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final newLocale = currentLocale == 'ar' ? 'en' : 'ar';
            context.read<LocaleCubit>().changeLanguage(newLocale);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderOf(context).withValues(alpha: 0.6),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: 16,
                  color: AppColors.primaryOf(context),
                ),
                const SizedBox(width: 6),
                Text(
                  currentLocale == 'ar' ? 'العربية' : 'English',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 12 * textScale,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Skip Button (Visible on slides 0 & 1, subtle fade on slide 2)
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isLastPage ? 0.0 : 1.0,
          child: IgnorePointer(
            ignoring: isLastPage,
            child: TextButton(
              onPressed: _completeOnboarding,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                local.onboardingSkip,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 14 * textScale,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlideContent({
    required BuildContext context,
    required int index,
    required String title,
    required String subtitle,
    required double textScale,
    required Size size,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Visual Card Illustration
        OnboardingCardVisual(
          index: index,
          textScale: textScale,
        ),
        SizedBox(height: size.height * 0.035),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.w800,
              fontSize: 22 * textScale,
              letterSpacing: -0.4,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 14 * textScale,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    AppLocalizations local,
    double textScale,
  ) {
    final isLastPage = _currentPage == _totalPages - 1;

    return Column(
      children: [
        // Page Dot Indicators
        OnboardingPageIndicator(
          count: _totalPages,
          currentIndex: _currentPage,
        ),
        const SizedBox(height: 24),

        // Next / Get Started Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              elevation: 4,
              shadowColor: AppColors.primaryOf(context).withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradientOf(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastPage
                          ? local.onboardingGetStarted
                          : local.onboardingNext,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * textScale,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLastPage
                          ? Icons.check_circle_outline_rounded
                          : Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
