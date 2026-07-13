import 'package:flutter/material.dart';

class UserRoleBadge extends StatelessWidget {
  const UserRoleBadge({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isAdmin = role.toUpperCase() == 'ADMIN';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAdmin
            ? colors.primary.withOpacity(0.1)
            : colors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAdmin
              ? colors.primary.withOpacity(0.2)
              : colors.secondary.withOpacity(0.2),
        ),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: isAdmin ? colors.primary : colors.secondary,
        ),
      ),
    );
  }
}