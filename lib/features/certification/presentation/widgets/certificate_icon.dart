
import 'package:flutter/material.dart';

class CertificateIcon extends StatelessWidget {
  final Color color;

  const CertificateIcon({super.key, 
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            size: 31,
            color: color,
          ),
          Positioned(
            bottom: 7,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
