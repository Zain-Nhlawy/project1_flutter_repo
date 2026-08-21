import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/certification/presentation/pages/my_certifications_screen.dart';
import 'package:project1/features/course/presentation/pages/course_details_screen.dart';
import 'package:project1/features/demo/presentation/cubit/invitations_cubit/invitation_cubit.dart';
import 'package:project1/features/demo/presentation/pages/demo_stats_page.dart';
import 'package:project1/features/demo/presentation/pages/inquiries_page.dart';
import 'package:project1/features/demo/presentation/pages/invitations_page.dart';
import 'package:project1/features/department/presentation/pages/department_main_page.dart';
import 'package:project1/features/department_chat/presentation/pages/department_chat_screen.dart';
import 'package:project1/features/live_stream/presentation/pages/live_streams_page.dart';
import 'package:project1/features/notifications/data/data_sources/notification_storage_service.dart';
import 'package:project1/features/notifications/domain/entities/notification_payload_entity.dart';
import 'package:project1/features/notifications/presentation/pages/notifications_page.dart';
import 'package:project1/features/profile/presentation/pages/profile_screen.dart';
import 'package:project1/main.dart';

abstract class NotificationTypeHandler {
  void handle(NotificationPayloadEntity payload, BuildContext context);
}

class NotificationNavigationHandler {
  static final Map<String, NotificationTypeHandler> _handlers = {};

  static void registerHandler(String type, NotificationTypeHandler handler) {
    _handlers[type.toLowerCase()] = handler;
  }

  static void handleNotificationTap(NotificationPayloadEntity payload) {
    // Mark as read in storage
    try {
      if (getIt.isRegistered<NotificationStorageService>()) {
        getIt<NotificationStorageService>().markAsRead(payload.id);
      }
    } catch (_) {}

    final context = navigatorKey.currentContext;
    final currentState = navigatorKey.currentState;

    if (currentState == null || context == null) return;

    final targetScreen = payload.targetScreen.trim().toLowerCase();
    final type = payload.type.trim().toLowerCase();

    if (_handlers.containsKey(targetScreen)) {
      _handlers[targetScreen]!.handle(payload, context);
      return;
    }

    if (_handlers.containsKey(type)) {
      _handlers[type]!.handle(payload, context);
      return;
    }

    // Route based on screen name / type
    if (_isInvitationScreen(targetScreen, type)) {
      currentState.push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => InvitationCubit(usecase: getIt()),
            child: const InvitationsPage(),
          ),
        ),
      );
      return;
    }

    if (_isInquiryScreen(targetScreen, type)) {
      final demoId = payload.demoId ?? '';
      final isOwner = payload.data['isOwner'] == true ||
          payload.data['isOwner']?.toString() == 'true' ||
          payload.data['role']?.toString().toUpperCase() == 'OWNER';
      currentState.push(
        MaterialPageRoute(
          builder: (_) => InquiriesPage(
            demoId: demoId,
            isOwner: isOwner,
          ),
        ),
      );
      return;
    }

    if (_isStatsOrReportScreen(targetScreen, type)) {
      final demoId = payload.demoId ?? '';
      final demoName = payload.data['demoName']?.toString() ??
          payload.data['name']?.toString() ??
          '';
      currentState.push(
        MaterialPageRoute(
          builder: (_) => DemoStatsPage(
            demoId: demoId,
            demoName: demoName,
          ),
        ),
      );
      return;
    }

    if (_isChatScreen(targetScreen, type)) {
      final departmentId = payload.departmentId ?? '';
      final demoId = payload.demoId ?? '';
      currentState.push(
        MaterialPageRoute(
          builder: (_) => DepartmentChatScreen(
            departmentId: departmentId,
            demoId: demoId,
          ),
        ),
      );
      return;
    }

    if (_isDepartmentScreen(targetScreen, type)) {
      final demoId = payload.demoId ?? '';
      currentState.push(
        MaterialPageRoute(
          builder: (_) => DepartmentMainPage(
            demoId: demoId,
          ),
        ),
      );
      return;
    }

    if (_isCourseScreen(targetScreen, type)) {
      final courseId = payload.courseId ?? '';
      final demoId = payload.demoId ?? '';
      final assetId = payload.data['assetId']?.toString();
      final userDemoId = payload.data['userDemoId']?.toString() ?? demoId;

      if (assetId != null && assetId.isNotEmpty) {
        currentState.push(
          MaterialPageRoute(
            builder: (_) => CourseDetailsScreen.fromDemo(
              demoId: demoId,
              assetId: assetId,
            ),
          ),
        );
      } else {
        currentState.push(
          MaterialPageRoute(
            builder: (_) => CourseDetailsScreen.fromLibrary(
              courseId: courseId,
              userDemoId: userDemoId,
            ),
          ),
        );
      }
      return;
    }

    if (_isLiveStreamScreen(targetScreen, type)) {
      final departmentId = payload.departmentId ?? '';
      final demoId = payload.demoId ?? '';
      currentState.push(
        MaterialPageRoute(
          builder: (_) => LiveStreamsPage(
            departmentId: departmentId,
            demoId: demoId,
          ),
        ),
      );
      return;
    }

    if (_isCertificationsScreen(targetScreen, type)) {
      currentState.push(
        MaterialPageRoute(
          builder: (_) => const MyCertificationsPage(),
        ),
      );
      return;
    }

    if (_isProfileScreen(targetScreen, type)) {
      currentState.push(
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        ),
      );
      return;
    }

    // Default to notifications list page
    currentState.push(
      MaterialPageRoute(
        builder: (_) => const NotificationsPage(),
      ),
    );
  }

  static bool _isInvitationScreen(String screen, String type) {
    return screen.contains('invit') ||
        type.contains('invit') ||
        screen == 'demo_invitations' ||
        screen == 'demoinvitations';
  }

  static bool _isInquiryScreen(String screen, String type) {
    return screen.contains('inquir') ||
        type.contains('inquir') ||
        screen == 'inquiry_details';
  }

  static bool _isStatsOrReportScreen(String screen, String type) {
    return screen.contains('stat') ||
        screen.contains('report') ||
        type.contains('stat') ||
        type.contains('report');
  }

  static bool _isChatScreen(String screen, String type) {
    return screen.contains('chat') ||
        screen.contains('message') ||
        type.contains('chat') ||
        type.contains('message');
  }

  static bool _isDepartmentScreen(String screen, String type) {
    return screen.contains('department') || type.contains('department');
  }

  static bool _isCourseScreen(String screen, String type) {
    return screen.contains('course') ||
        screen.contains('lesson') ||
        type.contains('course');
  }

  static bool _isLiveStreamScreen(String screen, String type) {
    return screen.contains('live') ||
        screen.contains('stream') ||
        type.contains('live');
  }

  static bool _isCertificationsScreen(String screen, String type) {
    return screen.contains('cert') || type.contains('cert');
  }

  static bool _isProfileScreen(String screen, String type) {
    return screen.contains('profile') || type.contains('profile');
  }
}

