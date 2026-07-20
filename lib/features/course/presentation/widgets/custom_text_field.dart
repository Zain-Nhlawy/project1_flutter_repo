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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: widget.enabled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
            color: widget.enabled ? AppColors.primary : AppColors.textSecondary,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: widget.enabled
              ? AppColors.surface
              : AppColors.surface.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.border, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.border, width: 1.2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColors.border.withOpacity(0.5),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
