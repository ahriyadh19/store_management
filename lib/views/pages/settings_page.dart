import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/views/components/language_switcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.localeController, required this.appPreferencesController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appPreferencesController,
      builder: (context, child) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final conflictedRecords = LocalDatabase.current?.getConflictedRecords() ?? const <OfflineSyncRecord>[];
        final latestConflict = conflictedRecords
            .where((record) => record.conflictDetectedAtMillis != null)
            .map((record) => record.conflictDetectedAtMillis!)
            .fold<int?>(null, (latest, value) => latest == null || value > latest ? value : latest);

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
                    _ThemeModeOptionTile(icon: Icons.dark_mode_rounded, label: l10n.darkMode, value: ThemeMode.dark, currentValue: appPreferencesController.themeMode, onSelected: appPreferencesController.setThemeMode),
                    const SizedBox(height: 20),
                    Text(l10n.appBarBehavior, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    _AppBarBehaviorOptionTile(icon: Icons.push_pin_rounded, label: l10n.stickyAppBar, selected: appPreferencesController.stickyAppBar, onTap: () => appPreferencesController.setStickyAppBar(true)),
                    _AppBarBehaviorOptionTile(
                      icon: Icons.vertical_align_bottom_rounded,
                      label: l10n.hideAppBarOnScroll,
                      selected: !appPreferencesController.stickyAppBar,
                      onTap: () => appPreferencesController.setStickyAppBar(false),
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.storagePreference, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),
                    _StoragePreferenceOptionTile(
                      icon: Icons.sync_rounded,
                      label: l10n.storageHybrid,
                      description: l10n.storageHybridDescription,
                      recommendedLabel: l10n.recommended,
                      selected: appPreferencesController.storagePreference == StoragePreference.hybrid,
                      onTap: () => appPreferencesController.setStoragePreference(StoragePreference.hybrid),
                    ),
                    _StoragePreferenceOptionTile(
                      icon: Icons.cloud_done_rounded,
                      label: l10n.storageOnlineOnly,
                      description: l10n.storageOnlineOnlyDescription,
                      selected: appPreferencesController.storagePreference == StoragePreference.onlineOnly,
                      onTap: () => appPreferencesController.setStoragePreference(StoragePreference.onlineOnly),
                    ),
                    _StoragePreferenceOptionTile(
                      icon: Icons.phone_android_rounded,
                      label: l10n.storageLocalOnly,
                      description: l10n.storageLocalOnlyDescription,
                      selected: appPreferencesController.storagePreference == StoragePreference.localOnly,
                      onTap: () => appPreferencesController.setStoragePreference(StoragePreference.localOnly),
                    ),
                    if (conflictedRecords.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Sync conflict diagnostics', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      _SyncConflictDiagnosticsTile(conflictedRecordsCount: conflictedRecords.length, latestConflictMillis: latestConflict),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SyncConflictDiagnosticsTile extends StatelessWidget {
  const _SyncConflictDiagnosticsTile({required this.conflictedRecordsCount, required this.latestConflictMillis});

  final int conflictedRecordsCount;
  final int? latestConflictMillis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final latestConflictText = latestConflictMillis == null ? 'Unknown' : DateTime.fromMillisecondsSinceEpoch(latestConflictMillis!, isUtc: false).toLocal().toIso8601String();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: colorScheme.error),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Remote changes overrode pending local edits.', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Conflicted records: $conflictedRecordsCount', style: theme.textTheme.bodySmall),
                Text('Latest conflict at: $latestConflictText', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
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

class _AppBarBehaviorOptionTile extends StatelessWidget {
  const _AppBarBehaviorOptionTile({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, size: 20),
      title: Text(label),
      trailing: selected ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary) : null,
      selected: selected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: onTap,
    );
  }
}

class _StoragePreferenceOptionTile extends StatelessWidget {
  const _StoragePreferenceOptionTile({required this.icon, required this.label, required this.description, required this.selected, required this.onTap, this.recommendedLabel});

  final IconData icon;
  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final String? recommendedLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      leading: Icon(icon, size: 20),
      title: Row(
        children: [
          Expanded(child: Text(label)),
          if (recommendedLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(999)),
              child: Text(
                recommendedLabel!,
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary),
              ),
            ),
        ],
      ),
      subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(description)),
      trailing: selected ? Icon(Icons.check_rounded, color: colorScheme.primary) : null,
      selected: selected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: onTap,
    );
  }
}
