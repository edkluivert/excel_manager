import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {

  SharedPrefsService._(this._prefs);
  static const _keyDarkMode = 'dark_mode';
  static const _keyAuthToken = 'auth_token';

  final SharedPreferences _prefs;

  static Future<SharedPrefsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsService._(prefs);
  }

  bool get isDarkMode => _prefs.getBool(_keyDarkMode) ?? false;

  Future<void> setDarkMode({required bool value}) async {
    await _prefs.setBool(_keyDarkMode, value);
  }


  String? get authToken => _prefs.getString(_keyAuthToken);

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove(_keyAuthToken);
  }

  bool get isLoggedIn => authToken != null;
}
