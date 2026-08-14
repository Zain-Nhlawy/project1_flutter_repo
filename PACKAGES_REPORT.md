# 📦 Flutter Dependencies Comprehensive Audit & Analysis Report

> **Project:** `project1`  
> **Date:** August 14, 2026  
> **Target:** `pubspec.yaml` (All direct `dependencies` and `dev_dependencies`)  
> **Total Analyzed Packages:** 37 Packages (36 Runtime Dependencies + 1 Dev Dependency)

---

## 📊 Executive Summary & Key Findings

| Metric | Count | Details |
| :--- | :---: | :--- |
| **Active Packages Used in Code** | **34** | Core business logic, UI, networking, and media |
| **Unused / Redundant Packages** | **3** | `cupertino_icons` (0 usages), `url_launcher` (0 usages), `flutter_launcher_icons` (placed in runtime dependencies instead of `dev_dependencies`) |
| **Extremely Heavy Packages** | **1** | `jitsi_meet_flutter_sdk` (~40–60 MB native WebRTC & React Native engine footprint) |
| **Heavy / Dual-Engine Packages** | **3** | `flutter_inappwebview` + `webview_flutter` (dual WebView redundancy), `better_player_plus` |
| **Outdated Packages Needing Major Updates** | **8** | `get_it` (7.7.0 ➔ 9.2.1), `file_picker` (8.3.7 ➔ 12.0.0), `flutter_local_notifications` (18.0.1 ➔ 22.3.0), `permission_handler` (11.4.0 ➔ 13.0.1), `device_info_plus` (11.5.0 ➔ 13.2.0), `pinput` (5.0.2 ➔ 6.0.2), `app_links` (6.4.1 ➔ 7.2.1), `flutter_secure_storage` (10.3.1 ➔ 11.0.0) |
| **Discontinued / Unmaintained Packages** | **2** | `dartz` (Archived/stale since 2021), `video_thumbnail` (Archived since 2021) |

---

## 🚨 Top 4 Optimization Recommendations

1. **Remove Unused Dependencies:**
   - **`cupertino_icons`**: Completely unused (0 occurrences in `lib/`).
   - **`url_launcher`**: Declared but not invoked in any code file.
2. **Move Dev Tools to `dev_dependencies`:**
   - **`flutter_launcher_icons`**: CLI code generator placed under runtime `dependencies:`. Move it to `dev_dependencies:`.
3. **Resolve Duplicate WebView Engines:**
   - The project imports **both** `webview_flutter` and `flutter_inappwebview`. Having two distinct native WebView bridge libraries bloats the final APK/AAB and iOS bundle. Standardize on one.
4. **Offline Font Strategy:**
   - `google_fonts` is loaded at runtime in `main.dart` for the `Cairo` font fallback, despite having local offline fonts (`PlusJakartaSans`, `CormorantGaramond`) in `assets/fonts/`. Download `Cairo` to `assets/fonts/` and drop `google_fonts` to guarantee instant offline rendering and remove runtime HTTP font fetching.

---

## 📋 Comprehensive Package-by-Package Report

---

