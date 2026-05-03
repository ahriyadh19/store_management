import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StoragePreference { hybrid, onlineOnly, localOnly }

class AppPreferencesController extends ChangeNotifier {
  AppPreferencesController({
    ThemeMode initialThemeMode = ThemeMode.light,
    String initialLastEmail = '',
    List<String> initialRecentEmails = const [],
    String initialLastIndexPageKey = '',
    String initialWorkspaceTabsState = '',
    bool initialStickyAppBar = true,
    StoragePreference initialStoragePreference = StoragePreference.hybrid,
    SharedPreferences? preferences,
  })
    : _themeMode = initialThemeMode,
      _lastEmail = initialLastEmail,
      _recentEmails = List<String>.from(initialRecentEmails),
      _lastIndexPageKey = initialLastIndexPageKey,
       _workspaceTabsState = initialWorkspaceTabsState,
       _stickyAppBar = initialStickyAppBar,
       _storagePreference = initialStoragePreference,
      _preferences = preferences;

  static const _themeModeStorageKey = 'app.themeMode';
  static const _lastEmailStorageKey = 'auth.lastEmail';
  static const _recentEmailsStorageKey = 'auth.recentEmails';
  static const _lastIndexPageStorageKey = 'app.lastIndexPage';
  static const _workspaceTabsStateStorageKey = 'app.workspaceTabsState';
  static const _stickyAppBarStorageKey = 'app.stickyAppBar';
  static const _storagePreferenceStorageKey = 'app.storagePreference';
  static const _maxRecentEmails = 5;

  ThemeMode _themeMode;
  String _lastEmail;
  List<String> _recentEmails;
  String _lastIndexPageKey;
  String _workspaceTabsState;
  bool _stickyAppBar;
  StoragePreference _storagePreference;
  final SharedPreferences? _preferences;

  ThemeMode get themeMode => _themeMode;
  String get lastEmail => _lastEmail;
  List<String> get recentEmails => List.unmodifiable(_recentEmails);
  String get lastIndexPageKey => _lastIndexPageKey;
  String get workspaceTabsState => _workspaceTabsState;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get stickyAppBar => _stickyAppBar;
  StoragePreference get storagePreference => _storagePreference;

  static Future<AppPreferencesController> create() async {
    final preferences = await SharedPreferences.getInstance();
    final themeMode = preferences.getString(_themeModeStorageKey);
    final lastEmail = preferences.getString(_lastEmailStorageKey) ?? '';
    final recentEmails = preferences.getStringList(_recentEmailsStorageKey) ?? <String>[];
    final lastIndexPageKey = preferences.getString(_lastIndexPageStorageKey) ?? '';
    final workspaceTabsState = preferences.getString(_workspaceTabsStateStorageKey) ?? '';
    final stickyAppBar = preferences.getBool(_stickyAppBarStorageKey) ?? true;
    final storagePreference = _storagePreferenceFromStorage(preferences.getString(_storagePreferenceStorageKey));
    final hydratedRecentEmails = recentEmails.isNotEmpty ? recentEmails : (lastEmail.isNotEmpty ? <String>[lastEmail] : const <String>[]);

    return AppPreferencesController(
      initialThemeMode: _themeModeFromStorage(themeMode),
      initialLastEmail: hydratedRecentEmails.isNotEmpty ? hydratedRecentEmails.first : lastEmail,
      initialRecentEmails: hydratedRecentEmails,
      initialLastIndexPageKey: lastIndexPageKey,
      initialWorkspaceTabsState: workspaceTabsState,
      initialStickyAppBar: stickyAppBar,
      initialStoragePreference: storagePreference,
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

  Future<void> saveRecentEmail(String value) async {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return;
    }

    final nextRecentEmails = [trimmedValue, ..._recentEmails.where((item) => item.toLowerCase() != trimmedValue.toLowerCase())].take(_maxRecentEmails).toList();
    final hasChanged = trimmedValue != _lastEmail || nextRecentEmails.join('|') != _recentEmails.join('|');
    if (!hasChanged) {
      return;
    }

    _lastEmail = trimmedValue;
    _recentEmails = nextRecentEmails;
    notifyListeners();
    await _preferences?.setString(_lastEmailStorageKey, trimmedValue);
    await _preferences?.setStringList(_recentEmailsStorageKey, nextRecentEmails);
  }

  Future<void> saveLastEmail(String value) async {
    await saveRecentEmail(value);
  }

  Future<void> saveLastIndexPageKey(String value) async {
    final trimmedValue = value.trim();
    if (_lastIndexPageKey == trimmedValue) {
      return;
    }

    _lastIndexPageKey = trimmedValue;
    await _preferences?.setString(_lastIndexPageStorageKey, trimmedValue);
  }

  Future<void> saveWorkspaceTabsState(String value) async {
    final trimmedValue = value.trim();
    if (_workspaceTabsState == trimmedValue) {
      return;
    }

    _workspaceTabsState = trimmedValue;
    await _preferences?.setString(_workspaceTabsStateStorageKey, trimmedValue);
  }

  Future<void> setStickyAppBar(bool value) async {
    if (_stickyAppBar == value) {
      return;
    }

    _stickyAppBar = value;
    notifyListeners();
    await _preferences?.setBool(_stickyAppBarStorageKey, value);
  }

  Future<void> setStoragePreference(StoragePreference value) async {
    if (_storagePreference == value) {
      return;
    }

    _storagePreference = value;
    notifyListeners();
    await _preferences?.setString(_storagePreferenceStorageKey, _storagePreferenceToStorage(value));
  }

  static ThemeMode _themeModeFromStorage(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  static String _themeModeToStorage(ThemeMode value) {
    switch (value) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }

  static StoragePreference _storagePreferenceFromStorage(String? value) {
    switch (value) {
      case 'onlineOnly':
        return StoragePreference.onlineOnly;
      case 'localOnly':
        return StoragePreference.localOnly;
      case 'hybrid':
      default:
        return StoragePreference.hybrid;
    }
  }

  static String _storagePreferenceToStorage(StoragePreference value) {
    switch (value) {
      case StoragePreference.onlineOnly:
        return 'onlineOnly';
      case StoragePreference.localOnly:
        return 'localOnly';
      case StoragePreference.hybrid:
        return 'hybrid';
    }
  }
}
