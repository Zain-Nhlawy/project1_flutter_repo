# 🔔 FCM Push Notifications Documentation

This document explains the complete implementation of **Firebase Cloud Messaging (FCM) Push Notifications** in this Flutter project. It is structured according to **Clean Architecture** principles and integrates seamlessly with the existing GetIt Dependency Injection, Dio HTTP Client, Authentication System, Global Navigation, Localization, and Theme.

---

## 📐 1. Architecture Overview

The notification feature is located inside `lib/features/notifications/` and follows a 3-layer Clean Architecture:

```
lib/features/notifications/
│
├── data/
│   ├── data_sources/
│   │   ├── device_info_data_source.dart      # Gets actual device model dynamically
│   │   └── notification_remote_data_source.dart # Calls POST /notifications/fcm-token
│   ├── models/
│   │   ├── fcm_token_request_model.dart      # Request DTO for FCM token endpoint
│   │   └── notification_payload_model.dart    # Converts RemoteMessage / JSON to entity
│   └── repository/
│       └── notification_repository_impl.dart # Maps exceptions to Failures (Either<Failure, void>)
│
├── domain/
│   ├── entities/
│   │   └── notification_payload_entity.dart  # Data entity representing notification content
│   ├── repository/
│   │   └── notification_repository.dart      # Abstract repository contract
│   └── use_case/
│       └── register_fcm_token_usecase.dart   # Executes token registration logic
│
└── presentation/
    └── services/
        ├── notification_service.dart          # Main service managing FCM listeners & local display
        └── notification_navigation_handler.dart # Extensible router for notification taps
```

---

## 🧠 2. How the Whole Flow Works (Step-by-Step)

```
1. App Bootstrap (main.dart)
   └── setupDI() registers NotificationService & dependencies in GetIt.
   └── NotificationService.initialize() is called.
   └── Requests notification permissions from OS.
   └── Sets up foreground (onMessage), background (onBackgroundMessage), and tap listeners.

2. User Authentication (UserCubit / AuthCubit)
   └── User logs in OR active session is loaded (UserLoaded / LoginSuccess).
   └── MultiBlocListener in main.dart calls NotificationService.registerToken().

3. Token Registration
   └── FirebaseMessaging.instance.getToken() retrieves FCM token string.
   └── DeviceInfoDataSource retrieves actual device model (e.g. "SM-A556E").
   └── RegisterFcmTokenUseCase sends POST /notifications/fcm-token via DioClient.

4. Token Refresh Listener
   └── FirebaseMessaging.instance.onTokenRefresh listens for new tokens.
   └── Re-registers new token with backend automatically if user is logged in.
```

---

## ⚡ 3. Handling Notifications in All App States

| App State | Trigger Event | How It Is Handled |
| :--- | :--- | :--- |
| **Foreground** (App Open & Active) | `FirebaseMessaging.onMessage` | 1. Shows a system status-bar notification via `FlutterLocalNotificationsPlugin`.<br>2. Displays a floating, themed Snackbar/Banner using `AppTheme`, `AppColors`, and `AppTextStyles`. |
| **Background** (App Minimized / In Recent Apps) | `FirebaseMessaging.onBackgroundMessage` | Processed by top-level `@pragma('vm:entry-point') Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)` entry point. No `BuildContext` or UI calls. |
| **Terminated** (App Force Closed) | `FirebaseMessaging.instance.getInitialMessage()` | When the user launches the app by tapping a notification, `checkInitialMessage()` catches the payload and routes the user using `NotificationNavigationHandler`. |
| **Notification Tap** (App in Background) | `FirebaseMessaging.onMessageOpenedApp` | Passes the `RemoteMessage` to `NotificationNavigationHandler.handleNotificationTap(payload)` using `navigatorKey`. |

---

## 📦 4. Detailed Component & File Responsibilities

### 🔹 Data Layer

1. **[device_info_data_source.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/data/data_sources/device_info_data_source.dart)**
   - Uses `device_info_plus` to dynamically detect the actual device model.
   - Android: returns actual model string (e.g. `SM-A556E` or `Pixel 7`).
   - iOS: returns machine model string (e.g. `iPhone15,2`).
   - Web / Desktop / Fallbacks: handled gracefully without throwing exceptions.

2. **[fcm_token_request_model.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/data/models/fcm_token_request_model.dart)**
   - Formats payload JSON sent to the backend:
     ```json
     {
       "token": "actual_fcm_token",
       "deviceModel": "SM-A556E"
     }
     ```

