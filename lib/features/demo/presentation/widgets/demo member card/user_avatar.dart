import 'package:flutter/material.dart';
import 'package:project1/features/demo/shared/entities/user_entity.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user});

  final MembersEntity user;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasImage = user.imagePath != null && user.imagePath!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary.withOpacity(0.15), width: 2),
      ),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: colors.primaryContainer,
        backgroundImage: hasImage ? NetworkImage(user.imagePath!) : null,
        child: hasImage
            ? null
            : Text(
                user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
      ),
    );
  }
}