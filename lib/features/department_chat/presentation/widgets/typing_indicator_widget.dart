import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class TypingIndicatorWidget extends StatefulWidget {
  final List<String> typingMemberNames;

  const TypingIndicatorWidget({
    super.key,
    required this.typingMemberNames,
  });

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingMemberNames.isEmpty) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context);
    final text = widget.typingMemberNames.length == 1
        ? (localizations?.chatMemberIsTyping(widget.typingMemberNames.first) ??
            '${widget.typingMemberNames.first} is typing...')
        : (localizations?.chatMembersAreTyping(widget.typingMemberNames.length) ??
            '${widget.typingMemberNames.length} members are typing...');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.backgroundOf(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDots(),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final double value = (_controller.value - (index * 0.2)) % 1.0;
            final double opacity = (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(0.2, 1.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