3. **[notification_remote_data_source.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/data/data_sources/notification_remote_data_source.dart)**
   - Calls `POST /notifications/fcm-token` using existing `DioClient`.
   - Uses `mapDioException` to catch and convert HTTP/Network errors.

4. **[notification_repository_impl.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/data/repository/notification_repository_impl.dart)**
   - Implementation of `NotificationRepository`. Wraps data calls with error mapping to return `Either<Failure, void>`.

5. **[notification_payload_model.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/data/models/notification_payload_model.dart)**
   - Safely parses incoming `RemoteMessage` or `Map<String, dynamic>` into a unified `NotificationPayloadEntity`.

---

### 🔹 Domain Layer

1. **[notification_payload_entity.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/domain/entities/notification_payload_entity.dart)**
   - Pure domain object representing a notification's `title`, `body`, `type`, and custom `data` payload map.
   - Provides a helper `targetId` getter that automatically extracts IDs such as `orderId`, `courseId`, `departmentId`, `messageId`, etc.

2. **[notification_repository.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/domain/repository/notification_repository.dart)**
   - Domain contract interface.

3. **[register_fcm_token_usecase.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/domain/use_case/register_fcm_token_usecase.dart)**
   - Single-responsibility Use Case for registering the token.

---

### 🔹 Presentation Layer & Services

1. **[notification_service.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/presentation/services/notification_service.dart)**
   - Central notification orchestrator registered in `GetIt`.
   - Manages permission requests, token generation, token refresh listener (`onTokenRefresh`), local notification setup, and foreground/background listener setup.
   - Prevents token registration when user is not authenticated (`AppSecureStorage.read(StorageKeys.token) == null`).

2. **[notification_navigation_handler.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/features/notifications/presentation/services/notification_navigation_handler.dart)**
   - Processes notification tap actions.
   - Uses `navigatorKey.currentState` (from `main.dart`) to push screens without needing a `BuildContext` parameter.

---

### 🔹 Main App & DI Integration

1. **[service_locator.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/core/di/service_locator.dart)**
   - Registers all notification dependencies into `GetIt`:
     - `DeviceInfoDataSource`
     - `NotificationRemoteDataSource`
     - `NotificationRepository`
     - `RegisterFcmTokenUseCase`
     - `NotificationService`

2. **[main.dart](file:///c:/Users/ZAIN/StudioProjects/project1/lib/main.dart)**
   - Calls `await getIt<NotificationService>().initialize();` after `setupDI()`.
   - Uses `MultiBlocListener` listening to `UserCubit` (`UserLoaded`) and `AuthCubit` (`LoginSuccess`) to trigger `getIt<NotificationService>().registerToken()` whenever an authenticated user session is active.

---

## 🛠️ 5. How to Add New Notification Types in the Future

The notification system is designed to be **easily extensible**. When your backend starts sending new notification types (e.g., `payment`, `quiz`, `announcement`), follow these simple steps:

### Example: Adding a `quiz` Notification Type

1. **Backend Payload Example**:
   ```json
   {
     "notification": {
       "title": "New Quiz Available",
       "body": "Chapter 3 Quiz is now active!"
     },
     "data": {
       "type": "quiz",
       "quizId": "quiz_456"
     }
   }
   ```

2. **Update `NotificationNavigationHandler`**:
   Open `lib/features/notifications/presentation/services/notification_navigation_handler.dart` and add a case or register a custom handler:

   ```dart
   case 'quiz':
     final quizId = payload.targetId; // extracts quizId automatically
     if (quizId != null) {
       navigatorKey.currentState?.push(
         MaterialPageRoute(
           builder: (_) => QuizScreen(quizId: quizId),
         ),
       );
     }
     break;
   ```

   **Optionally**, you can also register modular handlers dynamically at startup:
   ```dart
   NotificationNavigationHandler.registerHandler('quiz', QuizNotificationHandler());
   ```

---

## 🛡️ 6. Security & Error Handling Guarantees

- **User Data Isolation**: Token registration checks `AppSecureStorage` for `USER_TOKEN`. Tokens are never registered for logged-out or unauthenticated sessions.
- **Fail-Safe Operation**: Failures in FCM initialization, permission denials, or backend registration errors log debug messages without crashing the application or interrupting user flows.
- **Sensitive Data Privacy**: Tokens and passwords are never logged to production output.
