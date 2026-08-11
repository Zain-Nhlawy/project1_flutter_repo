import 'package:flutter/material.dart';

class CertificateElementPosition {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const CertificateElementPosition({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  double get width => right - left;
  double get height => bottom - top;

  Offset get center => Offset(
        (left + right) / 2,
        (top + bottom) / 2,
      );
}

class CertificateTemplateEntity {
  static const double canvasWidth = 1402;
  static const double canvasHeight = 1122;

  static const studentName = CertificateElementPosition(
    left: 240,
    top: 370,
    right: 1120,
    bottom: 460,
  );

  static const logo = CertificateElementPosition(
    left: 1100,
    top: 120,
    right: 1325,
    bottom: 230,
  );

  static const courseName = CertificateElementPosition(
    left: 240,
    top: 600,
    right: 1120,
    bottom: 660,
  );

  static const providerName = CertificateElementPosition(
    left: 240,
    top: 770,
    right: 1120,
    bottom: 820,
  );

  static const issueDate = CertificateElementPosition(
    left: 150,
    top: 900,
    right: 390,
    bottom: 960,
  );

  static const signature = CertificateElementPosition(
    left: 960,
    top: 860,
    right: 1210,
    bottom: 960,
  );
}

