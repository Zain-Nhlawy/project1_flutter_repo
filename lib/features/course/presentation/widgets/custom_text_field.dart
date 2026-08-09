import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final bool isPassword;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.isPassword = false,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    final border = AppColors.borderOf(context);
    final surface = AppColors.surfaceOf(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: widget.enabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: obscureText,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixIcon: Icon(
            widget.icon,
            color: widget.enabled
                ? primary
                : AppColors.textSecondaryOf(context),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondaryOf(context),
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColors.textSecondaryOf(context)),
          filled: true,
          fillColor: widget.enabled ? surface : surface.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: border, width: 1.1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: border, width: 1.1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: border.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primary, width: 1.8),
          ),
        ),
      ),
    );
  }
}
