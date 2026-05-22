import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_management/lang/localizations_registry.dart';

ThemeData buildAppTheme({required Brightness brightness, required Locale locale}) {
  final isDark = brightness == Brightness.dark;
  final baseTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: isDark ? const Color(0xFF39A6BC) : const Color(0xFF1F7A8C), brightness: brightness),
    scaffoldBackgroundColor: isDark ? const Color(0xFF09141A) : const Color(0xFFF4F7FB),
    useMaterial3: true,
  );
  final fontFamilies = _fontFamiliesFor(locale);

  return baseTheme.copyWith(textTheme: _buildTextTheme(baseTheme.textTheme, fontFamilies), primaryTextTheme: _buildTextTheme(baseTheme.primaryTextTheme, fontFamilies));
}

Map<String, String> _fontFamiliesFor(Locale locale) {
  final localized = appLocalizationRegistry[locale.languageCode];
  return localized ?? appLocalizationRegistry[appLocalizationFallbackLocaleCode] ?? const <String, String>{};
}

TextTheme _buildTextTheme(TextTheme base, Map<String, String> fontFamilies) {
  final displayFontFamily = fontFamilies['displayFontFamily'] ?? '';
  final bodyFontFamily = fontFamilies['bodyFontFamily'] ?? '';

  return base.copyWith(
    displayLarge: _font(base.displayLarge, displayFontFamily),
    displayMedium: _font(base.displayMedium, displayFontFamily),
    displaySmall: _font(base.displaySmall, displayFontFamily),
    headlineLarge: _font(base.headlineLarge, displayFontFamily),
    headlineMedium: _font(base.headlineMedium, displayFontFamily),
    headlineSmall: _font(base.headlineSmall, displayFontFamily),
    titleLarge: _font(base.titleLarge, displayFontFamily),
    titleMedium: _font(base.titleMedium, displayFontFamily),
    titleSmall: _font(base.titleSmall, displayFontFamily),
    bodyLarge: _font(base.bodyLarge, bodyFontFamily),
    bodyMedium: _font(base.bodyMedium, bodyFontFamily),
    bodySmall: _font(base.bodySmall, bodyFontFamily),
    labelLarge: _font(base.labelLarge, bodyFontFamily),
    labelMedium: _font(base.labelMedium, bodyFontFamily),
    labelSmall: _font(base.labelSmall, bodyFontFamily),
  );
}

TextStyle? _font(TextStyle? style, String family) {
  if (style == null || family.trim().isEmpty) {
    return style;
  }

  try {
    return GoogleFonts.getFont(family, textStyle: style);
  } catch (_) {
    return style.copyWith(fontFamily: family);
  }
}
