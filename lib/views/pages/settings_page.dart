import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/components/language_switcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.localeController, required this.appPreferencesController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settings, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(l10n.language, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                LanguageSwitcher(localeController: localeController),
                const SizedBox(height: 20),
                Text(l10n.theme, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                _ThemeModeOptionTile(
                  icon: Icons.brightness_auto_rounded,
                  label: l10n.systemMode,
                  value: ThemeMode.system,
                  currentValue: appPreferencesController.themeMode,
                  onSelected: appPreferencesController.setThemeMode,
                ),
                _ThemeModeOptionTile(
                  icon: Icons.light_mode_rounded,
                  label: l10n.lightMode,
                  value: ThemeMode.light,
                  currentValue: appPreferencesController.themeMode,
                  onSelected: appPreferencesController.setThemeMode,
                ),
                _ThemeModeOptionTile(
                  icon: Icons.dark_mode_rounded,
                  label: l10n.darkMode,
                  value: ThemeMode.dark,
                  currentValue: appPreferencesController.themeMode,
                  onSelected: appPreferencesController.setThemeMode,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeModeOptionTile extends StatelessWidget {
  const _ThemeModeOptionTile({required this.icon, required this.label, required this.value, required this.currentValue, required this.onSelected});

  final IconData icon;
  final String label;
  final ThemeMode value;
  final ThemeMode currentValue;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == currentValue;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, size: 20),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary) : null,
      selected: isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: () => onSelected(value),
    );
  }
}