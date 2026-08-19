import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

Future<void> showCourseEditDialog(
  BuildContext context, {
  required double? initialPrice,
  required String? initialVisibility,
  required Future<bool> Function(double? price, String visibility) onSave,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => _CourseEditDialog(
      initialPrice: initialPrice,
      initialVisibility: initialVisibility ?? 'PUBLIC',
      onSave: onSave,
    ),
  );
}

class _CourseEditDialog extends StatefulWidget {
  final double? initialPrice;
  final String initialVisibility;
  final Future<bool> Function(double? price, String visibility) onSave;

  const _CourseEditDialog({
    required this.initialPrice,
    required this.initialVisibility,
    required this.onSave,
  });

  @override
  State<_CourseEditDialog> createState() => _CourseEditDialogState();
}

class _CourseEditDialogState extends State<_CourseEditDialog> {
  late final TextEditingController _priceController;
  late String _visibility;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.initialPrice == null || widget.initialPrice == 0
          ? ''
          : widget.initialPrice!.toStringAsFixed(2),
    );
    _visibility = widget.initialVisibility;
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSave(AppLocalizations localizations) async {
    final text = _priceController.text.trim();
    final price = text.isEmpty ? null : double.tryParse(text);

    if (text.isNotEmpty && price == null) {
      setState(() => _error = localizations.invalidPrice);
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final success = await widget.onSave(price, _visibility);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);
    final surface = AppColors.surfaceOf(context);
    final background = AppColors.backgroundOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final border = AppColors.borderOf(context);
    final errorColor = Theme.of(context).colorScheme.error;

    return Dialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.editCourse,
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 18),

            Text(
              localizations.price,
              style: AppTextStyles.label.copyWith(color: textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: !_isSaving,
              style: TextStyle(color: textPrimary),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.attach_money_rounded,
                  color: textSecondary,
                ),
                hintText: localizations.priceHint,
                hintStyle: TextStyle(
                  color: textSecondary.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: background,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primary, width: 1.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: border),
                ),
              ),
            ),
            const SizedBox(height: 18),

            Text(
              localizations.visibility,
              style: AppTextStyles.label.copyWith(color: textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _VisibilityOption(
                    label: localizations.visibilityPublic,
                    icon: Icons.public_rounded,
                    isSelected: _visibility == 'PUBLIC',
                    onTap: _isSaving
                        ? null
                        : () => setState(() => _visibility = 'PUBLIC'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _VisibilityOption(
                    label: localizations.visibilityPrivate,
                    icon: Icons.lock_outline_rounded,
                    isSelected: _visibility == 'PRIVATE',
                    onTap: _isSaving
                        ? null
                        : () => setState(() => _visibility = 'PRIVATE'),
                  ),
                ),
              ],
            ),

            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: TextStyle(color: errorColor, fontSize: 12),
              ),
            ],

            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(foregroundColor: textSecondary),
                    child: Text(localizations.cancel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving
                        ? null
                        : () => _handleSave(localizations),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            localizations.save,
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const _VisibilityOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final border = AppColors.borderOf(context);

    return Material(
      color: isSelected
          ? primary.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? primary : border),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? primary : textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? primary : textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}