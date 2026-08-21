import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';

class AppLanguageService {
  final AppSecureStorage storage;

  String _currentLanguage = 'en';

  AppLanguageService({required this.storage});

  String get currentLanguage => _currentLanguage;

  Future<void> initialize() async {
    try {
      final storedLanguage = await storage.read(StorageKeys.language);
      _currentLanguage = normalize(storedLanguage);
    } catch (_) {
      _currentLanguage = 'en';
    }
  }

  String updateLanguage(String? languageCode) {
    _currentLanguage = normalize(languageCode);
    return _currentLanguage;
  }

  Future<void> persistCurrentLanguage() async {
    await storage.write(StorageKeys.language, _currentLanguage);
  }

  static String normalize(String? languageCode) {
    return languageCode == 'ar' ? 'ar' : 'en';
  }
}
