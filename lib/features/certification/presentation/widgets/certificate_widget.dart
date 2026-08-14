import 'package:flutter/material.dart';
import 'package:project1/features/certification/data/models/certification_model.dart';
import 'package:project1/features/certification/domain/entities/certificate_template_entity.dart';

class CertificateWidget extends StatelessWidget {
  final CertificationModel certification;

  const CertificateWidget({
    super.key,
    required this.certification,
  });

  static const String _backgroundPath =
      'assets/images/certificate_background.png';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: CertificateTemplateEntity.canvasWidth /
          CertificateTemplateEntity.canvasHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale =
              constraints.maxWidth / CertificateTemplateEntity.canvasWidth;

          return Stack(
            children: [
              _buildBackground(),
              _buildStudentName(scale),
              _buildCourseName(scale),
              _buildProviderName(scale),
              _buildDate(scale),
              _buildLogo(scale),
              _buildSignature(scale),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        _backgroundPath,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildStudentName(double scale) {
    return _buildPositionedText(
      position: CertificateTemplateEntity.studentName,
      text: certification.userName,
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 40,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildCourseName(double scale) {
    return _buildPositionedText(
      position: CertificateTemplateEntity.courseName,
      text: certification.courseName,
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 26,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildProviderName(double scale) {
    return _buildPositionedText(
      position: CertificateTemplateEntity.providerName,
      text: certification.demoName,
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 26,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildDate(double scale) {
    return _buildPositionedText(
      position: CertificateTemplateEntity.issueDate,
      text: _formatDate(certification.issuedAt),
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildPositionedText({
    required CertificateElementPosition position,
    required String text,
    required double scale,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return Positioned(
      left: position.left * scale,
      top: position.top * scale,
      width: position.width * scale,
      height: position.height * scale,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double scale) {
    final position = CertificateTemplateEntity.logo;

    if (certification.logoImagePath.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: position.left * scale,
      top: position.top * scale,
      width: position.width * scale,
      height: position.height * scale,
      child: Image.network(
        certification.logoImagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSignature(double scale) {
    final position = CertificateTemplateEntity.signature;

    if (certification.signature.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: position.left * scale,
      top: position.top * scale,
      width: position.width * scale,
      height: position.height * scale,
      child: Image.network(
        certification.signature,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}