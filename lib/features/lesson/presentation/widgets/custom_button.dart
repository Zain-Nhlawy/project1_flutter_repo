import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final Gradient? gradient;
  final bool expand;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.gradient,
    this.expand = true,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null;

    final button = Container(
      height: height,
      decoration: BoxDecoration(
        gradient: disabled ? null : gradient,
        color: disabled
            ? Colors.grey.shade300
            : (gradient == null ? color : null),
        borderRadius: BorderRadius.circular(26),
        boxShadow: disabled
            ? []
            : [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: disabled ? Colors.grey.shade600 : textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
