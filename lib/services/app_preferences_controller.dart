import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesController extends ChangeNotifier {
  AppPreferencesController({
    ThemeMode initialThemeMode = ThemeMode.light,
    String initialLastEmail = '',
    SharedPreferences? preferences,
  })  : _themeMode = initialThemeMode,
        _lastEmail = initialLastEmail,
        _preferences = preferences;

  static const _themeModeStorageKey = 'app.themeMode';
  static const _lastEmailStorageKey = 'auth.lastEmail';

  ThemeMode _themeMode;
  String _lastEmail;
  final SharedPreferences? _preferences;

  ThemeMode get themeMode => _themeMode;
  String get lastEmail => _lastEmail;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  static Future<AppPreferencesController> create() async {
    final preferences = await SharedPreferences.getInstance();
    final themeMode = preferences.getString(_themeModeStorageKey);
    final lastEmail = preferences.getString(_lastEmailStorageKey) ?? '';

    return AppPreferencesController(
      initialThemeMode: _themeModeFromStorage(themeMode),
      initialLastEmail: lastEmail,
      preferences: preferences,
    );
  }

  Future<void> setThemeMode(ThemeMode value) async {
    if (_themeMode == value) {
      return;
    }

    _themeMode = value;
    notifyListeners();
    await _preferences?.setString(_themeModeStorageKey, _themeModeToStorage(value));
  }

  Future<void> toggleThemeMode() {
    return setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> saveLastEmail(String value) async {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty || trimmedValue == _lastEmail) {
      return;
    }

    _lastEmail = trimmedValue;
    notifyListeners();
    await _preferences?.setString(_lastEmailStorageKey, trimmedValue);
  }

  static ThemeMode _themeModeFromStorage(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  static String _themeModeToStorage(ThemeMode value) {
    switch (value) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
      case ThemeMode.system:
        return 'light';
    }
  }
}