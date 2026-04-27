import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({Locale? initialLocale}) : _locale = initialLocale;

  static const _storageKey = 'app.localeCode';

  Locale? _locale;

  Locale? get locale => _locale;

  static Future<LocaleController> create() async {
    final controller = LocaleController();
    await controller.load();
    return controller;
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(_storageKey);
    if (code == null || code.isEmpty) {
      return;
    }

    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) {
      return;
    }

    _locale = Locale(locale.languageCode);
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, locale.languageCode);
  }
}