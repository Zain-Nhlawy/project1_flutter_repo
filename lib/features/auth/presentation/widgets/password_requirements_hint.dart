import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/domain/validators/password_validator.dart';
import 'package:project1/l10n/app_localizations.dart';

class PasswordRequirementsHint extends StatelessWidget {
  final TextEditingController controller;

  const PasswordRequirementsHint({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        if (value.text.isEmpty) return const SizedBox.shrink();

        final missingRequirements = PasswordValidator.missingRequirements(
          value.text,
        );
        if (missingRequirements.isEmpty) return const SizedBox.shrink();

        final missingLabels = missingRequirements
            .map((requirement) => _localizedLabel(requirement, localizations))
            .join(' • ');

        return Padding(
          padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
          child: Semantics(
            liveRegion: true,
            child: Text(
              '${localizations.passwordMissingRequirements}: $missingLabels',
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ),
        );
      },
    );
  }

  String _localizedLabel(
    PasswordRequirement requirement,
    AppLocalizations localizations,
  ) {
    return switch (requirement) {
      PasswordRequirement.minimumLength =>
        localizations.passwordRequirementMinLength,
      PasswordRequirement.lowercaseLetter =>
        localizations.passwordRequirementLowercase,
      PasswordRequirement.uppercaseLetter =>
        localizations.passwordRequirementUppercase,
      PasswordRequirement.digit => localizations.passwordRequirementNumber,
      PasswordRequirement.specialCharacter =>
        localizations.passwordRequirementSpecialCharacter,
    };
  }
}
