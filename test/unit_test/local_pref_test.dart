import 'package:excel_manager/services/shared_pref/shared_pref_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPrefsService prefsService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefsService = await SharedPrefsService.init();
  });

  group('SharedPrefsService', () {
    test('default dark mode should be false', () {
      expect(prefsService.isDarkMode, false);
    });

    test('setDarkMode should save value correctly', () async {
      await prefsService.setDarkMode(value: true);
      expect(prefsService.isDarkMode, true);

      await prefsService.setDarkMode(value: false);
      expect(prefsService.isDarkMode, false);
    });

    test('authToken should be null by default', () {
      expect(prefsService.authToken, null);
      expect(prefsService.isLoggedIn, false);
    });

    test('saveAuthToken should store token', () async {
      await prefsService.saveAuthToken('token123');
      expect(prefsService.authToken, 'token123');
      expect(prefsService.isLoggedIn, true);
    });

    test('clearAuthToken should remove token', () async {
      await prefsService.saveAuthToken('token123');
      expect(prefsService.isLoggedIn, true);

      await prefsService.clearAuthToken();
      expect(prefsService.authToken, null);
      expect(prefsService.isLoggedIn, false);
    });
  });
}
