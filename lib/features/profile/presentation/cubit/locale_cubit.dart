import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';

class LocaleCubit extends Cubit<Locale> {
  final AppSecureStorage storage;

  LocaleCubit({
    AppSecureStorage? storage,
    Locale initialLocale = const Locale('en'),
  })  : storage = storage ?? getIt<AppSecureStorage>(),
        super(initialLocale);

  Future<void> loadLocale() async {
    try {
      final lang = await storage.read(StorageKeys.language);
      if (lang != null && lang.isNotEmpty) {
        emit(Locale(lang));
      }
    } catch (_) {}
  }

  Future<void> changeLanguage(String languageCode) async {
    emit(Locale(languageCode));
    try {
      await storage.write(StorageKeys.language, languageCode);
    } catch (_) {}
  }
}

