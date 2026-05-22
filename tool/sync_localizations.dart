import 'dart:convert';
import 'dart:io';

import 'package:store_management/lang/localizations_registry.dart';

final _placeholderPattern = RegExp(r'\{(\w+)\}');

void main() {
  final fallbackMap =
      appLocalizationRegistry[appLocalizationFallbackLocaleCode];
  if (fallbackMap == null) {
    stderr.writeln(
      'Missing fallback locale: $appLocalizationFallbackLocaleCode',
    );
    exitCode = 1;
    return;
  }

  final fallbackKeys = fallbackMap.keys.toSet();
  for (final entry in appLocalizationRegistry.entries) {
    final localeCode = entry.key;
    final keys = entry.value.keys.toSet();
    final missingKeys = fallbackKeys.difference(keys).toList()..sort();
    final extraKeys = keys.difference(fallbackKeys).toList()..sort();

    if (missingKeys.isNotEmpty || extraKeys.isNotEmpty) {
      stderr.writeln(
        'Locale "$localeCode" is out of sync with "$appLocalizationFallbackLocaleCode".',
      );
      if (missingKeys.isNotEmpty) {
        stderr.writeln('Missing keys: ${missingKeys.join(', ')}');
      }
      if (extraKeys.isNotEmpty) {
        stderr.writeln('Extra keys: ${extraKeys.join(', ')}');
      }
      exitCode = 1;
      return;
    }
  }

  final l10nDirectory = Directory('lib/l10n');
  if (!l10nDirectory.existsSync()) {
    l10nDirectory.createSync(recursive: true);
  }

  for (final entry in appLocalizationRegistry.entries) {
    final localeCode = entry.key;
    final arb = <String, Object>{'@@locale': localeCode};
    final sortedKeys = entry.value.keys.toList()..sort();

    for (final sourceKey in sortedKeys) {
      final arbKey = appLocalizationArbAliases[sourceKey] ?? sourceKey;
      final value = entry.value[sourceKey]!;
      arb[arbKey] = value;

      final placeholders = {
        for (final match in _placeholderPattern.allMatches(value))
          match.group(1)!: <String, Object>{},
      };
      if (placeholders.isNotEmpty) {
        arb['@$arbKey'] = {'placeholders': placeholders};
      }
    }

    final outputFile = File('lib/l10n/app_$localeCode.arb');
    const encoder = JsonEncoder.withIndent('  ');
    outputFile.writeAsStringSync('${encoder.convert(arb)}\n');
    stdout.writeln('Wrote ${outputFile.path}');
  }
}
