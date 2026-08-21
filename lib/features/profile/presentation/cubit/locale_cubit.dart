import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/services/app_language_service.dart';

class LocaleCubit extends Cubit<Locale> {
  final AppLanguageService languageService;

  LocaleCubit({required this.languageService})
    : super(Locale(languageService.currentLanguage));

  Future<void> loadLocale() async {
    await languageService.initialize();
    emit(Locale(languageService.currentLanguage));
  }

  Future<void> changeLanguage(String languageCode) async {
    final normalizedLanguage = languageService.updateLanguage(languageCode);
    emit(Locale(normalizedLanguage));
    try {
      await languageService.persistCurrentLanguage();
    } catch (_) {}
  }
}
