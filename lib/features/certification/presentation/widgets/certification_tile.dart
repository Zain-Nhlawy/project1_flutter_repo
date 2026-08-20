import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/certification/domain/entities/certification_entity.dart';
import 'package:project1/features/certification/presentation/widgets/certificate_icon.dart';
import 'package:project1/features/certification/presentation/widgets/info_badge.dart';

class CertificationTile extends StatelessWidget {
  final CertificationEntity certification;
  final String dateLabel;
  final VoidCallback onTap;

  const CertificationTile({
    super.key,
    required this.certification,
    required this.dateLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final secondaryColor =
        Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.65) ??
        Colors.grey;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: primaryColor.withValues(alpha: 0.10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CertificateIcon(color: primaryColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certification.courseName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          height: 1.25,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoBadge(
                            icon: Icons.grade_rounded,
                            label: 'Score ${certification.score}%',
                            color: primaryColor,
                          ),
                          InfoBadge(
                            icon: Icons.calendar_today_outlined,
                            label: dateLabel,
                            color: secondaryColor,
                            isOutlined: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 17,
                  color: primaryColor.withValues(alpha: 0.75),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
