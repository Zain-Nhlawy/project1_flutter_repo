import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final AppSecureStorage storage;

  ThemeCubit({
    AppSecureStorage? storage,
    ThemeMode initialTheme = ThemeMode.light,
  })  : storage = storage ?? getIt<AppSecureStorage>(),
        super(initialTheme);

  bool get isDark => state == ThemeMode.dark;

  Future<void> loadTheme() async {
    try {
      final savedTheme = await storage.read(StorageKeys.theme);
      if (savedTheme == 'dark') {
        emit(ThemeMode.dark);
      } else if (savedTheme == 'light') {
        emit(ThemeMode.light);
      }
    } catch (_) {}
  }

  Future<void> toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(mode);
    try {
      await storage.write(StorageKeys.theme, isDark ? 'dark' : 'light');
    } catch (_) {}
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    try {
      await storage.write(
        StorageKeys.theme,
        mode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (_) {}
  }
}

