import 'package:flutter/material.dart';
import 'package:project1/features/department/presentation/widgets/item_card_widgets/item_card_options_menu.dart';

class ItemCardHeader extends StatelessWidget {
  final IconData icon;
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemCardHeader({
    super.key,
    required this.icon,
    required this.isOwner,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        Row(
          children: [
            if (isOwner) ...[
              ItemCardOptionsMenu(
                onEdit: onEdit,
                onDelete: onDelete,
              ),
              const SizedBox(width: 6),
            ],
            Container(
              height: 32,
              width: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
