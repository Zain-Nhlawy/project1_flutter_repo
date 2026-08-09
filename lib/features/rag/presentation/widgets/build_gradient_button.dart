import 'package:flutter/material.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';

Widget buildGradientButton(
  BuildContext context, {
  required String label,
  required IconData icon,
  required VoidCallback? onPressed,
  bool isLoading = false,
}) {
  return GradientActionButton(
    label: label,
    icon: icon,
    isLoading: isLoading,
    expand: true,
    onPressed: onPressed,
  );
}
