import 'package:flutter/material.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/index/dashboard_home_page.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/pages/main_module_pages.dart';
import 'package:store_management/views/pages/reports_page.dart';
import 'package:store_management/views/pages/settings_page.dart';

Map<IndexPage, IndexPageDefinition> buildIndexPageDefinitions(BuildContext context, AuthState authState, {required LocaleController localeController, required AppPreferencesController appPreferencesController}) {
  final l10n = context.l10n;
  final definitions = <IndexPage, IndexPageDefinition>{};

  for (final page in allIndexPages) {
    final metadata = indexPageMetadata(page);
    final title = localizedIndexPageTitle(l10n, page);

    definitions[page] = switch (page) {
      IndexPage.dashboard => IndexPageDefinition(
        title: title,
        bodyBuilder: (_) => DashboardHomePage(authState: authState),
      ),
      IndexPage.reports => IndexPageDefinition(title: title, bodyBuilder: (_) => const ReportsPage()),
      IndexPage.settings => IndexPageDefinition(
        title: title,
        bodyBuilder: (_) => SettingsPage(localeController: localeController, appPreferencesController: appPreferencesController),
      ),
      _ => IndexPageDefinition(
        title: title,
        bodyBuilder: (_) => buildMainModulePage(page: page, title: title, description: localizedIndexPageDescription(l10n, page), icon: metadata.icon, highlights: localizedIndexPageHighlights(l10n, page)),
      ),
    };
  }

  return definitions;
}
