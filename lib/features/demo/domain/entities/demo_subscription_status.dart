import 'package:project1/features/demo/domain/entities/demo_entity.dart';

enum DemoSubscriptionStatus {
  expired,
  trialing,
  active,
  cancelled,
  unknown;

  factory DemoSubscriptionStatus.fromApi(String? value) {
    switch (value?.trim().toUpperCase()) {
      case 'EXPIRED':
        return DemoSubscriptionStatus.expired;
      case 'TRIALING':
        return DemoSubscriptionStatus.trialing;
      case 'ACTIVE':
        return DemoSubscriptionStatus.active;
      case 'CANCELLED':
      case 'CANCELED':
        return DemoSubscriptionStatus.cancelled;
      default:
        return DemoSubscriptionStatus.unknown;
    }
  }

  bool get isRestricted =>
      this == DemoSubscriptionStatus.expired ||
      this == DemoSubscriptionStatus.cancelled;
}

extension DemoSubscriptionDetails on DemoEntity {
  DemoSubscriptionStatus resolvedSubscriptionStatus({DateTime? now}) {
    final status = DemoSubscriptionStatus.fromApi(subscriptionStatus);
    if (status != DemoSubscriptionStatus.unknown) return status;

    // Compatibility for demos created before subscriptionStatus was added.
    final normalizedPlan = plan?.trim().toLowerCase() ?? '';
    if (normalizedPlan == 'free' || normalizedPlan == 'trial') {
      return trialDaysLeft(now: now) > 0
          ? DemoSubscriptionStatus.trialing
          : DemoSubscriptionStatus.expired;
    }
    if (normalizedPlan.isNotEmpty) return DemoSubscriptionStatus.active;

    return DemoSubscriptionStatus.unknown;
  }

  int trialDaysLeft({DateTime? now}) {
    final trialStart = createdAt ?? now ?? DateTime.now();
    final elapsedDays = (now ?? DateTime.now()).difference(trialStart).inDays;
    return (14 - elapsedDays).clamp(0, 14);
  }
}
