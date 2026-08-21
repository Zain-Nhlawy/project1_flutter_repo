import 'package:flutter_test/flutter_test.dart';
import 'package:project1/core/services/app_language_service.dart';
import 'package:project1/core/storage/storage_keys.dart';

import '../../helpers/auth_test_fakes.dart';

void main() {
  test('loads a supported stored language', () async {
    final storage = FakeSecureStorage({StorageKeys.language: 'ar'});
    final service = AppLanguageService(storage: storage);

    await service.initialize();

    expect(service.currentLanguage, 'ar');
  });

  test('normalizes missing and unsupported languages to English', () async {
    final storage = FakeSecureStorage({StorageKeys.language: 'fr'});
    final service = AppLanguageService(storage: storage);

    await service.initialize();
    expect(service.currentLanguage, 'en');

    expect(service.updateLanguage('ar-SA'), 'en');
    expect(service.updateLanguage(null), 'en');
  });

  test('updates the current language before persisting it', () async {
    final storage = FakeSecureStorage();
    final service = AppLanguageService(storage: storage);

    final language = service.updateLanguage('ar');
    await service.persistCurrentLanguage();

    expect(language, 'ar');
    expect(service.currentLanguage, 'ar');
    expect(storage.values[StorageKeys.language], 'ar');
  });
}
