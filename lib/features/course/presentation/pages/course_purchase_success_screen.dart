import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursePurchaseSuccessScreen extends StatelessWidget {
  final String? courseTitle;

  const CoursePurchaseSuccessScreen({super.key, this.courseTitle});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.06),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.04),
                  decoration: const BoxDecoration(
                    gradient: AppColors.buttonGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        blurRadius: 20,
                        spreadRadius: -5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.surface,
                    size: 60 * textScale,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Text(
                localizations.paymentSuccessful,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24 * textScale,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                courseTitle != null
                    ? localizations.coursePurchaseSuccessMessage(courseTitle!)
                    : localizations.paymentSuccessMessage,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14 * textScale,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.06),
              ElevatedButton(
                onPressed: () {
                  final navigator = Navigator.of(context);
                    navigator.pop(); 
                    navigator.pop(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, size.height * 0.065),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  localizations.backToLibrary,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * textScale,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}