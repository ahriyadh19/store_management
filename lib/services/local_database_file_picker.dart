import 'package:file_selector/file_selector.dart';

import 'package:store_management/localization/app_localizations.dart';

XTypeGroup sqliteDatabaseTypeGroup(AppLocalizations l10n) => XTypeGroup(label: l10n.pick('SQLite database', 'قاعدة بيانات SQLite'),
  extensions: <String>['sqlite', 'db'],
);

XTypeGroup jsonExportTypeGroup(AppLocalizations l10n) => XTypeGroup(label: l10n.pick('JSON', 'ملف JSON'),
  extensions: <String>['json'],
);