import 'package:flutter/material.dart';

class LessonConnector extends StatelessWidget {
  final Widget child;
  final bool isLast;
  const LessonConnector({super.key, required this.child, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: isLast ? null : _LinePainter(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      child: child,
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  _LinePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 2;
    canvas.drawLine(Offset(25, 40), Offset(25, size.height + 10), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}