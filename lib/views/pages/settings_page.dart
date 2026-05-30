import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/local_database_file_picker.dart';
import 'package:store_management/services/local_database_management_controller.dart';
import 'package:store_management/views/components/app_notification.dart';
import 'package:store_management/views/components/language_switcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.localeController, required this.appPreferencesController, this.localDatabaseManagementController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;
  final LocalDatabaseManagementController? localDatabaseManagementController;

  @override
  Widget build(BuildContext context) {
    final settingsAnimation = localDatabaseManagementController == null
        ? appPreferencesController
        : Listenable.merge(<Listenable>[appPreferencesController, localDatabaseManagementController!]);

    return AnimatedBuilder(
      animation: settingsAnimation,
      builder: (context, child) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final conflictedRecords = LocalDatabase.current?.getConflictedRecords() ?? const <OfflineSyncRecord>[];
        final latestConflict = conflictedRecords
            .where((record) => record.conflictDetectedAtMillis != null)
            .map((record) => record.conflictDetectedAtMillis!)
            .fold<int?>(null, (latest, value) => latest == null || value > latest ? value : latest);

        return LayoutBuilder(
          builder: (context, constraints) {
            final maxContentWidth = constraints.maxWidth > 1120 ? 1120.0 : constraints.maxWidth;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  children: [
                    _AnimatedSection(
                      delay: 0,
                      child: _SettingsOverviewHero(
                        title: l10n.settings,
                        subtitle: l10n.pick('Tune language, appearance, navigation, and data behavior from one organized workspace.', 'اضبط اللغة والمظهر والتنقل وسلوك البيانات من مساحة إعدادات منظمة واحدة.'),
                        metrics: [
                          _SettingsMetric(label: l10n.language, value: (localeController.locale?.languageCode ?? Localizations.localeOf(context).languageCode).toUpperCase()),
                          _SettingsMetric(
                            label: l10n.theme,
                            value: switch (appPreferencesController.themeMode) {
                              ThemeMode.system => l10n.systemMode,
                              ThemeMode.light => l10n.lightMode,
                              ThemeMode.dark => l10n.darkMode,
                            },
                          ),
                          _SettingsMetric(
                            label: l10n.storagePreference,
                            value: switch (appPreferencesController.storagePreference) {
                              StoragePreference.hybrid => l10n.storageHybrid,
                              StoragePreference.onlineOnly => l10n.storageOnlineOnly,
                              StoragePreference.localOnly => l10n.storageLocalOnly,
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _AnimatedSection(
                      delay: 90,
                      child: _SettingsGrid(
                        minChildWidth: 320,
                        spacing: 16,
                        children: [
                          _SettingsSectionCard(
                            icon: Icons.palette_outlined,
                            title: l10n.pick('Language and appearance', 'اللغة والمظهر'),
                            description: l10n.pick('Keep the workspace readable and aligned with the device or preferred visual mode.', 'حافظ على سهولة القراءة ومواءمة الواجهة مع الجهاز أو النمط البصري المفضل.'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.language, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 8),
                                LanguageSwitcher(localeController: localeController),
                                const SizedBox(height: 16),
                                Text(l10n.theme, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 8),
                                _ThemeModeOptionTile(
                                  icon: Icons.brightness_auto_rounded,
                                  label: l10n.systemMode,
                                  value: ThemeMode.system,
                                  currentValue: appPreferencesController.themeMode,
                                  onSelected: appPreferencesController.setThemeMode,
                                ),
                                const SizedBox(height: 8),
                                _ThemeModeOptionTile(
                                  icon: Icons.light_mode_rounded,
                                  label: l10n.lightMode,
                                  value: ThemeMode.light,
                                  currentValue: appPreferencesController.themeMode,
                                  onSelected: appPreferencesController.setThemeMode,
                                ),
                                const SizedBox(height: 8),
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
                          _SettingsSectionCard(
                            icon: Icons.tune_rounded,
                            title: l10n.pick('Workspace behavior', 'سلوك مساحة العمل'),
                            description: l10n.pick('Choose how navigation and storage behave during daily work.', 'اختر كيفية عمل التنقل والتخزين أثناء الاستخدام اليومي.'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.appBarBehavior, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 8),
                                _AppBarBehaviorOptionTile(
                                  icon: Icons.push_pin_rounded,
                                  label: l10n.stickyAppBar,
                                  selected: appPreferencesController.stickyAppBar,
                                  onTap: () => appPreferencesController.setStickyAppBar(true),
                                ),
                                const SizedBox(height: 8),
                                _AppBarBehaviorOptionTile(
                                  icon: Icons.vertical_align_bottom_rounded,
                                  label: l10n.hideAppBarOnScroll,
                                  selected: !appPreferencesController.stickyAppBar,
                                  onTap: () => appPreferencesController.setStickyAppBar(false),
                                ),
                                const SizedBox(height: 16),
                                Text(l10n.storagePreference, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 8),
                                _StoragePreferenceOptionTile(
                                  icon: Icons.sync_rounded,
                                  label: l10n.storageHybrid,
                                  description: l10n.storageHybridDescription,
                                  recommendedLabel: l10n.recommended,
                                  selected: appPreferencesController.storagePreference == StoragePreference.hybrid,
                                  onTap: () => (localDatabaseManagementController?.setStoragePreference(StoragePreference.hybrid) ?? appPreferencesController.setStoragePreference(StoragePreference.hybrid)),
                                ),
                                const SizedBox(height: 8),
                                _StoragePreferenceOptionTile(
                                  icon: Icons.cloud_done_rounded,
                                  label: l10n.storageOnlineOnly,
                                  description: l10n.storageOnlineOnlyDescription,
                                  selected: appPreferencesController.storagePreference == StoragePreference.onlineOnly,
                                  onTap: () => (localDatabaseManagementController?.setStoragePreference(StoragePreference.onlineOnly) ?? appPreferencesController.setStoragePreference(StoragePreference.onlineOnly)),
                                ),
                                const SizedBox(height: 8),
                                _StoragePreferenceOptionTile(
                                  icon: Icons.phone_android_rounded,
                                  label: l10n.storageLocalOnly,
                                  description: l10n.storageLocalOnlyDescription,
                                  selected: appPreferencesController.storagePreference == StoragePreference.localOnly,
                                  onTap: () => (localDatabaseManagementController?.setStoragePreference(StoragePreference.localOnly) ?? appPreferencesController.setStoragePreference(StoragePreference.localOnly)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (localDatabaseManagementController != null) ...[
                      const SizedBox(height: 16),
                      _AnimatedSection(
                        delay: 180,
                        child: _LocalDatabaseManagementSection(controller: localDatabaseManagementController!, appPreferencesController: appPreferencesController),
                      ),
                    ],
                    if (conflictedRecords.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _AnimatedSection(
                        delay: 240,
                        child: _SettingsSectionCard(
                          icon: Icons.warning_amber_rounded,
                          title: l10n.syncConflictDiagnostics,
                          description: l10n.pick('Review the latest synchronization overrides so local edits do not go unnoticed.', 'راجع آخر حالات تجاوز المزامنة حتى لا تمر التعديلات المحلية دون ملاحظة.'),
                          child: _SyncConflictDiagnosticsTile(conflictedRecordsCount: conflictedRecords.length, latestConflictMillis: latestConflict),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({required this.child, required this.delay});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + delay),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, (1 - value) * 18), child: child,
          ),
        );
      },
    );
  }
}

class _SettingsOverviewHero extends StatelessWidget {
  const _SettingsOverviewHero({required this.title, required this.subtitle, required this.metrics});

  final String title;
  final String subtitle;
  final List<_SettingsMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: [colorScheme.primaryContainer.withValues(alpha: 0.95), colorScheme.surfaceContainerHighest], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: colorScheme.surface.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.settings_rounded, color: colorScheme.primary),
          ),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.35)),
          ),
          const SizedBox(height: 14),
          _SettingsGrid(minChildWidth: 140, spacing: 10, children: metrics.map((metric) => _SettingsMetricChip(metric: metric)).toList(growable: false)),
        ],
      ),
    );
  }
}

class _SettingsGrid extends StatelessWidget {
  const _SettingsGrid({required this.children, this.minChildWidth = 240, this.spacing = 12});

  final List<Widget> children;
  final double minChildWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width <= minChildWidth ? 1 : ((width + spacing) / (minChildWidth + spacing)).floor().clamp(1, children.length);

        final rows = <Widget>[];
        for (var index = 0; index < children.length; index += columns) {
          final rowChildren = children.skip(index).take(columns).toList();
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var itemIndex = 0; itemIndex < rowChildren.length; itemIndex++) ...[Expanded(child: rowChildren[itemIndex]), if (itemIndex < rowChildren.length - 1) SizedBox(width: spacing)],
                  for (var filler = rowChildren.length; filler < columns; filler++) ...[const Expanded(child: SizedBox.shrink()), if (filler < columns - 1) SizedBox(width: spacing)],
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[rows[rowIndex], if (rowIndex < rows.length - 1) SizedBox(height: spacing)],
          ],
        );
      },
    );
  }
}

