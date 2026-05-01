import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_management/localization/app_localizations.dart';

ThemeData buildAppTheme({required Brightness brightness, required Locale locale}) {
  final isDark = brightness == Brightness.dark;
  final baseTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: isDark ? const Color(0xFF39A6BC) : const Color(0xFF1F7A8C), brightness: brightness),
    scaffoldBackgroundColor: isDark ? const Color(0xFF09141A) : const Color(0xFFF4F7FB),
    useMaterial3: true,
  );
  final l10n = AppLocalizations(locale);

  return baseTheme.copyWith(textTheme: _buildTextTheme(baseTheme.textTheme, l10n), primaryTextTheme: _buildTextTheme(baseTheme.primaryTextTheme, l10n));
}

TextTheme _buildTextTheme(TextTheme base, AppLocalizations l10n) {
  return base.copyWith(
    displayLarge: _font(base.displayLarge, l10n.displayFontFamily),
    displayMedium: _font(base.displayMedium, l10n.displayFontFamily),
    displaySmall: _font(base.displaySmall, l10n.displayFontFamily),
    headlineLarge: _font(base.headlineLarge, l10n.displayFontFamily),
    headlineMedium: _font(base.headlineMedium, l10n.displayFontFamily),
    headlineSmall: _font(base.headlineSmall, l10n.displayFontFamily),
    titleLarge: _font(base.titleLarge, l10n.displayFontFamily),
    titleMedium: _font(base.titleMedium, l10n.displayFontFamily),
    titleSmall: _font(base.titleSmall, l10n.displayFontFamily),
    bodyLarge: _font(base.bodyLarge, l10n.bodyFontFamily),
    bodyMedium: _font(base.bodyMedium, l10n.bodyFontFamily),
    bodySmall: _font(base.bodySmall, l10n.bodyFontFamily),
    labelLarge: _font(base.labelLarge, l10n.bodyFontFamily),
    labelMedium: _font(base.labelMedium, l10n.bodyFontFamily),
    labelSmall: _font(base.labelSmall, l10n.bodyFontFamily),
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
