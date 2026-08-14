import 'package:flutter/material.dart';

import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class DiscussionComposer extends StatefulWidget {
  final String hintText;
  final bool isPosting;
  final ValueChanged<String> onSubmit;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  const DiscussionComposer({
    super.key,
    required this.hintText,
    required this.isPosting,
    required this.onSubmit,
    this.controller,
    this.focusNode,
  });

  @override
  State<DiscussionComposer> createState() => _DiscussionComposerState();
}

class _DiscussionComposerState extends State<DiscussionComposer> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  bool get _ownsController => widget.controller == null;

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();

    if (text.isEmpty || widget.isPosting) return;

    widget.onSubmit(text);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: widget.focusNode,
            minLines: 1,
            maxLines: 4,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _submit(),
            style: AppTextStyles.bodyMedium.copyWith(
              fontFamily: AppTextStyles.fontFamily,
              color: AppColors.textPrimaryOf(context),
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textSecondaryOf(context),
              ),
              filled: true,
              fillColor: AppColors.backgroundOf(context),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.borderOf(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.borderOf(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: primary, width: 1.5),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradientOf(context),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: widget.isPosting ? null : _submit,
              child: Center(
                child: widget.isPosting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
