import 'package:flutter/material.dart';
import 'package:project1/features/certification/domain/entities/certificate_template_entity.dart';

class CertificateWidget extends StatelessWidget {
  const CertificateWidget({
    super.key,
  });

  static const String _backgroundPath =
      'assets/images/certificate_background.png';

  static const String _logoPath = 'assets/images/main.png';

  static const String _signaturePath = 'assets/images/main.png';

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
      text: 'Ahmad Ali',
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 40,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildCourseName(double scale) {
    return _buildPositionedText(
      position: CertificateTemplateEntity.courseName,
      text: 'Flutter Advanced Course',
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 26,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildProviderName(double scale) {
    return _buildPositionedText(
      position: CertificateTemplateEntity.providerName,
      text: 'ABC Academy',
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 26,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildDate(double scale) {
    return _buildPositionedText(
      position: CertificateTemplateEntity.issueDate,
      text: '10 August 2026',
      scale: scale,
      fontFamily: 'CormorantGaramond',
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
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
    return _buildPositionedImage(
      position: CertificateTemplateEntity.logo,
      imagePath: _logoPath,
      scale: scale,
    );
  }

  Widget _buildSignature(double scale) {
    return _buildPositionedImage(
      position: CertificateTemplateEntity.signature,
      imagePath: _signaturePath,
      scale: scale,
    );
  }

  Widget _buildPositionedImage({
    required CertificateElementPosition position,
    required String imagePath,
    required double scale,
  }) {
    return Positioned(
      left: position.left * scale,
      top: position.top * scale,
      width: position.width * scale,
      height: position.height * scale,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}