class _SettingsMetric {
  const _SettingsMetric({required this.label, required this.value});

  final String label;
  final String value;
}

class _SettingsMetricChip extends StatelessWidget {
  const _SettingsMetricChip({required this.metric});

  final _SettingsMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.label, style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(metric.value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _SettingsSectionCard extends StatelessWidget {
  const _SettingsSectionCard({required this.icon, required this.title, required this.description, required this.child});

  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: colorScheme.secondaryContainer.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: colorScheme.secondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(description, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _LocalDatabaseManagementSection extends StatefulWidget {
  const _LocalDatabaseManagementSection({required this.controller, required this.appPreferencesController});

  final LocalDatabaseManagementController controller;
  final AppPreferencesController appPreferencesController;

  @override
  State<_LocalDatabaseManagementSection> createState() => _LocalDatabaseManagementSectionState();
}

class _LocalDatabaseManagementSectionState extends State<_LocalDatabaseManagementSection> {
  late final TextEditingController _databaseDirectoryController;
  late final TextEditingController _databaseFileController;
  late final TextEditingController _backupDirectoryController;
  late final TextEditingController _importPathController;
  late final TextEditingController _exportDatabasePathController;
  late final TextEditingController _exportJsonPathController;
  late final FocusNode _databaseDirectoryFocusNode;
  late final FocusNode _databaseFileFocusNode;
  late final FocusNode _backupDirectoryFocusNode;
  late final FocusNode _importPathFocusNode;
  late final FocusNode _exportDatabasePathFocusNode;
  late final FocusNode _exportJsonPathFocusNode;

  @override
  void initState() {
    super.initState();
    _databaseDirectoryController = TextEditingController();
    _databaseFileController = TextEditingController();
    _backupDirectoryController = TextEditingController();
    _importPathController = TextEditingController();
    _exportDatabasePathController = TextEditingController();
    _exportJsonPathController = TextEditingController();
    _databaseDirectoryFocusNode = FocusNode();
    _databaseFileFocusNode = FocusNode();
    _backupDirectoryFocusNode = FocusNode();
    _importPathFocusNode = FocusNode();
    _exportDatabasePathFocusNode = FocusNode();
    _exportJsonPathFocusNode = FocusNode();
    _syncTextControllers();
  }

  @override
  void didUpdateWidget(covariant _LocalDatabaseManagementSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTextControllers();
  }

  @override
  void dispose() {
    _databaseDirectoryController.dispose();
    _databaseFileController.dispose();
    _backupDirectoryController.dispose();
    _importPathController.dispose();
    _exportDatabasePathController.dispose();
    _exportJsonPathController.dispose();
    _databaseDirectoryFocusNode.dispose();
    _databaseFileFocusNode.dispose();
    _backupDirectoryFocusNode.dispose();
    _importPathFocusNode.dispose();
    _exportDatabasePathFocusNode.dispose();
    _exportJsonPathFocusNode.dispose();
    super.dispose();
  }

  void _syncTextControllers() {
    _assignText(_databaseDirectoryController, _databaseDirectoryFocusNode, widget.controller.databaseDirectoryPath);
    _assignText(_databaseFileController, _databaseFileFocusNode, widget.controller.databaseFileName);
    _assignText(_backupDirectoryController, _backupDirectoryFocusNode, widget.controller.backupDirectoryPath);
    if (_importPathController.text.trim().isEmpty) {
      _importPathController.text = widget.controller.configuredDatabasePath;
    }

    final exportDatabaseSuggestion = p.join(widget.controller.backupDirectoryPath, '${p.basenameWithoutExtension(widget.controller.databaseFileName)}_export.sqlite');
    final exportJsonSuggestion = p.join(widget.controller.backupDirectoryPath, '${p.basenameWithoutExtension(widget.controller.databaseFileName)}_snapshot.json');
    _assignText(_exportDatabasePathController, _exportDatabasePathFocusNode, exportDatabaseSuggestion, onlyWhenEmpty: true);
    _assignText(_exportJsonPathController, _exportJsonPathFocusNode, exportJsonSuggestion, onlyWhenEmpty: true);
  }

  void _assignText(TextEditingController controller, FocusNode focusNode, String value, {bool onlyWhenEmpty = false}) {
    if (focusNode.hasFocus) {
      return;
    }
    if (onlyWhenEmpty && controller.text.trim().isNotEmpty) {
      return;
    }
    if (controller.text == value) {
      return;
    }
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _saveConfiguredPaths() async {
    await widget.controller.setDatabaseDirectoryPath(_databaseDirectoryController.text);
    await widget.controller.setDatabaseFileName(_databaseFileController.text);
    await widget.controller.setBackupDirectoryPath(_backupDirectoryController.text);
  }

  void _applySelectedText(TextEditingController controller, String value) {
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _pickDatabaseDirectory() async {
    final l10n = context.l10n;
    final selectedPath = await getDirectoryPath(
      initialDirectory: _databaseDirectoryController.text.trim().isEmpty ? null : _databaseDirectoryController.text.trim(),
      confirmButtonText: l10n.pick('Select folder', 'اختر مجلد'),
    );
    if (!mounted || selectedPath == null || selectedPath.trim().isEmpty) {
      return;
    }
    _applySelectedText(_databaseDirectoryController, selectedPath);
  }

  Future<void> _pickDatabaseFile() async {
    final l10n = context.l10n;
    final selectedFile = await openFile(
      acceptedTypeGroups: <XTypeGroup>[sqliteDatabaseTypeGroup(l10n)],
      confirmButtonText: l10n.pick('Select database', 'اختر قاعدة البيانات'),
      initialDirectory: _databaseDirectoryController.text.trim().isEmpty ? null : _databaseDirectoryController.text.trim(),
    );
    if (!mounted || selectedFile == null) {
      return;
    }
    _applySelectedText(_databaseDirectoryController, p.dirname(selectedFile.path));
    _applySelectedText(_databaseFileController, p.basename(selectedFile.path));
  }

  Future<void> _pickBackupDirectory() async {
    final l10n = context.l10n;
    final selectedPath = await getDirectoryPath(
      initialDirectory: _backupDirectoryController.text.trim().isEmpty ? null : _backupDirectoryController.text.trim(),
      confirmButtonText: l10n.pick('Select folder', 'اختر مجلد'),
    );
    if (!mounted || selectedPath == null || selectedPath.trim().isEmpty) {
      return;
    }
    _applySelectedText(_backupDirectoryController, selectedPath);
  }

  Future<void> _pickImportSourceFile() async {
    final l10n = context.l10n;
    final selectedFile = await openFile(
      acceptedTypeGroups: <XTypeGroup>[sqliteDatabaseTypeGroup(l10n)],
      confirmButtonText: l10n.pick('Select database', 'اختر قاعدة البيانات'),
      initialDirectory: _importPathController.text.trim().isEmpty ? null : p.dirname(_importPathController.text.trim()),
    );
    if (!mounted || selectedFile == null) {
      return;
    }
    _applySelectedText(_importPathController, selectedFile.path);
  }

  Future<void> _pickExportDatabasePath() async {
    final l10n = context.l10n;
    final location = await getSaveLocation(
      acceptedTypeGroups: <XTypeGroup>[sqliteDatabaseTypeGroup(l10n)],
      suggestedName: p.basename(_exportDatabasePathController.text.trim().isEmpty ? '${p.basenameWithoutExtension(widget.controller.databaseFileName)}_export.sqlite' : _exportDatabasePathController.text.trim()),
      initialDirectory: _exportDatabasePathController.text.trim().isEmpty ? widget.controller.backupDirectoryPath : p.dirname(_exportDatabasePathController.text.trim()),
      confirmButtonText: l10n.pick('Save export', 'احفظ ملف التصدير'),
    );
    if (!mounted || location == null || location.path.trim().isEmpty) {
      return;
    }
    _applySelectedText(_exportDatabasePathController, location.path);
  }

  Future<void> _pickExportJsonPath() async {
    final l10n = context.l10n;
    final location = await getSaveLocation(
      acceptedTypeGroups: <XTypeGroup>[jsonExportTypeGroup(l10n)],
      suggestedName: p.basename(_exportJsonPathController.text.trim().isEmpty ? '${p.basenameWithoutExtension(widget.controller.databaseFileName)}_snapshot.json' : _exportJsonPathController.text.trim()),
      initialDirectory: _exportJsonPathController.text.trim().isEmpty ? widget.controller.backupDirectoryPath : p.dirname(_exportJsonPathController.text.trim()),
      confirmButtonText: l10n.pick('Save export', 'احفظ ملف التصدير'),
    );
    if (!mounted || location == null || location.path.trim().isEmpty) {
      return;
    }
    _applySelectedText(_exportJsonPathController, location.path);
  }

  Future<void> _runAction(Future<void> Function() action, {String? successMessage}) async {
    try {
      await action();
      if (!mounted) {
        return;
      }
      final resolvedMessage = widget.controller.statusMessage ?? successMessage;
      if (resolvedMessage != null && resolvedMessage.isNotEmpty) {
        AppNotification.show(context, message: _localizeSettingsStatusMessage(context, resolvedMessage), type: AppNotificationType.success);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotification.show(context, message: context.l10n.localizedNotificationError(error), type: AppNotificationType.error);
    }
  }

  String _localizeSettingsStatusMessage(BuildContext context, String message) {
    final l10n = context.l10n;
    return switch (message) {
      'Local database enabled.' => l10n.pick('Local database enabled.', 'تم تفعيل قاعدة البيانات المحلية.'),
      'Local database disabled; remote-only mode is active.' => l10n.pick('Local database disabled; remote-only mode is active.', 'تم تعطيل قاعدة البيانات المحلية، ووضع الاتصال البعيد فقط نشط.'),
      'Synchronization behavior updated.' => l10n.pick('Synchronization behavior updated.', 'تم تحديث سلوك المزامنة.'),
      'Automatic backup policy updated.' => l10n.pick('Automatic backup policy updated.', 'تم تحديث سياسة النسخ الاحتياطي التلقائي.'),
      'Local database is ready.' => l10n.pick('Local database is ready.', 'قاعدة البيانات المحلية جاهزة.'),
      'Database location already matches the current configuration.' => l10n.pick('Database location already matches the current configuration.', 'موقع قاعدة البيانات يطابق الإعداد الحالي بالفعل.'),
      'Database moved to the configured location.' => l10n.pick('Database moved to the configured location.', 'تم نقل قاعدة البيانات إلى الموقع المحدد.'),
      'Database file exported.' => l10n.pick('Database file exported.', 'تم تصدير ملف قاعدة البيانات.'),
      'Portable JSON export created.' => l10n.pick('Portable JSON export created.', 'تم إنشاء تصدير JSON قابل للنقل.'),
      'Database imported and reopened.' => l10n.pick('Database imported and reopened.', 'تم استيراد قاعدة البيانات وإعادة فتحها.'),
      'Backup created.' => l10n.pick('Backup created.', 'تم إنشاء نسخة احتياطية.'),
      'Backup restored.' => l10n.pick('Backup restored.', 'تمت استعادة النسخة الاحتياطية.'),
      'Backup history updated.' => l10n.pick('Backup history updated.', 'تم تحديث سجل النسخ الاحتياطية.'),
      'Local storage reset completed.' => l10n.pick('Local storage reset completed.', 'اكتملت إعادة تعيين التخزين المحلي.'),
      'Database deleted and recreated.' => l10n.pick('Database deleted and recreated.', 'تم حذف قاعدة البيانات وإعادة إنشائها.'),
      _ => message,
    };
  }

  Future<bool> _confirmAction({required String title, required String message}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.cancel)),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(context.l10n.apply)),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = widget.controller;
    final status = controller.statusSnapshot;
    final isBusy = controller.isBusy;

    return _SettingsSectionCard(
      icon: Icons.storage_rounded,
      title: l10n.pick('Local database management', 'إدارة قاعدة البيانات المحلية',
      ),
      description: l10n.pick('Keep storage, synchronization, exports, and recovery tools in one compact panel.', 'أبقِ أدوات التخزين والمزامنة والتصدير والاستعادة في لوحة مدمجة واحدة.'),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsSubsection(
                title: l10n.pick('Connection', 'الاتصال'),
                child: Column(
                  children: [
                    Material(
                      color: colorScheme.surfaceContainerLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          value: controller.isLocalDatabaseEnabled,
                          onChanged: isBusy ? null : (value) => _runAction(() => controller.setLocalDatabaseEnabled(value)),
                          title: Text(l10n.pick('Enable local database usage', 'تفعيل استخدام قاعدة البيانات المحلية')),
                          subtitle: Text(
                            widget.appPreferencesController.storagePreference == StoragePreference.onlineOnly
                                ? l10n.pick('Remote-only mode is active.', 'وضع الاتصال البعيد فقط نشط.')
                                : '${l10n.pick('Current storage mode', 'وضع التخزين الحالي')}: ${widget.appPreferencesController.storagePreference.name}.',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SettingsGrid(
                      minChildWidth: 260,
                      spacing: 12,
                      children: [
                        DropdownButtonFormField<LocalDatabaseSyncBehavior>(
                          initialValue: controller.syncBehavior,
                          decoration: InputDecoration(labelText: l10n.pick('Synchronization behavior', 'سلوك المزامنة'), border: const OutlineInputBorder(), isDense: true),
                          onChanged: (!controller.isLocalDatabaseEnabled || isBusy)
                              ? null
                              : (value) {
                                  if (value != null) {
                                    _runAction(() => controller.setSyncBehavior(value));
                                  }
                                },
                          items: LocalDatabaseSyncBehavior.values
                              .map(
                                (value) => DropdownMenuItem<LocalDatabaseSyncBehavior>(
                                  value: value,
                                  child: Text(switch (value) {
                                    LocalDatabaseSyncBehavior.automatic => l10n.pick('Automatic', 'تلقائي'),
                                    LocalDatabaseSyncBehavior.manual => l10n.pick('Manual', 'يدوي'),
                                    LocalDatabaseSyncBehavior.paused => l10n.pick('Paused', 'متوقف'),
                                  }),
                                ),
                              )
                              .toList(growable: false),
                        ),
                        DropdownButtonFormField<AutomaticBackupInterval>(
                          initialValue: controller.automaticBackupInterval,
                          decoration: InputDecoration(labelText: l10n.pick('Automatic backup interval', 'فاصل النسخ الاحتياطي التلقائي'), border: const OutlineInputBorder(), isDense: true),
                          onChanged: isBusy
                              ? null
                              : (value) {
                                  if (value != null) {
                                    _runAction(() => controller.setAutomaticBackupInterval(value));
                                  }
                                },
                          items: AutomaticBackupInterval.values
                              .map(
                                (value) => DropdownMenuItem<AutomaticBackupInterval>(
                                  value: value,
                                  child: Text(switch (value) {
                                    AutomaticBackupInterval.disabled => l10n.pick('Disabled', 'معطل'),
                                    AutomaticBackupInterval.daily => l10n.pick('Daily', 'يومي'),
                                    AutomaticBackupInterval.weekly => l10n.pick('Weekly', 'أسبوعي'),
                                    AutomaticBackupInterval.monthly => l10n.pick('Monthly', 'شهري'),
                                  }),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SettingsSubsection(
                title: l10n.pick('Paths and files', 'المسارات والملفات'),
                child: _SettingsGrid(
                  minChildWidth: 280,
                  spacing: 12,
                  children: [
                    _PathField(
                      controller: _databaseDirectoryController,
                      focusNode: _databaseDirectoryFocusNode,
                      label: l10n.pick('Database folder', 'مجلد قاعدة البيانات'),
                      hint: '/path/to/database/folder',
                      suffixIcon: IconButton(tooltip: l10n.pick('Choose folder', 'اختر مجلد'), onPressed: isBusy ? null : _pickDatabaseDirectory, icon: const Icon(Icons.folder_open_rounded)),
                    ),
                    _PathField(
                      controller: _databaseFileController,
                      focusNode: _databaseFileFocusNode,
                      label: l10n.pick('Database file name', 'اسم ملف قاعدة البيانات'),
                      hint: 'store_management.sqlite',
                      suffixIcon: IconButton(
                        tooltip: l10n.pick('Choose existing database file', 'اختر ملف قاعدة بيانات موجود'),
                        onPressed: isBusy ? null : _pickDatabaseFile,
                        icon: const Icon(Icons.insert_drive_file_rounded),
                      ),
                    ),
                    _PathField(
                      controller: _backupDirectoryController,
                      focusNode: _backupDirectoryFocusNode,
                      label: l10n.pick('Backup destination folder', 'مجلد وجهة النسخ الاحتياطي'),
                      hint: '/path/to/backup/folder',
                      suffixIcon: IconButton(
                        tooltip: l10n.pick('Choose backup folder', 'اختر مجلد النسخ الاحتياطي'), onPressed: isBusy ? null : _pickBackupDirectory, icon: const Icon(Icons.folder_copy_rounded)),
                    ),
                    _PathField(
                      controller: _importPathController,
                      focusNode: _importPathFocusNode,
                      label: l10n.pick('Import or restore source file', 'ملف الاستيراد أو الاستعادة'),
                      hint: '/path/to/database.sqlite',
                      suffixIcon: IconButton(
                        tooltip: l10n.pick('Choose database file', 'اختر ملف قاعدة البيانات'), onPressed: isBusy ? null : _pickImportSourceFile, icon: const Icon(Icons.attach_file_rounded)),
                    ),
                    _PathField(
                      controller: _exportDatabasePathController,
                      focusNode: _exportDatabasePathFocusNode,
                      label: l10n.pick('Database export file', 'ملف تصدير قاعدة البيانات'),
                      hint: '/path/to/export.sqlite',
                      suffixIcon: IconButton(
                        tooltip: l10n.pick('Choose export location', 'اختر موقع التصدير'), onPressed: isBusy ? null : _pickExportDatabasePath, icon: const Icon(Icons.save_alt_rounded)),
                    ),
                    _PathField(
                      controller: _exportJsonPathController,
                      focusNode: _exportJsonPathFocusNode,
                      label: l10n.pick('Portable JSON export file', 'ملف تصدير JSON قابل للنقل'),
                      hint: '/path/to/export.json',
                      suffixIcon: IconButton(
                        tooltip: l10n.pick('Choose export location', 'اختر موقع التصدير'), onPressed: isBusy ? null : _pickExportJsonPath, icon: const Icon(Icons.save_alt_rounded)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SettingsSubsection(
                title: l10n.pick('Actions', 'الإجراءات'),
                child: _SettingsGrid(
                  minChildWidth: 170,
                  spacing: 8,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy
                          ? null
                          : () => _runAction(() async {
                              await _saveConfiguredPaths();
                              await controller.openOrCreateDatabase();
                            }),
                      icon: const Icon(Icons.storage_rounded, size: 18),
                      label: Text(l10n.pick('Open or create', 'افتح أو أنشئ')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy
                          ? null
                          : () => _runAction(() async {
                              await _saveConfiguredPaths();
                              await controller.changeDatabaseLocation();
                            }),
                      icon: const Icon(Icons.drive_file_move_rounded, size: 18),
                      label: Text(l10n.pick('Move', 'انقل')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy
                          ? null
                          : () => _runAction(() async {
                              await controller.restoreDefaultPaths();
                              _syncTextControllers();
                            }, successMessage: l10n.pick('Default database paths restored.', 'تمت استعادة مسارات قاعدة البيانات الافتراضية.')),
                      icon: const Icon(Icons.restore_rounded, size: 18),
                      label: Text(l10n.pick('Defaults', 'الافتراضي')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy ? null : () => _runAction(() => controller.createManualBackup().then((_) {})),
                      icon: const Icon(Icons.backup_rounded, size: 18),
                      label: Text(l10n.pick('Backup', 'نسخة احتياطية')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy || widget.appPreferencesController.storagePreference != StoragePreference.hybrid
                          ? null
                          : () => _runAction(() => controller.syncNow(force: true), successMessage: l10n.pick('Synchronization completed.', 'اكتملت المزامنة.')),
                      icon: controller.isSynchronizing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.sync_rounded, size: 18),
                      label: Text(l10n.pick('Sync now', 'زامن الآن')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy
                          ? null
                          : () => _runAction(() async {
                              await _saveConfiguredPaths();
                              await controller.importDatabaseCopy(_importPathController.text);
                            }),
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: Text(l10n.pick('Import DB', 'استيراد قاعدة')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy ? null : () => _runAction(() => controller.exportDatabaseCopy(_exportDatabasePathController.text)),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: Text(l10n.pick('Export DB', 'تصدير قاعدة')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy ? null : () => _runAction(() => controller.exportPortableSnapshot(_exportJsonPathController.text)),
                      icon: const Icon(Icons.data_object_rounded, size: 18),
                      label: Text(l10n.pick('Export JSON', 'تصدير JSON')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy ? null : () => _runAction(controller.refreshStatus),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text(context.l10n.refresh),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy
                          ? null
                          : () async {
                              final confirmed = await _confirmAction(
                                title: l10n.pick('Reset local storage?', 'إعادة تعيين التخزين المحلي؟'),
                                message: l10n.pick(
                                  'A backup will be created first when automatic backups allow it, then local cached records will be cleared.',
                                  'سيتم إنشاء نسخة احتياطية أولًا عندما تسمح إعدادات النسخ الاحتياطي التلقائي، ثم سيتم مسح السجلات المخزنة محليًا.',
                                ),
                              );
                              if (!confirmed) {
                                return;
                              }
                              await _runAction(controller.resetLocalStorage);
                            },
                      icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                      label: Text(l10n.pick('Reset local', 'إعادة تعيين')),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      onPressed: isBusy
                          ? null
                          : () async {
                              final confirmed = await _confirmAction(
                                title: l10n.pick('Delete and recreate database?', 'حذف قاعدة البيانات وإعادة إنشائها؟'),
                                message: l10n.pick(
                                  'Use this only when the current local database is corrupted or cannot be opened safely.',
                                  'استخدم هذا فقط عندما تكون قاعدة البيانات المحلية الحالية تالفة أو لا يمكن فتحها بأمان.',
                                ),
                              );
                              if (!confirmed) {
                                return;
                              }
                              await _runAction(controller.deleteCorruptedDatabase);
                            },
                      icon: const Icon(Icons.delete_forever_rounded, size: 18),
                      label: Text(l10n.pick('Recreate DB', 'أعد الإنشاء')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SettingsSubsection(
                title: l10n.pick('Status', 'الحالة'),
                child: _StatusPanel(controller: controller, status: status),
              ),
              if (controller.statusMessage != null) ...[
                const SizedBox(height: 10),
                _FeedbackBanner(icon: Icons.info_outline_rounded, color: colorScheme.primary, backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.45), message: controller.statusMessage!),
              ],
              if (controller.lastError != null) ...[
                const SizedBox(height: 10),
                _FeedbackBanner(icon: Icons.error_outline_rounded, color: colorScheme.error, backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.45), message: controller.lastError!),
              ],
              if (controller.synchronizationError != null && controller.synchronizationError != controller.lastError) ...[
                const SizedBox(height: 10),
                _FeedbackBanner(icon: Icons.sync_problem_rounded, color: colorScheme.error, backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.45), message: controller.synchronizationError!),
              ],
              const SizedBox(height: 12),
              _SettingsSubsection(
                title: l10n.pick('Backup history', 'سجل النسخ الاحتياطية'),
                child: controller.backupHistory.isEmpty
                    ? Text(l10n.pick('No backups have been created yet.', 'لم يتم إنشاء أي نسخ احتياطية بعد.'), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant))
                    : Column(
                        children: controller.backupHistory
                            .map(
                              (record) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: BorderSide(color: colorScheme.outlineVariant),
                                ),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  title: Text(p.basename(record.path), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  subtitle: Text(
                                    '${controller.formatBytes(record.sizeBytes)} • ${record.automatic ? l10n.pick('Automatic', 'تلقائي') : l10n.pick('Manual', 'يدوي')}\n${DateTime.fromMillisecondsSinceEpoch(record.createdAtMillis).toLocal().toIso8601String()}',
                                  ),
                                  isThreeLine: true,
                                  trailing: Wrap(
                                    spacing: 4,
                                    children: [
                                      IconButton(
                                        tooltip: l10n.pick('Restore backup', 'استعادة النسخة الاحتياطية'),
                                        onPressed: isBusy
                                            ? null
                                            : () async {
                                                final confirmed = await _confirmAction(
                                                  title: l10n.pick('Restore backup?', 'استعادة النسخة الاحتياطية؟'),
                                                  message: l10n.pick(
                                                    'The current database will be replaced after validation. A rollback backup will be kept if restore fails.',
                                                    'سيتم استبدال قاعدة البيانات الحالية بعد التحقق. سيتم الاحتفاظ بنسخة تراجع إذا فشلت الاستعادة.',
                                                  ),
                                                );
                                                if (!confirmed) {
                                                  return;
                                                }
                                                await _runAction(() => controller.restoreBackup(record));
                                              },
                                        icon: const Icon(Icons.restore_page_rounded),
                                      ),
                                      IconButton(
                                        tooltip: l10n.pick('Delete backup', 'حذف النسخة الاحتياطية'),
                                        onPressed: isBusy ? null : () => _runAction(() => controller.deleteBackupRecord(record)),
                                        icon: const Icon(Icons.delete_outline_rounded),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsSubsection extends StatelessWidget {
  const _SettingsSubsection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _PathField extends StatelessWidget {
  const _PathField({required this.controller, required this.focusNode, required this.label, required this.hint, this.suffixIcon});

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder(), suffixIcon: suffixIcon, isDense: true),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.controller, required this.status});

  final LocalDatabaseManagementController controller;
  final LocalDatabaseStatusSnapshot status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.pick('Database status', 'حالة قاعدة البيانات'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _StatusRow(label: context.l10n.pick('Path', 'المسار'), value: status.databasePath),
          _StatusRow(label: context.l10n.pick('Exists', 'موجود'), value: status.exists ? context.l10n.pick('Yes', 'نعم') : context.l10n.pick('No', 'لا')),
          _StatusRow(label: context.l10n.pick('Connected', 'متصل'), value: status.isConnected ? context.l10n.pick('Healthy', 'سليم') : context.l10n.pick('Unavailable', 'غير متاح')),
          _StatusRow(label: context.l10n.pick('Size', 'الحجم'), value: controller.formatBytes(status.sizeBytes)),
          _StatusRow(label: context.l10n.pick('Last modified', 'آخر تعديل'), value: status.lastModified?.toLocal().toIso8601String() ?? context.l10n.unknown),
          _StatusRow(label: context.l10n.pick('Synchronization state', 'حالة المزامنة'), value: status.syncState),
          _StatusRow(label: context.l10n.pick('Pending sync queue', 'طابور المزامنة المعلق'), value: controller.pendingSynchronizationCount.toString()),
          _StatusRow(label: context.l10n.pick('Last pushed records', 'آخر السجلات المرسلة'), value: controller.lastPushedCount.toString()),
          _StatusRow(label: context.l10n.pick('Last pulled rows', 'آخر الصفوف المسحوبة'), value: controller.lastPulledCount.toString()),
          _StatusRow(label: context.l10n.pick('Last synchronization', 'آخر مزامنة'), value: controller.lastSynchronizationAt?.toLocal().toIso8601String() ?? context.l10n.pick('Never', 'أبدًا')),
          _StatusRow(label: context.l10n.pick('Backups', 'النسخ الاحتياطية'), value: status.backupCount.toString()),
          if (controller.storageSizeWarning) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.pick(
                'Storage warning: the local database is larger than 100 MB. Review backup cadence and export older copies if needed.',
                'تحذير تخزين: قاعدة البيانات المحلية أكبر من 100 ميجابايت. راجع وتيرة النسخ الاحتياطي وصدّر النسخ الأقدم إذا لزم الأمر.',
              ),
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 126,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.icon, required this.color, required this.backgroundColor, required this.message});

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _SyncConflictDiagnosticsTile extends StatelessWidget {
  const _SyncConflictDiagnosticsTile({required this.conflictedRecordsCount, required this.latestConflictMillis});

  final int conflictedRecordsCount;
  final int? latestConflictMillis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final latestConflictText = latestConflictMillis == null ? l10n.unknown : DateTime.fromMillisecondsSinceEpoch(latestConflictMillis!, isUtc: false).toLocal().toIso8601String();

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
                Text(l10n.syncConflictOverrodePendingLocalEdits, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(l10n.conflictedRecords('$conflictedRecordsCount'), style: theme.textTheme.bodySmall),
                Text(l10n.latestConflictAt(latestConflictText), style: theme.textTheme.bodySmall),
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
    return _SelectableSettingsTile(icon: icon, title: label, selected: value == currentValue,
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
    return _SelectableSettingsTile(icon: icon, title: label,
      selected: selected,
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
    return _SelectableSettingsTile(icon: icon, title: label, subtitle: description, badgeLabel: recommendedLabel, selected: selected, onTap: onTap);
  }
}

class _SelectableSettingsTile extends StatelessWidget {
  const _SelectableSettingsTile({required this.icon, required this.title, required this.selected, required this.onTap, this.subtitle, this.badgeLabel});

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badgeLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: selected ? colorScheme.primaryContainer.withValues(alpha: 0.5) : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? colorScheme.primary.withValues(alpha: 0.55) : colorScheme.outlineVariant, width: selected ? 1.4 : 1),
            boxShadow: selected ? [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, 8))] : const <BoxShadow>[],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: selected ? colorScheme.primary.withValues(alpha: 0.12) : colorScheme.surface, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 20, color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                        ),
                        if (badgeLabel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(999)),
                            child: Text(
                              badgeLabel!,
                              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onSecondaryContainer),
                            ),
                          ),
                      ],
                    ),
                    if (subtitle != null) ...[const SizedBox(height: 6), Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.3))],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? colorScheme.primary : colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
