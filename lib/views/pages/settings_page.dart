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
                      onTap: () => (localDatabaseManagementController?.setStoragePreference(StoragePreference.hybrid) ?? appPreferencesController.setStoragePreference(StoragePreference.hybrid)),
                    ),
                    _StoragePreferenceOptionTile(
                      icon: Icons.cloud_done_rounded,
                      label: l10n.storageOnlineOnly,
                      description: l10n.storageOnlineOnlyDescription,
                      selected: appPreferencesController.storagePreference == StoragePreference.onlineOnly,
                      onTap: () => (localDatabaseManagementController?.setStoragePreference(StoragePreference.onlineOnly) ?? appPreferencesController.setStoragePreference(StoragePreference.onlineOnly)),
                    ),
                    _StoragePreferenceOptionTile(
                      icon: Icons.phone_android_rounded,
                      label: l10n.storageLocalOnly,
                      description: l10n.storageLocalOnlyDescription,
                      selected: appPreferencesController.storagePreference == StoragePreference.localOnly,
                      onTap: () => (localDatabaseManagementController?.setStoragePreference(StoragePreference.localOnly) ?? appPreferencesController.setStoragePreference(StoragePreference.localOnly)),
                    ),
                    if (localDatabaseManagementController != null) ...[
                      const SizedBox(height: 24),
                      _LocalDatabaseManagementSection(
                        controller: localDatabaseManagementController!,
                        appPreferencesController: appPreferencesController,
                      ),
                    ],
                    if (conflictedRecords.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(l10n.syncConflictDiagnostics, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
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
    controller.value = TextEditingValue(text: value, selection: TextSelection.collapsed(offset: value.length));
  }

  Future<void> _saveConfiguredPaths() async {
    await widget.controller.setDatabaseDirectoryPath(_databaseDirectoryController.text);
    await widget.controller.setDatabaseFileName(_databaseFileController.text);
    await widget.controller.setBackupDirectoryPath(_backupDirectoryController.text);
  }

  void _applySelectedText(TextEditingController controller, String value) {
    controller.value = TextEditingValue(text: value, selection: TextSelection.collapsed(offset: value.length));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resolvedMessage)));
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
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

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.pick('Local Database Management', 'إدارة قاعدة البيانات المحلية'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            l10n.pick(
              'Manage the local SQLite file, backup lifecycle, restore safety, storage location, and synchronization behavior from one place.',
              'أدر ملف SQLite المحلي ودورة النسخ الاحتياطي وسلامة الاستعادة وموقع التخزين وسلوك المزامنة من مكان واحد.',
            ),
            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<LocalDatabaseSyncBehavior>(
                  initialValue: controller.syncBehavior,
                  decoration: InputDecoration(labelText: l10n.pick('Synchronization behavior', 'سلوك المزامنة'), border: const OutlineInputBorder()),
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
                          child: Text(
                            switch (value) {
                            LocalDatabaseSyncBehavior.automatic => l10n.pick('Automatic', 'تلقائي'),
                            LocalDatabaseSyncBehavior.manual => l10n.pick('Manual', 'يدوي'),
                            LocalDatabaseSyncBehavior.paused => l10n.pick('Paused', 'متوقف'),
                            },
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<AutomaticBackupInterval>(
                  initialValue: controller.automaticBackupInterval,
                  decoration: InputDecoration(labelText: l10n.pick('Automatic backup interval', 'فاصل النسخ الاحتياطي التلقائي'), border: const OutlineInputBorder()),
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
                          child: Text(
                            switch (value) {
                            AutomaticBackupInterval.disabled => l10n.pick('Disabled', 'معطل'),
                            AutomaticBackupInterval.daily => l10n.pick('Daily', 'يومي'),
                            AutomaticBackupInterval.weekly => l10n.pick('Weekly', 'أسبوعي'),
                            AutomaticBackupInterval.monthly => l10n.pick('Monthly', 'شهري'),
                            },
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PathField(
            controller: _databaseDirectoryController,
            focusNode: _databaseDirectoryFocusNode,
            label: l10n.pick('Database folder', 'مجلد قاعدة البيانات'),
            hint: '/path/to/database/folder',
            suffixIcon: IconButton(
              tooltip: l10n.pick('Choose folder', 'اختر مجلد'),
              onPressed: isBusy ? null : _pickDatabaseDirectory,
              icon: const Icon(Icons.folder_open_rounded),
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),
          _PathField(
            controller: _backupDirectoryController,
            focusNode: _backupDirectoryFocusNode,
            label: l10n.pick('Backup destination folder', 'مجلد وجهة النسخ الاحتياطي'),
            hint: '/path/to/backup/folder',
            suffixIcon: IconButton(
              tooltip: l10n.pick('Choose backup folder', 'اختر مجلد النسخ الاحتياطي'),
              onPressed: isBusy ? null : _pickBackupDirectory,
              icon: const Icon(Icons.folder_copy_rounded),
            ),
          ),
          const SizedBox(height: 12),
          _PathField(
            controller: _importPathController,
            focusNode: _importPathFocusNode,
            label: l10n.pick('Import or restore source file', 'ملف الاستيراد أو الاستعادة'),
            hint: '/path/to/database.sqlite',
            suffixIcon: IconButton(
              tooltip: l10n.pick('Choose database file', 'اختر ملف قاعدة البيانات'),
              onPressed: isBusy ? null : _pickImportSourceFile,
              icon: const Icon(Icons.attach_file_rounded),
            ),
          ),
          const SizedBox(height: 12),
          _PathField(
            controller: _exportDatabasePathController,
            focusNode: _exportDatabasePathFocusNode,
            label: l10n.pick('Database export file', 'ملف تصدير قاعدة البيانات'),
            hint: '/path/to/export.sqlite',
            suffixIcon: IconButton(
              tooltip: l10n.pick('Choose export location', 'اختر موقع التصدير'),
              onPressed: isBusy ? null : _pickExportDatabasePath,
              icon: const Icon(Icons.save_alt_rounded),
            ),
          ),
          const SizedBox(height: 12),
          _PathField(
            controller: _exportJsonPathController,
            focusNode: _exportJsonPathFocusNode,
            label: l10n.pick('Portable JSON export file', 'ملف تصدير JSON قابل للنقل'),
            hint: '/path/to/export.json',
            suffixIcon: IconButton(
              tooltip: l10n.pick('Choose export location', 'اختر موقع التصدير'),
              onPressed: isBusy ? null : _pickExportJsonPath,
              icon: const Icon(Icons.save_alt_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: isBusy
                    ? null
                    : () => _runAction(() async {
                        await _saveConfiguredPaths();
                        await controller.openOrCreateDatabase();
                      }),
                icon: const Icon(Icons.storage_rounded),
                label: Text(l10n.pick('Open or create database', 'افتح أو أنشئ قاعدة البيانات')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => _runAction(() async {
                        await _saveConfiguredPaths();
                        await controller.changeDatabaseLocation();
                      }),
                icon: const Icon(Icons.drive_file_move_rounded),
                label: Text(l10n.pick('Move database', 'انقل قاعدة البيانات')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => _runAction(() async {
                        await controller.restoreDefaultPaths();
                        _syncTextControllers();
                      }, successMessage: l10n.pick('Default database paths restored.', 'تمت استعادة مسارات قاعدة البيانات الافتراضية.')),
                icon: const Icon(Icons.restore_rounded),
                label: Text(l10n.pick('Restore default paths', 'استعادة المسارات الافتراضية')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => _runAction(() => controller.createManualBackup().then((_) {})),
                icon: const Icon(Icons.backup_rounded),
                label: Text(l10n.pick('Create backup', 'إنشاء نسخة احتياطية')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy || widget.appPreferencesController.storagePreference != StoragePreference.hybrid
                    ? null
                    : () => _runAction(() => controller.syncNow(force: true), successMessage: l10n.pick('Synchronization completed.', 'اكتملت المزامنة.')),
                icon: controller.isSynchronizing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.sync_rounded),
                label: Text(l10n.pick('Sync now', 'زامن الآن')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => _runAction(() async {
                        await _saveConfiguredPaths();
                        await controller.importDatabaseCopy(_importPathController.text);
                      }),
                icon: const Icon(Icons.upload_file_rounded),
                label: Text(l10n.pick('Import database file', 'استيراد ملف قاعدة البيانات')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => _runAction(() => controller.exportDatabaseCopy(_exportDatabasePathController.text)),
                icon: const Icon(Icons.download_rounded),
                label: Text(l10n.pick('Export database copy', 'تصدير نسخة من قاعدة البيانات')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => _runAction(() => controller.exportPortableSnapshot(_exportJsonPathController.text)),
                icon: const Icon(Icons.data_object_rounded),
                label: Text(l10n.pick('Export JSON snapshot', 'تصدير لقطة JSON')),
              ),
              OutlinedButton.icon(
                onPressed: isBusy ? null : () => _runAction(controller.refreshStatus),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.refresh),
              ),
              OutlinedButton.icon(
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
                icon: const Icon(Icons.delete_sweep_rounded),
                label: Text(l10n.pick('Reset local storage', 'إعادة تعيين التخزين المحلي')),
              ),
              OutlinedButton.icon(
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
                icon: const Icon(Icons.delete_forever_rounded),
                label: Text(l10n.pick('Delete and recreate database', 'حذف قاعدة البيانات وإعادة إنشائها')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StatusPanel(controller: controller, status: status),
          if (controller.statusMessage != null) ...[
            const SizedBox(height: 12),
            _FeedbackBanner(
              icon: Icons.info_outline_rounded,
              color: colorScheme.primary,
              backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.45),
              message: controller.statusMessage!,
            ),
          ],
          if (controller.lastError != null) ...[
            const SizedBox(height: 12),
            _FeedbackBanner(
              icon: Icons.error_outline_rounded,
              color: colorScheme.error,
              backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.45),
              message: controller.lastError!,
            ),
          ],
          if (controller.synchronizationError != null && controller.synchronizationError != controller.lastError) ...[
            const SizedBox(height: 12),
            _FeedbackBanner(
              icon: Icons.sync_problem_rounded,
              color: colorScheme.error,
              backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.45),
              message: controller.synchronizationError!,
            ),
          ],
          const SizedBox(height: 16),
          Text(l10n.pick('Backup history', 'سجل النسخ الاحتياطية'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (controller.backupHistory.isEmpty)
            Text(l10n.pick('No backups have been created yet.', 'لم يتم إنشاء أي نسخ احتياطية بعد.'), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant))
          else
            Column(
              children: controller.backupHistory
                  .map(
                    (record) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        title: Text(p.basename(record.path), maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          '${record.path}\n${controller.formatBytes(record.sizeBytes)} • ${record.automatic ? l10n.pick('Automatic', 'تلقائي') : l10n.pick('Manual', 'يدوي')} • ${DateTime.fromMillisecondsSinceEpoch(record.createdAtMillis).toLocal().toIso8601String()}',
                        ),
                        isThreeLine: true,
                        trailing: Wrap(
                          spacing: 6,
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
                              onPressed: isBusy
                                  ? null
                                  : () => _runAction(() => controller.deleteBackupRecord(record)),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
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
      decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder(), suffixIcon: suffixIcon),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.pick('Database status', 'حالة قاعدة البيانات'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 138, child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
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
