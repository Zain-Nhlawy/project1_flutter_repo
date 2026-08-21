import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Applies the app-wide skeleton behavior and blocks interactions while data
/// placeholders are visible.
class AppSkeletonizer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppSkeletonizer({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      enableSwitchAnimation: true,
      ignorePointers: true,
      justifyMultiLineText: true,
      child: child,
    );
  }
}

/// Sliver counterpart used by loading states inside a [CustomScrollView].
class AppSliverSkeletonizer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppSliverSkeletonizer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      enabled: enabled,
      ignorePointers: true,
      justifyMultiLineText: true,
      child: child,
    );
  }
}
