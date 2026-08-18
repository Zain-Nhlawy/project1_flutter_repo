import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;

  const DatePickerField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primaryOf(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: TextStyle(color: AppColors.textPrimaryOf(context)),
        decoration: InputDecoration(
          hintText: localizations.dateOfBirthHint,
          hintStyle: TextStyle(color: AppColors.textSecondaryOf(context)),
          prefixIcon: Icon(Icons.calendar_today, color: primary),
          filled: true,
          fillColor: AppColors.surfaceOf(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColors.borderOf(context),
              width: 1.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColors.borderOf(context),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: primary, width: 2),
          ),
        ),
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: isDark
                      ? ColorScheme.dark(
                          primary: primary,
                          onPrimary: Colors.white,
                          surface: AppColors.surfaceOf(context),
                          onSurface: AppColors.textPrimaryOf(context),
                        )
                      : ColorScheme.light(
                          primary: primary,
                          onPrimary: Colors.white,
                          surface: AppColors.surfaceOf(context),
                          onSurface: AppColors.textPrimaryOf(context),
                        ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            controller.text = "${picked.year}-${picked.month}-${picked.day}";
          }
        },
      ),
    );
  }
}