### 1. `cupertino_icons`
- **Declared Version:** `^1.0.8`
- **Locked Version:** `1.0.9`
- **Latest Version Available:** `1.0.9` (Up to date)
- **Pub Cache Size:** ~674.2 KB
- **Used in Code:** ❌ **NO (0 occurrences in `lib/` and `test/`)**
- **Is it heavy for the app?:** **Low** (Adds ~280 KB font asset to build), but unnecessary if unused.
- **Better / Modern Alternatives:** Flutter Material Icons (`Icons.*`), `lucide_icons`, `flutter_svg`.
- **Recommendation:** **Remove from `pubspec.yaml`** to clean up the bundle.
- **Documentation Link:** [https://pub.dev/packages/cupertino_icons](https://pub.dev/packages/cupertino_icons)

---

### 2. `flutter_bloc`
- **Declared Version:** `^9.1.1`
- **Locked Version:** `9.1.1`
- **Latest Version Available:** `9.1.1` (Up to date)
- **Pub Cache Size:** ~603.0 KB
- **Used in Code:** ✅ **YES (118 files in `lib/`, 1 test file)**
  - *Used in:* `lib/main.dart`, `session_cubit.dart`, `auth_cubit.dart`, `course_cubit.dart`, `department_cubit.dart`, and 113+ other presentation cubits and pages.
- **Is it heavy for the app?:** **Negligible / Ultra-Light** (Pure Dart state management logic with zero native overhead).
- **Better / Modern Alternatives:** `flutter_riverpod` (more modern, boilerplate-free), `signals`.
- **Recommendation:** Keep as-is. It is the central architectural backbone of this project and is on the latest version.
- **Documentation Link:** [https://pub.dev/packages/flutter_bloc](https://pub.dev/packages/flutter_bloc)

---

### 3. `image_picker`
- **Declared Version:** `^1.1.0`
- **Locked Version:** `1.2.2`
- **Latest Version Available:** `1.2.3`
- **Pub Cache Size:** ~519.3 KB
- **Used in Code:** ✅ **YES (7 files in `lib/`)**
  - *Used in:* `image_picker_widget.dart`, `course_management_screen.dart`, `create_course_screen.dart`, `plan_and_image_slide.dart`, `create_lesson_screen.dart`, `profile_screen.dart`.
- **Is it heavy for the app?:** **Low** (Uses native OS system camera and photo gallery intents).
- **Better / Modern Alternatives:** `wechat_assets_picker` (for advanced gallery grids/multi-selection), `camerawesome` (for custom embedded camera UI).
- **Recommendation:** Official Flutter package. Keep and bump to `^1.2.3`.
- **Documentation Link:** [https://pub.dev/packages/image_picker](https://pub.dev/packages/image_picker)

---

### 4. `dio`
- **Declared Version:** `^5.9.2`
- **Locked Version:** `5.11.0`
- **Latest Version Available:** `5.11.0` (Up to date)
- **Pub Cache Size:** ~477.6 KB
- **Used in Code:** ✅ **YES (36 files in `lib/`, 2 test files)**
  - *Used in:* `dio_client.dart`, `api.dart`, `service_locator.dart`, and all remote data sources.
- **Is it heavy for the app?:** **Low** (Pure Dart HTTP client with streaming and interceptor capabilities).
- **Better / Modern Alternatives:** `http` (simpler, but lacks interceptors/auto-refresh), `chopper` (code-generated client).
- **Recommendation:** Keep as-is. Best-in-class HTTP client in the Flutter ecosystem.
- **Documentation Link:** [https://pub.dev/packages/dio](https://pub.dev/packages/dio)

---

### 5. `flutter_secure_storage`
- **Declared Version:** `^10.2.0`
- **Locked Version:** `10.3.1`
- **Latest Version Available:** `11.0.0` (Major update available)
- **Pub Cache Size:** ~952.6 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/core/storage/secure_storage.dart`.
- **Is it heavy for the app?:** **Low** (Uses native Android KeyStore / EncryptedSharedPreferences and iOS Keychain).
- **Better / Modern Alternatives:** `hive_flutter` with AES-256 encryption.
- **Recommendation:** Upgrade to `^11.0.0` for latest Android 14/15 and iOS 18 Keychain compatibility.
- **Documentation Link:** [https://pub.dev/packages/flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)

---

### 6. `socket_io_client`
- **Declared Version:** `^3.0.2`
- **Locked Version:** `3.1.6`
- **Latest Version Available:** `3.1.6` (Up to date)
- **Pub Cache Size:** ~217.6 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/department_chat/data/data_sources/department_chat_socket_datasource.dart`.
- **Is it heavy for the app?:** **Low** (Pure Dart WebSocket / Engine.IO protocol parser).
- **Better / Modern Alternatives:** Standard `web_socket_channel` (if backend transitions to vanilla WebSockets).
- **Recommendation:** Keep if your chat backend runs on a Node.js Socket.IO server.
- **Documentation Link:** [https://pub.dev/packages/socket_io_client](https://pub.dev/packages/socket_io_client)

---

### 7. `get_it`
- **Declared Version:** `^7.7.0`
- **Locked Version:** `7.7.0`
- **Latest Version Available:** `9.2.1` (Major update available: v9.2.1)
- **Pub Cache Size:** ~635.6 KB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `lib/core/di/service_locator.dart`, `lib/features/home/presentation/pages/home_page.dart`.
- **Is it heavy for the app?:** **Negligible** (Microscopic Dart hash map lookup registry).
- **Better / Modern Alternatives:** `injectable` (code-generator layer on top of `get_it`).
- **Recommendation:** Upgrade to `^9.2.1` for improved null-safety, async resolution, and scoping features.
- **Documentation Link:** [https://pub.dev/packages/get_it](https://pub.dev/packages/get_it)

---

### 8. `flutter_dotenv`
- **Declared Version:** `^6.0.1`
- **Locked Version:** `6.0.1`
- **Latest Version Available:** `6.0.1` (Up to date)
- **Pub Cache Size:** ~454.3 KB
- **Used in Code:** ✅ **YES (2 files in `lib/`, 1 test file)**
  - *Used in:* `lib/core/di/service_locator.dart`, `lib/main.dart`.
- **Is it heavy for the app?:** **Negligible** (Simple `.env` file string parser).
- **Better / Modern Alternatives:** Flutter native `--dart-define-from-file=.env` with `String.fromEnvironment()` (More secure because keys are compiled directly into binary without shipping `.env` plaintext in the APK asset folder).
- **Recommendation:** Keep for convenience, or migrate to `--dart-define-from-file` for production hardening.
- **Documentation Link:** [https://pub.dev/packages/flutter_dotenv](https://pub.dev/packages/flutter_dotenv)

---

### 9. `jwt_decoder`
- **Declared Version:** `^2.0.1`
- **Locked Version:** `2.0.1`
- **Latest Version Available:** `2.0.1` (Up to date)
- **Pub Cache Size:** ~12.3 KB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `lib/core/network/dio_client.dart`, `lib/features/auth/auth_token_manager.dart`.
- **Is it heavy for the app?:** **Negligible** (~12 KB).
- **Better / Modern Alternatives:** Can be replaced with a single 10-line native helper using `dart:convert` (`utf8.decode(base64Url.decode(...))`) to eliminate an external package.
- **Recommendation:** Keep or replace with internal 10-line helper.
- **Documentation Link:** [https://pub.dev/packages/jwt_decoder](https://pub.dev/packages/jwt_decoder)

---

### 10. `app_links`
- **Declared Version:** `^6.4.0`
- **Locked Version:** `6.4.1`
- **Latest Version Available:** `7.2.1` (Major update available)
- **Pub Cache Size:** ~583.8 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/main.dart`.
- **Is it heavy for the app?:** **Low** (Lightweight intent/universal link listener).
- **Better / Modern Alternatives:** `go_router` deep link integration.
- **Recommendation:** Modern replacement for dead `uni_links`. Upgrade to `^7.2.1`.
- **Documentation Link:** [https://pub.dev/packages/app_links](https://pub.dev/packages/app_links)

---

### 11. `better_player_plus`
- **Declared Version:** `^1.1.2`
- **Locked Version:** `1.1.5`
- **Latest Version Available:** `1.3.5`
- **Pub Cache Size:** ~745.6 KB (+ Native ExoPlayer & AVPlayer dependencies ~6–10 MB)
- **Used in Code:** ✅ **YES (3 files in `lib/`)**
  - *Used in:* `lesson_details_screen.dart`, `video_controls.dart`, `video_duration_helper.dart`.
- **Is it heavy for the app?:** ⚠️ **HEAVY** (Bundles full ExoPlayer caching, HLS/DASH streaming engines, and background audio services).
- **Better / Modern Alternatives:** `media_kit` (Blazing fast, libmpv-based, modular, smaller memory footprint), `video_player` + `chewie` (Lighter official solution).
- **Recommendation:** Update to `^1.3.5`. If experiencing memory spikes or performance bottlenecks on Android/iOS, evaluate `media_kit`.
- **Documentation Link:** [https://pub.dev/packages/better_player_plus](https://pub.dev/packages/better_player_plus)

---

### 12. `dartz`
- **Declared Version:** `^0.10.1`
- **Locked Version:** `0.10.1`
- **Latest Version Available:** `0.10.1` (⚠️ Discontinued / Unmaintained since 2021)
- **Pub Cache Size:** ~420.0 KB
- **Used in Code:** ✅ **YES (157 files across `lib/` and `test/`)**
  - *Used in:* All Clean Architecture UseCases and Repositories for `Either<Failure, T>`.
- **Is it heavy for the app?:** **Low** (Pure Dart library).
- **Better / Modern Alternatives:** `fpdart` (Modern, active functional programming package), Dart 3 sealed class `Result<T, E>` pattern.
- **Recommendation:** Heavily entrenched in 157 files. Do not rewrite immediately, but do not introduce in new modules; prefer `fpdart` or native Dart 3 `sealed class Result`.
- **Documentation Link:** [https://pub.dev/packages/dartz](https://pub.dev/packages/dartz)

---

### 13. `google_sign_in`
- **Declared Version:** `^7.1.0`
- **Locked Version:** `7.2.0`
- **Latest Version Available:** `7.2.0` (Up to date)
- **Pub Cache Size:** ~430.3 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/auth/presentation/cubit/auth_cubit.dart`.
- **Is it heavy for the app?:** **Medium** (Pulls Google Play Services Auth on Android and GoogleSignIn SDK on iOS).
- **Better / Modern Alternatives:** None (Official Flutter team package).
- **Recommendation:** Keep as-is. Best package for Google OAuth authentication.
- **Documentation Link:** [https://pub.dev/packages/google_sign_in](https://pub.dev/packages/google_sign_in)

---

### 14. `webview_flutter`
- **Declared Version:** `^4.13.1`
- **Locked Version:** `4.13.1`
- **Latest Version Available:** `4.14.1`
- **Pub Cache Size:** ~1.71 MB
- **Used in Code:** ✅ **YES (3 files in `lib/`)**
  - *Used in:* `checkout_webview_screen.dart`, `payment_webview.dart`, `diagram_page.dart`.
- **Is it heavy for the app?:** **Medium-to-Heavy** (Platform WebView bridge).
- **Better / Modern Alternatives:** `flutter_inappwebview` (more feature-packed).
- **CRITICAL ISSUE:** The project includes **BOTH** `webview_flutter` AND `flutter_inappwebview`. Standardize on one engine to eliminate redundant native bridges.
- **Documentation Link:** [https://pub.dev/packages/webview_flutter](https://pub.dev/packages/webview_flutter)

---

### 15. `path_provider`
- **Declared Version:** `^2.1.4`
- **Locked Version:** `2.1.5`
- **Latest Version Available:** `2.1.6`
- **Pub Cache Size:** ~335.8 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/core/services/remote_file_opener.dart`.
- **Is it heavy for the app?:** **Low** (Official native directory path locator).
- **Better / Modern Alternatives:** None (Standard Flutter core plugin).
- **Recommendation:** Keep and update to `^2.1.6`.
- **Documentation Link:** [https://pub.dev/packages/path_provider](https://pub.dev/packages/path_provider)

---

### 16. `pinput`
- **Declared Version:** `^5.0.1`
- **Locked Version:** `5.0.2`
- **Latest Version Available:** `6.0.2` (Major update available)
- **Pub Cache Size:** ~645.1 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/auth/presentation/pages/verify_2fa_screen.dart`.
- **Is it heavy for the app?:** **Low** (Pure Flutter UI widget).
- **Better / Modern Alternatives:** `pin_code_fields` (Less customizable).
- **Recommendation:** Best-in-class PIN/OTP input widget. Upgrade to `^6.0.2`.
- **Documentation Link:** [https://pub.dev/packages/pinput](https://pub.dev/packages/pinput)

---

### 17. `permission_handler`
- **Declared Version:** `^11.3.0`
- **Locked Version:** `11.4.0`
- **Latest Version Available:** `13.0.1` (Major update available: v13.0.1)
- **Pub Cache Size:** ~277.6 KB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `diagram_page.dart`, `photopea_editor_page.dart`.
- **Is it heavy for the app?:** **Low-to-Medium** (Native permission dispatchers).
- **Better / Modern Alternatives:** None (Flutter Community standard).
- **Recommendation:** Upgrade to `^13.0.1` for full Android 14/15 and iOS 17/18 permission model support.
- **Documentation Link:** [https://pub.dev/packages/permission_handler](https://pub.dev/packages/permission_handler)

---

### 18. `flutter_inappwebview`
- **Declared Version:** `^6.1.5`
- **Locked Version:** `6.1.5`
- **Latest Version Available:** `6.1.5` (Up to date)
- **Pub Cache Size:** ~3.64 MB (+ Native bridge libraries)
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/integrations/photopea/presentation/pages/photopea_editor_page.dart`.
- **Is it heavy for the app?:** ⚠️ **HEAVY** (~5–10 MB native footprint with advanced JS channels, service workers, and media controllers).
- **Better / Modern Alternatives:** `webview_flutter` (simpler, lighter, but has fewer JS bridging APIs).
- **Recommendation:** Needed for Photopea's advanced JavaScript interface. Migrate `diagram_page` and payment screens to use `flutter_inappwebview` so you can remove `webview_flutter`.
- **Documentation Link:** [https://pub.dev/packages/flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)

---

### 19. `file_picker`
- **Declared Version:** `^8.0.0`
- **Locked Version:** `8.3.7`
- **Latest Version Available:** `12.0.0` (Major update available: v12.0.0)
- **Pub Cache Size:** ~18.2 MB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `lesson_attachments_manager.dart`, `chat_input_bar.dart`.
- **Is it heavy for the app?:** **Medium** (Native SAF on Android, DocumentPicker on iOS).
- **Better / Modern Alternatives:** None (Community standard).
- **Recommendation:** Upgrade to `^12.0.0` for latest Android PhotoPicker and scoped storage compatibility.
- **Documentation Link:** [https://pub.dev/packages/file_picker](https://pub.dev/packages/file_picker)

---

### 20. `video_thumbnail`
- **Declared Version:** `^0.5.3`
- **Locked Version:** `0.5.6`
- **Latest Version Available:** `0.5.6` (⚠️ Discontinued / Unmaintained since 2021)
- **Pub Cache Size:** ~352.5 KB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `create_lesson_screen.dart`, `lesson_management_screen.dart`.
- **Is it heavy for the app?:** **Low** (Uses legacy Android/iOS video frame extractors).
- **Better / Modern Alternatives:** `get_thumbnail_video` (active fork), `fc_native_video_thumbnail`.
- **Recommendation:** Replace with `get_thumbnail_video` or `fc_native_video_thumbnail` to avoid Android Gradle 8+ build errors and deprecated API warnings.
- **Documentation Link:** [https://pub.dev/packages/video_thumbnail](https://pub.dev/packages/video_thumbnail)

---

### 21. `url_launcher`
- **Declared Version:** `^6.3.0`
- **Locked Version:** `6.3.2`
- **Latest Version Available:** `6.3.2` (Up to date)
- **Pub Cache Size:** ~403.1 KB
- **Used in Code:** ❌ **NO (0 occurrences in `lib/`)**
- **Is it heavy for the app?:** **Low** (System intent launcher).
- **Better / Modern Alternatives:** None (Official Flutter package).
- **Recommendation:** If you plan to open web links or phone dials, use `launchUrl()`. If not needed, **remove from `pubspec.yaml`**.
- **Documentation Link:** [https://pub.dev/packages/url_launcher](https://pub.dev/packages/url_launcher)

---

### 22. `awesome_snackbar_content`
- **Declared Version:** `^0.1.1`
- **Locked Version:** `0.1.8`
- **Latest Version Available:** `0.1.8` (Up to date)
- **Pub Cache Size:** ~85.6 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/config/theme/snackbar_theme.dart`.
- **Is it heavy for the app?:** **Negligible** (Pure Flutter UI widgets and SVGs).
- **Better / Modern Alternatives:** `toastification` (significantly more advanced, stacked toasts, custom dismiss gestures), `delightful_toast`.
- **Recommendation:** Keep as-is or consider `toastification` for a cleaner modern toast design system.
- **Documentation Link:** [https://pub.dev/packages/awesome_snackbar_content](https://pub.dev/packages/awesome_snackbar_content)

---

### 23. `open_filex`
- **Declared Version:** `^4.5.0`
- **Locked Version:** `4.7.0`
- **Latest Version Available:** `4.7.0` (Up to date)
- **Pub Cache Size:** ~396.1 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/core/services/remote_file_opener.dart`.
- **Is it heavy for the app?:** **Low** (Android `FileProvider` & iOS `UIDocumentInteractionController`).
- **Better / Modern Alternatives:** None (`open_filex` is the community fork of dead `open_file`).
- **Recommendation:** Keep as-is.
- **Documentation Link:** [https://pub.dev/packages/open_filex](https://pub.dev/packages/open_filex)

---

### 24. `intl`
- **Declared Version:** `^0.20.2`
- **Locked Version:** `0.20.2`
- **Latest Version Available:** `0.20.3`
- **Pub Cache Size:** ~2.17 MB (CLDR database tables)
- **Used in Code:** ✅ **YES (7 files in `lib/`)**
  - *Used in:* `chat_message_bubble.dart`, `live_stream_card.dart`, `app_localizations.dart`, `app_localizations_ar.dart`, `app_localizations_en.dart`.
- **Is it heavy for the app?:** **Low-to-Medium** (Data-driven formatting).
- **Better / Modern Alternatives:** `easy_localization` (wrapper around intl), `slang`.
- **Recommendation:** Official Dart internationalization package. Keep and bump to `^0.20.3`.
- **Documentation Link:** [https://pub.dev/packages/intl](https://pub.dev/packages/intl)

---

### 25. `flutter_launcher_icons`
- **Declared Version:** `^0.13.1`
- **Locked Version:** `0.13.1`
- **Latest Version Available:** `0.14.4`
- **Pub Cache Size:** ~1.35 MB
- **Used in Code:** ❌ **NO (Config only in `pubspec.yaml` under `flutter_icons:`)**
- **Is it heavy for the app?:** **0 Runtime impact if in dev_dependencies**, but currently in runtime `dependencies:`.
- **Better / Modern Alternatives:** None.
- **CRITICAL RECOMMENDATION:** **Move from `dependencies:` to `dev_dependencies:`** in `pubspec.yaml` and update to `^0.14.4`.
- **Documentation Link:** [https://pub.dev/packages/flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

---

### 26. `auto_size_text`
- **Declared Version:** `^3.0.0`
- **Locked Version:** `3.0.0`
- **Latest Version Available:** `3.0.0` (Up to date)
- **Pub Cache Size:** ~134.5 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/home/presentation/pages/Navigations_tabs.dart`.
- **Is it heavy for the app?:** **Negligible** (Pure Flutter layout logic).
- **Better / Modern Alternatives:** None.
- **Recommendation:** Rock-solid utility for responsive typography. Keep as-is.
- **Documentation Link:** [https://pub.dev/packages/auto_size_text](https://pub.dev/packages/auto_size_text)

---

### 27. `animations`
- **Declared Version:** `^2.2.0`
- **Locked Version:** `2.2.0`
- **Latest Version Available:** `2.2.0` (Up to date)
- **Pub Cache Size:** ~37.15 MB (includes extensive sample galleries in pub cache)
- **Used in Code:** ✅ **YES (11 files in `lib/`)**
  - *Used in:* `OpenContainer` transforms in `Navigations_tabs.dart`, `demo_main_page_widget`, `item_card_widget.dart`, and payment pages.
- **Is it heavy for the app?:** **Low runtime footprint** (Pure Flutter widgets implementing Material Motion).
- **Better / Modern Alternatives:** `flutter_animate` (for micro-animations).
- **Recommendation:** Official Flutter package. Keep as-is.
- **Documentation Link:** [https://pub.dev/packages/animations](https://pub.dev/packages/animations)

---

### 28. `firebase_core`
- **Declared Version:** `^4.12.1`
- **Locked Version:** `4.13.0`
- **Latest Version Available:** `4.13.0` (Up to date)
- **Pub Cache Size:** ~632.2 KB
- **Used in Code:** ✅ **YES (3 files in `lib/`)**
  - *Used in:* `notification_service.dart`, `firebase_options.dart`, `main.dart`.
- **Is it heavy for the app?:** **Medium** (Initializes native Firebase C++/Java/Obj-C SDKs).
- **Better / Modern Alternatives:** None.
- **Recommendation:** Core prerequisite for Firebase. Keep as-is.
- **Documentation Link:** [https://pub.dev/packages/firebase_core](https://pub.dev/packages/firebase_core)

---

### 29. `firebase_messaging`
- **Declared Version:** `^16.4.3`
- **Locked Version:** `16.5.0`
- **Latest Version Available:** `16.5.0` (Up to date)
- **Pub Cache Size:** ~1.08 MB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `notification_payload_model.dart`, `notification_service.dart`.
- **Is it heavy for the app?:** **Medium** (Background services, Google Play Services / APNs).
- **Better / Modern Alternatives:** `onesignal_flutter` (if switching push notification providers).
- **Recommendation:** Keep as-is.
- **Documentation Link:** [https://pub.dev/packages/firebase_messaging](https://pub.dev/packages/firebase_messaging)

---

### 30. `device_info_plus`
- **Declared Version:** `^11.3.0`
- **Locked Version:** `11.5.0`
- **Latest Version Available:** `13.2.0` (Major update available: v13.2.0)
- **Pub Cache Size:** ~559.8 KB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/notifications/data/data_sources/device_info_data_source.dart`.
- **Is it heavy for the app?:** **Low** (Platform device metadata queries).
- **Better / Modern Alternatives:** None.
- **Recommendation:** Upgrade to `^13.2.0` for full Android 15 & iOS 18 support.
- **Documentation Link:** [https://pub.dev/packages/device_info_plus](https://pub.dev/packages/device_info_plus)

---

### 31. `flutter_local_notifications`
- **Declared Version:** `^18.0.1`
- **Locked Version:** `18.0.1`
- **Latest Version Available:** `22.3.0` (Major update available: v22.3.0)
- **Pub Cache Size:** ~1.71 MB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/notifications/presentation/services/notification_service.dart`.
- **Is it heavy for the app?:** **Medium** (Native foreground/background notification handlers).
- **Better / Modern Alternatives:** None (Most comprehensive local notification library).
- **Recommendation:** Upgrade to `^22.3.0` for latest Android 13+ runtime notification permissions and iOS 16+ foreground presentation options.
- **Documentation Link:** [https://pub.dev/packages/flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

---

### 32. `google_fonts`
- **Declared Version:** `^8.1.0`
- **Locked Version:** `8.1.0`
- **Latest Version Available:** `8.2.1`
- **Pub Cache Size:** ~9.25 MB
- **Used in Code:** ✅ **YES (Minimal / 1 line in `lib/main.dart`)**
  - *Used only on line 136:* `GoogleFonts.cairo().fontFamily` for Arabic font fallback.
- **Is it heavy for the app?:** ⚠️ **MEDIUM-TO-HIGH RISK** (Fetches fonts over HTTP dynamically, causing potential FOIT/FOUT or failure in offline mode).
- **Better / Modern Alternatives:** Bundle `.ttf` font files locally in `assets/fonts/` (which you already do for `PlusJakartaSans` and `CormorantGaramond`).
- **Recommendation:** Download `Cairo-Regular.ttf` & `Cairo-Bold.ttf` into `assets/fonts/`, add them under `fonts:` in `pubspec.yaml`, and **remove `google_fonts`** to guarantee 100% offline support and remove runtime network calls.
- **Documentation Link:** [https://pub.dev/packages/google_fonts](https://pub.dev/packages/google_fonts)

---

### 33. `pdf`
- **Declared Version:** `^3.12.0`
- **Locked Version:** `3.12.0`
- **Latest Version Available:** `3.13.0`
- **Pub Cache Size:** ~1.31 MB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `certificate_preview_page.dart`, `roadmap_pdf_service.dart`.
- **Is it heavy for the app?:** **Low** (Pure Dart vector PDF creation).
- **Better / Modern Alternatives:** None (De-facto industry standard).
- **Recommendation:** Keep and update to `^3.13.0`.
- **Documentation Link:** [https://pub.dev/packages/pdf](https://pub.dev/packages/pdf)

---

### 34. `printing`
- **Declared Version:** `^5.14.3`
- **Locked Version:** `5.14.3`
- **Latest Version Available:** `5.15.0`
- **Pub Cache Size:** ~2.64 MB
- **Used in Code:** ✅ **YES (1 file in `lib/`)**
  - *Used in:* `lib/features/department/presentation/widgets/roadMap widgets/roadmap_pdf_service.dart`.
- **Is it heavy for the app?:** **Medium** (Includes Pdfium native rasterizers and OS print spoolers).
- **Better / Modern Alternatives:** None (Official companion for `pdf`).
- **Recommendation:** Keep and update to `^5.15.0`.
- **Documentation Link:** [https://pub.dev/packages/printing](https://pub.dev/packages/printing)

---

### 35. `public_file_saver`
- **Declared Version:** `^1.1.0`
- **Locked Version:** `1.1.0`
- **Latest Version Available:** `1.1.0` (Up to date)
- **Pub Cache Size:** ~260.1 KB
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `attachment_tile.dart`, `certificate_preview_page.dart`.
- **Is it heavy for the app?:** **Low** (Native MediaStore / Files app saving bridge).
- **Better / Modern Alternatives:** `gal` (for gallery pictures/videos), `saver_gallery`.
- **Recommendation:** Keep as-is for saving generic certificates and lesson attachments.
- **Documentation Link:** [https://pub.dev/packages/public_file_saver](https://pub.dev/packages/public_file_saver)

---

### 36. `jitsi_meet_flutter_sdk`
- **Declared Version:** `^11.6.0`
- **Locked Version:** `11.6.0`
- **Latest Version Available:** `13.1.1` (Major update available: v13.1.1)
- **Pub Cache Size:** ~461.5 KB (Dart wrapper) + 🔴 **~40 MB to 60 MB Native Binaries** (Full WebRTC C++ binaries, React Native core, LibJitsiMeet).
- **Used in Code:** ✅ **YES (2 files in `lib/`)**
  - *Used in:* `live_streams_page.dart`, `jitsi_meeting_service.dart`.
- **Is it heavy for the app?:** 🔴 **EXTREMELY HEAVY (Highest binary size impact in entire project)**.
- **Better / Modern Alternatives:** `livekit_client` (LiveKit WebRTC in pure Flutter UI, adds only ~5 MB total), `agora_rtc_engine` (Agora SDK).
- **Recommendation:** If you want pre-built complete meeting UI without developing video room widgets, Jitsi is practical, but upgrade to `^13.1.1` for Android 14/15 camera/mic permissions and WebRTC bug fixes. If you want a smaller APK, migrate to `livekit_client`.
- **Documentation Link:** [https://pub.dev/packages/jitsi_meet_flutter_sdk](https://pub.dev/packages/jitsi_meet_flutter_sdk)

---

### 37. `flutter_lints` (dev_dependencies)
- **Declared Version:** `^5.0.0`
- **Locked Version:** `5.0.0`
- **Latest Version Available:** `6.0.0`
- **Pub Cache Size:** ~12.9 KB
- **Used in Code:** ✅ **YES (Config)** (Used in `analysis_options.yaml`).
- **Is it heavy for the app?:** **0 Runtime Impact** (Dev-only static analysis rules).
- **Better / Modern Alternatives:** `very_good_analysis` (stricter, higher quality lint rules).
- **Recommendation:** Keep in `dev_dependencies:` and update to `^6.0.0`.
- **Documentation Link:** [https://pub.dev/packages/flutter_lints](https://pub.dev/packages/flutter_lints)

---

## 🛠 Recommended Clean `pubspec.yaml` Dependencies Section

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Architecture & State Management
  flutter_bloc: ^9.1.1
  get_it: ^9.2.1
  dartz: ^0.10.1

  # Networking & Real-time
  dio: ^5.11.0
  socket_io_client: ^3.1.6
  jwt_decoder: ^2.0.1
  app_links: ^7.2.1

  # Security & Environment
  flutter_secure_storage: ^11.0.0
  flutter_dotenv: ^6.0.1
  permission_handler: ^13.0.1

  # Firebase & Notifications
  firebase_core: ^4.13.0
  firebase_messaging: ^16.5.0
  flutter_local_notifications: ^22.3.0
  device_info_plus: ^13.2.0

  # Media & Hardware
  image_picker: ^1.2.3
  file_picker: ^12.0.0
  better_player_plus: ^1.3.5
  jitsi_meet_flutter_sdk: ^13.1.1
  video_thumbnail: ^0.5.6 # Or replace with get_thumbnail_video

  # WebView & Documents
  flutter_inappwebview: ^6.1.5 # Standardize on InAppWebView across all web screens
  pdf: ^3.13.0
  printing: ^5.15.0
  open_filex: ^4.7.0
  public_file_saver: ^1.1.0
  path_provider: ^2.1.6

  # UI Components & Localization
  intl: ^0.20.3
  pinput: ^6.0.2
  auto_size_text: ^3.0.0
  animations: ^2.2.0
  awesome_snackbar_content: ^0.1.8
  google_sign_in: ^7.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.14.4 # Correctly moved to dev_dependencies
```
