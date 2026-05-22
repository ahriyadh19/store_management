import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/local_database_sync_service.dart';

enum LocalDatabaseSyncBehavior { automatic, manual, paused }

enum AutomaticBackupInterval { disabled, daily, weekly, monthly }

class LocalDatabaseBackupRecord {
  const LocalDatabaseBackupRecord({
    required this.id,
    required this.path,
    required this.createdAtMillis,
    required this.sizeBytes,
    required this.schemaVersion,
    required this.sourceDatabasePath,
    required this.reason,
    required this.automatic,
  });

  final String id;
  final String path;
  final int createdAtMillis;
  final int sizeBytes;
  final int schemaVersion;
  final String sourceDatabasePath;
  final String reason;
  final bool automatic;

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMillis);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'path': path,
      'createdAtMillis': createdAtMillis,
      'sizeBytes': sizeBytes,
      'schemaVersion': schemaVersion,
      'sourceDatabasePath': sourceDatabasePath,
      'reason': reason,
      'automatic': automatic,
    };
  }

  static LocalDatabaseBackupRecord fromJson(Map<String, dynamic> json) {
    return LocalDatabaseBackupRecord(
      id: json['id']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      createdAtMillis: json['createdAtMillis'] is int ? json['createdAtMillis'] as int : int.tryParse(json['createdAtMillis']?.toString() ?? '') ?? 0,
      sizeBytes: json['sizeBytes'] is int ? json['sizeBytes'] as int : int.tryParse(json['sizeBytes']?.toString() ?? '') ?? 0,
      schemaVersion: json['schemaVersion'] is int ? json['schemaVersion'] as int : int.tryParse(json['schemaVersion']?.toString() ?? '') ?? LocalDatabase.schemaVersionValue,
      sourceDatabasePath: json['sourceDatabasePath']?.toString() ?? '',
      reason: json['reason']?.toString() ?? 'manual',
      automatic: json['automatic'] == true,
    );
  }
}

class LocalDatabaseStatusSnapshot {
  const LocalDatabaseStatusSnapshot({
    required this.databasePath,
    required this.exists,
    required this.sizeBytes,
    required this.lastModified,
    required this.isConnected,
    required this.syncState,
    required this.backupCount,
    required this.isLocalDatabaseEnabled,
  });

  final String databasePath;
  final bool exists;
  final int sizeBytes;
  final DateTime? lastModified;
  final bool isConnected;
  final String syncState;
  final int backupCount;
  final bool isLocalDatabaseEnabled;
}

class LocalDatabaseManagementController extends ChangeNotifier {
  LocalDatabaseManagementController._({
    required AppPreferencesController appPreferencesController,
    required SharedPreferences preferences,
    required LocalDatabase? localDatabase,
    required String databaseDirectoryPath,
    required String databaseFileName,
    required String backupDirectoryPath,
    required LocalDatabaseSyncBehavior syncBehavior,
    required AutomaticBackupInterval automaticBackupInterval,
    required List<LocalDatabaseBackupRecord> backupHistory,
  }) : _appPreferencesController = appPreferencesController,
       _preferences = preferences,
       _database = localDatabase,
       _databaseDirectoryPath = databaseDirectoryPath,
       _databaseFileName = databaseFileName,
       _backupDirectoryPath = backupDirectoryPath,
       _syncBehavior = syncBehavior,
       _automaticBackupInterval = automaticBackupInterval,
       _backupHistory = backupHistory {
    _appPreferencesController.addListener(_handleAppPreferencesChanged);
  }

  static const String _databasePathKey = 'localDatabase.databasePath';
  static const String _backupDirectoryPathKey = 'localDatabase.backupDirectoryPath';
  static const String _syncBehaviorKey = 'localDatabase.syncBehavior';
  static const String _automaticBackupIntervalKey = 'localDatabase.automaticBackupInterval';
  static const String _backupHistoryKey = 'localDatabase.backupHistory';
  static const int _backupHistoryLimit = 20;
  static const int _sizeWarningThresholdBytes = 100 * 1024 * 1024;

  final AppPreferencesController _appPreferencesController;
  final SharedPreferences _preferences;
  late final LocalDatabaseSyncService _syncService;

  LocalDatabase? _database;
  String _databaseDirectoryPath;
  String _databaseFileName;
  String _backupDirectoryPath;
  LocalDatabaseSyncBehavior _syncBehavior;
  AutomaticBackupInterval _automaticBackupInterval;
  List<LocalDatabaseBackupRecord> _backupHistory;

  bool _isReady = false;
  bool _isBusy = false;
  String? _statusMessage;
  String? _lastError;
  int _sizeBytes = 0;
  DateTime? _lastModified;
  bool _databaseExists = false;

  static Future<LocalDatabaseManagementController> create({required AppPreferencesController appPreferencesController, LocalDatabase? localDatabase}) async {
    final preferences = await SharedPreferences.getInstance();
    final defaultDatabasePath = await LocalDatabase.defaultDatabasePath();
    final configuredDatabasePath = (preferences.getString(_databasePathKey) ?? '').trim();
    final resolvedDatabasePath = configuredDatabasePath.isEmpty ? (localDatabase?.databasePath.isNotEmpty == true ? localDatabase!.databasePath : defaultDatabasePath) : configuredDatabasePath;
    final parsedDatabasePath = _normalizeDatabasePath(resolvedDatabasePath);
    final defaultBackupDirectoryPath = p.join(parsedDatabasePath.parent, 'backups');
    final backupDirectoryPath = (preferences.getString(_backupDirectoryPathKey) ?? '').trim();

    final controller = LocalDatabaseManagementController._(
      appPreferencesController: appPreferencesController,
      preferences: preferences,
      localDatabase: localDatabase,
      databaseDirectoryPath: parsedDatabasePath.parent,
      databaseFileName: parsedDatabasePath.fileName,
      backupDirectoryPath: backupDirectoryPath.isEmpty ? defaultBackupDirectoryPath : backupDirectoryPath,
      syncBehavior: _syncBehaviorFromStorage(preferences.getString(_syncBehaviorKey)),
      automaticBackupInterval: _automaticBackupIntervalFromStorage(preferences.getString(_automaticBackupIntervalKey)),
      backupHistory: _backupHistoryFromStorage(preferences.getString(_backupHistoryKey)),
    );

    controller._syncService = LocalDatabaseSyncService(
      storagePreference: appPreferencesController.storagePreference,
      automaticSyncEnabled: controller._syncBehavior == LocalDatabaseSyncBehavior.automatic,
      syncPaused: controller._syncBehavior == LocalDatabaseSyncBehavior.paused,
      isDatabaseBusy: () => controller._isBusy,
    )..addListener(controller._handleSyncServiceChanged);

    await controller._persistConfiguration();
    await controller.refreshStatus();
    await controller._syncService.refreshPendingCount();
    controller._isReady = true;
    controller.notifyListeners();
    return controller;
  }

  bool get isReady => _isReady;
  bool get isBusy => _isBusy;
  String? get statusMessage => _statusMessage;
  String? get lastError => _lastError;
  String get databaseDirectoryPath => _databaseDirectoryPath;
  String get databaseFileName => _databaseFileName;
  String get configuredDatabasePath => p.join(_databaseDirectoryPath, _databaseFileName);
  String get backupDirectoryPath => _backupDirectoryPath;
  LocalDatabaseSyncBehavior get syncBehavior => _syncBehavior;
  AutomaticBackupInterval get automaticBackupInterval => _automaticBackupInterval;
  List<LocalDatabaseBackupRecord> get backupHistory => List<LocalDatabaseBackupRecord>.unmodifiable(_backupHistory);
  bool get isLocalDatabaseEnabled => _appPreferencesController.storagePreference != StoragePreference.onlineOnly;
  bool get storageSizeWarning => _sizeBytes >= _sizeWarningThresholdBytes;
  bool get canManageDatabase => !_isBusy;
  int get pendingSynchronizationCount => _syncService.pendingRecordsCount;
  int get lastPushedCount => _syncService.lastPushedCount;
  int get lastPulledCount => _syncService.lastPulledCount;
  DateTime? get lastSynchronizationAt => _syncService.lastCompletedAt;
  String? get synchronizationError => _syncService.lastErrorMessage;
  LocalDatabaseSyncRunState get synchronizationRunState => _syncService.state;
  bool get isSynchronizing => _syncService.isRunning;

  LocalDatabaseStatusSnapshot get statusSnapshot {
    return LocalDatabaseStatusSnapshot(
      databasePath: configuredDatabasePath,
      exists: _databaseExists,
      sizeBytes: _sizeBytes,
      lastModified: _lastModified,
      isConnected: (_database ?? LocalDatabase.current)?.ping() ?? false,
      syncState: synchronizationStateLabel,
      backupCount: _backupHistory.length,
      isLocalDatabaseEnabled: isLocalDatabaseEnabled,
    );
  }

  String get synchronizationStateLabel {
    switch (_appPreferencesController.storagePreference) {
      case StoragePreference.hybrid:
        final behaviorLabel = switch (_syncBehavior) {
          LocalDatabaseSyncBehavior.automatic => 'Hybrid sync automatic',
          LocalDatabaseSyncBehavior.manual => 'Hybrid sync manual',
          LocalDatabaseSyncBehavior.paused => 'Hybrid sync paused',
        };
        final runtimeLabel = switch (_syncService.state) {
          LocalDatabaseSyncRunState.idle => 'ready',
          LocalDatabaseSyncRunState.running => 'running',
          LocalDatabaseSyncRunState.paused => 'paused',
          LocalDatabaseSyncRunState.offline => 'offline',
          LocalDatabaseSyncRunState.failed => 'error',
        };
        return '$behaviorLabel • $runtimeLabel';
      case StoragePreference.onlineOnly:
        return 'Online only';
      case StoragePreference.localOnly:
        return 'Local only';
    }
  }

  void startSyncMonitoring() {
    _syncService.start();
  }

  Future<void> syncNow({bool force = true}) {
    return _syncService.syncNow(force: force);
  }

  Future<void> setLocalDatabaseEnabled(bool value) async {
    if (value == isLocalDatabaseEnabled) {
      return;
    }

    if (value) {
      await _appPreferencesController.setStoragePreference(StoragePreference.hybrid);
      await openOrCreateDatabase();
      _statusMessage = 'Local database enabled.';
    } else {
      await _appPreferencesController.setStoragePreference(StoragePreference.onlineOnly);
      _statusMessage = 'Local database disabled; remote-only mode is active.';
    }
    _syncService.updateConfiguration(
      storagePreference: _appPreferencesController.storagePreference,
      automaticSyncEnabled: _syncBehavior == LocalDatabaseSyncBehavior.automatic,
      syncPaused: _syncBehavior == LocalDatabaseSyncBehavior.paused,
    );
    notifyListeners();
  }

  Future<void> setStoragePreference(StoragePreference value) async {
    if (_appPreferencesController.storagePreference == value) {
      return;
    }

    await _appPreferencesController.setStoragePreference(value);
    _syncService.updateConfiguration(
      storagePreference: _appPreferencesController.storagePreference,
      automaticSyncEnabled: _syncBehavior == LocalDatabaseSyncBehavior.automatic,
      syncPaused: _syncBehavior == LocalDatabaseSyncBehavior.paused,
    );
    if (value != StoragePreference.onlineOnly) {
      await openOrCreateDatabase();
    } else {
      await refreshStatus();
    }
  }

  Future<void> setSyncBehavior(LocalDatabaseSyncBehavior value) async {
    if (_syncBehavior == value) {
      return;
    }

    _syncBehavior = value;
    await _preferences.setString(_syncBehaviorKey, value.name);
    _syncService.updateConfiguration(
      storagePreference: _appPreferencesController.storagePreference,
      automaticSyncEnabled: _syncBehavior == LocalDatabaseSyncBehavior.automatic,
      syncPaused: _syncBehavior == LocalDatabaseSyncBehavior.paused,
    );
    _statusMessage = 'Synchronization behavior updated.';
    notifyListeners();
  }

  Future<void> setAutomaticBackupInterval(AutomaticBackupInterval value) async {
    if (_automaticBackupInterval == value) {
      return;
    }

    _automaticBackupInterval = value;
    await _preferences.setString(_automaticBackupIntervalKey, value.name);
    _statusMessage = 'Automatic backup policy updated.';
    notifyListeners();
  }

  Future<void> setDatabaseDirectoryPath(String value) async {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty || _databaseDirectoryPath == normalizedValue) {
      return;
    }

    _databaseDirectoryPath = normalizedValue;
    await _persistConfiguration();
    notifyListeners();
  }

  Future<void> setDatabaseFileName(String value) async {
    final sanitizedFileName = _sanitizeFileName(value);
    if (sanitizedFileName.isEmpty || _databaseFileName == sanitizedFileName) {
      return;
    }

    _databaseFileName = sanitizedFileName;
    await _persistConfiguration();
    notifyListeners();
  }

  Future<void> setBackupDirectoryPath(String value) async {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty || _backupDirectoryPath == normalizedValue) {
      return;
    }

    _backupDirectoryPath = normalizedValue;
    await _preferences.setString(_backupDirectoryPathKey, normalizedValue);
    notifyListeners();
  }

  Future<void> restoreDefaultPaths() async {
    final defaultDatabasePath = await LocalDatabase.defaultDatabasePath();
    final defaultParsedPath = _normalizeDatabasePath(defaultDatabasePath);
    _databaseDirectoryPath = defaultParsedPath.parent;
    _databaseFileName = defaultParsedPath.fileName;
    _backupDirectoryPath = p.join(defaultParsedPath.parent, 'backups');
    await _persistConfiguration();
    notifyListeners();
  }

  Future<void> refreshStatus() async {
    _database = LocalDatabase.current ?? _database;
    _backupHistory = await _purgeMissingBackupHistoryEntries();
    final databaseFile = File(configuredDatabasePath);
    _databaseExists = await databaseFile.exists();
    _sizeBytes = _databaseExists ? await databaseFile.length() : 0;
    _lastModified = _databaseExists ? await databaseFile.lastModified() : null;
    await _syncService.refreshPendingCount();
    notifyListeners();
  }

  Future<void> openOrCreateDatabase() {
    return _runExclusive(() async {
      final targetPath = configuredDatabasePath;
      await _openDatabaseAtPath(targetPath);
      _statusMessage = 'Local database is ready.';
      await _maybeCreateAutomaticBackup(reason: 'open');
    });
  }

  Future<void> changeDatabaseLocation() {
    return _runExclusive(() async {
      final targetPath = configuredDatabasePath;
      final currentPath = _database?.databasePath.isNotEmpty == true ? _database!.databasePath : targetPath;
      if (currentPath == targetPath) {
        await _openDatabaseAtPath(targetPath);
        _statusMessage = 'Database location already matches the current configuration.';
        return;
      }

      final targetFile = await _ensureDatabaseFileLocation(targetPath);
      if (await targetFile.exists()) {
        throw StateError('Target database file already exists. Choose a new file name or import over it explicitly.');
      }

      await _maybeCreateAutomaticBackup(reason: 'move');
      final sourceFile = File(currentPath);
      final rollbackFile = File('$currentPath.rollback');
      if (await sourceFile.exists()) {
        await sourceFile.copy(rollbackFile.path);
      }

      await _database?.close();

      try {
        if (await sourceFile.exists()) {
          await sourceFile.copy(targetFile.path);
          await sourceFile.delete();
        }
        await _openDatabaseAtPath(targetFile.path);
        if (await rollbackFile.exists()) {
          await rollbackFile.delete();
        }
        _statusMessage = 'Database moved to the configured location.';
      } catch (_) {
        if (await rollbackFile.exists()) {
          await rollbackFile.copy(sourceFile.path);
          await rollbackFile.delete();
          await _openDatabaseAtPath(sourceFile.path);
        }
        rethrow;
      }
    });
  }

  Future<void> exportDatabaseCopy(String destinationPath) {
    return _runExclusive(() async {
      final database = await _ensureDatabaseOpen();
      final normalizedPath = destinationPath.trim();
      if (normalizedPath.isEmpty) {
        throw StateError('Provide an export path for the database file.');
      }

      final destinationFile = File(normalizedPath);
      await destinationFile.parent.create(recursive: true);
      final sourceFile = File(database.databasePath);
      if (!await sourceFile.exists()) {
        throw StateError('The current database file does not exist.');
      }

      await sourceFile.copy(destinationFile.path);
      _statusMessage = 'Database file exported.';
    });
  }

  Future<void> exportPortableSnapshot(String destinationPath) {
    return _runExclusive(() async {
      final database = await _ensureDatabaseOpen();
      final normalizedPath = destinationPath.trim();
      if (normalizedPath.isEmpty) {
        throw StateError('Provide a destination path for the JSON export.');
      }

      final records = <Map<String, dynamic>>[];
      for (final modelType in LocalDatabase.managedModelTypes) {
        for (final record in database.getRecordsForType(modelType)) {
          records.add(_offlineRecordToJson(record));
        }
      }

      final tables = <String, List<Map<String, dynamic>>>{
        for (final modelType in LocalDatabase.managedModelTypes) modelType: database.getRowsForType(modelType),
      };

      final exportFile = File(normalizedPath);
      await exportFile.parent.create(recursive: true);
      await exportFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
          'exportedAt': DateTime.now().toIso8601String(),
          'schemaVersion': LocalDatabase.schemaVersionValue,
          'databasePath': database.databasePath,
          'storagePreference': _appPreferencesController.storagePreference.name,
          'syncBehavior': _syncBehavior.name,
          'syncState': synchronizationStateLabel,
          'records': records,
          'tables': tables,
        }),
      );
      _statusMessage = 'Portable JSON export created.';
    });
  }

  Future<void> importDatabaseCopy(String sourcePath) {
    return _runExclusive(() async {
      final validationError = await validateRestoreCandidate(sourcePath);
      if (validationError != null) {
        throw StateError(validationError);
      }

      await _maybeCreateAutomaticBackup(reason: 'import');
      await _replaceCurrentDatabaseWithExternalFile(File(sourcePath.trim()));
      _statusMessage = 'Database imported and reopened.';
    });
  }

  Future<LocalDatabaseBackupRecord> createManualBackup() {
    return _runExclusive<LocalDatabaseBackupRecord>(() async {
      final record = await _createBackup(reason: 'manual', automatic: false);
      _statusMessage = 'Backup created.';
      return record;
    });
  }

  Future<void> restoreBackup(LocalDatabaseBackupRecord record) {
    return _runExclusive(() async {
      final validationError = await validateRestoreCandidate(record.path, backupRecord: record);
      if (validationError != null) {
        throw StateError(validationError);
      }

      await _maybeCreateAutomaticBackup(reason: 'restore');
      await _replaceCurrentDatabaseWithExternalFile(File(record.path));
      _statusMessage = 'Backup restored.';
    });
  }

  Future<void> deleteBackupRecord(LocalDatabaseBackupRecord record, {bool deleteFile = true}) {
    return _runExclusive(() async {
      if (deleteFile) {
        final backupFile = File(record.path);
        if (await backupFile.exists()) {
          await backupFile.delete();
        }
      }

      _backupHistory = _backupHistory.where((item) => item.id != record.id).toList(growable: false);
      await _persistBackupHistory();
      _statusMessage = 'Backup history updated.';
    });
  }

  Future<void> resetLocalStorage() {
    return _runExclusive(() async {
      final database = await _ensureDatabaseOpen();
      await _maybeCreateAutomaticBackup(reason: 'reset');
      database.clearAllRecords();
      _statusMessage = 'Local storage reset completed.';
      await refreshStatus();
    });
  }

  Future<void> deleteCorruptedDatabase() {
    return _runExclusive(() async {
      final databasePath = configuredDatabasePath;
      await _maybeCreateAutomaticBackup(reason: 'delete');
      await _database?.close();
      final databaseFile = File(databasePath);
      if (await databaseFile.exists()) {
        await databaseFile.delete();
      }
      await _openDatabaseAtPath(databasePath);
      _statusMessage = 'Database deleted and recreated.';
    });
  }

  Future<String?> validateRestoreCandidate(String path, {LocalDatabaseBackupRecord? backupRecord}) async {
    final trimmedPath = path.trim();
    if (trimmedPath.isEmpty) {
      return 'Select a database file to restore.';
    }

    final file = File(trimmedPath);
    if (!await file.exists()) {
      return 'The selected database file does not exist.';
    }

    final length = await file.length();
    if (length <= 0) {
      return 'The selected database file is empty.';
    }

    if (backupRecord != null && backupRecord.schemaVersion > LocalDatabase.schemaVersionValue) {
      return 'The backup was created by a newer schema version and cannot be restored safely.';
    }

    final header = await _readSqliteHeader(file);
    if (header != 'SQLite format 3') {
      return 'The selected file is not a valid SQLite database.';
    }

    return null;
  }

  String formatBytes(int bytes) {
    if (bytes <= 0) {
      return '0 B';
    }

    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  void dispose() {
    _appPreferencesController.removeListener(_handleAppPreferencesChanged);
    _syncService
      ..removeListener(_handleSyncServiceChanged)
      ..stop();
    super.dispose();
  }

  Future<T> _runExclusive<T>(Future<T> Function() action) async {
    if (_isBusy) {
      throw StateError('Another local database operation is already in progress.');
    }

    _isBusy = true;
    _lastError = null;
    notifyListeners();

    try {
      final result = await action();
      await refreshStatus();
      return result;
    } catch (error) {
      _lastError = error.toString();
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<LocalDatabase> _ensureDatabaseOpen() async {
    final activeDatabase = LocalDatabase.current ?? _database;
    if (activeDatabase != null && activeDatabase.isAvailable) {
      _database = activeDatabase;
      return activeDatabase;
    }

    return _openDatabaseAtPath(configuredDatabasePath);
  }

  Future<LocalDatabase> _openDatabaseAtPath(String databasePath) async {
    final normalizedPath = _normalizeDatabasePath(databasePath).fullPath;
    final parsedPath = _normalizeDatabasePath(normalizedPath);
    _databaseDirectoryPath = parsedPath.parent;
    _databaseFileName = parsedPath.fileName;
    await _persistConfiguration();
    _database = await LocalDatabase.create(databasePath: normalizedPath);
    return _database!;
  }

  Future<void> _replaceCurrentDatabaseWithExternalFile(File sourceFile) async {
    final currentPath = configuredDatabasePath;
    final currentFile = File(currentPath);
    final rollbackFile = File('$currentPath.rollback');

    if (await currentFile.exists()) {
      await currentFile.copy(rollbackFile.path);
    }

    await _database?.close();

    try {
      final targetFile = await _ensureDatabaseFileLocation(currentPath);
      if (await targetFile.exists()) {
        await targetFile.delete();
      }
      await sourceFile.copy(targetFile.path);
      await _openDatabaseAtPath(targetFile.path);
      if (await rollbackFile.exists()) {
        await rollbackFile.delete();
      }
    } catch (_) {
      if (await rollbackFile.exists()) {
        if (await currentFile.exists()) {
          await currentFile.delete();
        }
        await rollbackFile.copy(currentFile.path);
        await rollbackFile.delete();
        await _openDatabaseAtPath(currentFile.path);
      }
      rethrow;
    }
  }

  Future<File> _ensureDatabaseFileLocation(String databasePath) async {
    final normalizedPath = _normalizeDatabasePath(databasePath).fullPath;
    final file = File(normalizedPath);
    await file.parent.create(recursive: true);
    return file;
  }

  Future<LocalDatabaseBackupRecord> _createBackup({required String reason, required bool automatic}) async {
    final database = await _ensureDatabaseOpen();
    final sourceFile = File(database.databasePath);
    if (!await sourceFile.exists()) {
      throw StateError('The current database file does not exist.');
    }

    final backupDirectory = Directory(_backupDirectoryPath);
    if (!await backupDirectory.exists()) {
      await backupDirectory.create(recursive: true);
    }

    final fileName = '${p.basenameWithoutExtension(database.databaseFileName)}_${_timestampForFileName(DateTime.now())}.sqlite';
    final targetFile = File(p.join(backupDirectory.path, fileName));
    await sourceFile.copy(targetFile.path);
    final record = LocalDatabaseBackupRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}_${automatic ? 'auto' : 'manual'}',
      path: targetFile.path,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      sizeBytes: await targetFile.length(),
      schemaVersion: database.schemaVersion,
      sourceDatabasePath: database.databasePath,
      reason: reason,
      automatic: automatic,
    );

    _backupHistory = <LocalDatabaseBackupRecord>[record, ..._backupHistory]
        .take(_backupHistoryLimit)
        .toList(growable: false);
    await _persistBackupHistory();
    return record;
  }

  Future<void> _maybeCreateAutomaticBackup({required String reason}) async {
    if (_automaticBackupInterval == AutomaticBackupInterval.disabled) {
      return;
    }

    final lastAutomaticBackup = _backupHistory.where((record) => record.automatic).cast<LocalDatabaseBackupRecord?>().firstWhere((record) => record != null, orElse: () => null);
    if (lastAutomaticBackup != null) {
      final elapsed = DateTime.now().difference(lastAutomaticBackup.createdAt);
      final requiredElapsed = switch (_automaticBackupInterval) {
        AutomaticBackupInterval.disabled => const Duration(days: 3650),
        AutomaticBackupInterval.daily => const Duration(days: 1),
        AutomaticBackupInterval.weekly => const Duration(days: 7),
        AutomaticBackupInterval.monthly => const Duration(days: 30),
      };
      if (elapsed < requiredElapsed) {
        return;
      }
    }

    await _createBackup(reason: reason, automatic: true);
  }

  Future<List<LocalDatabaseBackupRecord>> _purgeMissingBackupHistoryEntries() async {
    final retainedRecords = <LocalDatabaseBackupRecord>[];
    var changed = false;
    for (final record in _backupHistory) {
      if (record.path.isEmpty || !await File(record.path).exists()) {
        changed = true;
        continue;
      }
      retainedRecords.add(record);
    }

    if (changed) {
      _backupHistory = retainedRecords;
      await _persistBackupHistory();
    }
    return _backupHistory;
  }

  Future<void> _persistConfiguration() async {
    await _preferences.setString(_databasePathKey, configuredDatabasePath);
    await _preferences.setString(_backupDirectoryPathKey, _backupDirectoryPath);
  }

  Future<void> _persistBackupHistory() async {
    await _preferences.setString(_backupHistoryKey, jsonEncode(_backupHistory.map((record) => record.toJson()).toList(growable: false)));
  }

  void _handleAppPreferencesChanged() {
    _syncService.updateConfiguration(
      storagePreference: _appPreferencesController.storagePreference,
      automaticSyncEnabled: _syncBehavior == LocalDatabaseSyncBehavior.automatic,
      syncPaused: _syncBehavior == LocalDatabaseSyncBehavior.paused,
    );
    notifyListeners();
  }

  void _handleSyncServiceChanged() {
    notifyListeners();
  }

  static ({String fullPath, String parent, String fileName}) _normalizeDatabasePath(String path) {
    final trimmedPath = path.trim();
    if (trimmedPath.isEmpty) {
      return (fullPath: LocalDatabase.defaultFileName, parent: '.', fileName: LocalDatabase.defaultFileName);
    }

    final normalizedPath = p.normalize(trimmedPath);
    return (fullPath: normalizedPath, parent: p.dirname(normalizedPath), fileName: p.basename(normalizedPath));
  }

  static String _sanitizeFileName(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return LocalDatabase.defaultFileName;
    }

    final baseName = p.basename(trimmedValue);
    return baseName.endsWith('.sqlite') || baseName.endsWith('.db') ? baseName : '$baseName.sqlite';
  }

  static String _timestampForFileName(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$year$month${day}_$hour$minute$second';
  }

  static LocalDatabaseSyncBehavior _syncBehaviorFromStorage(String? value) {
    switch (value) {
      case 'manual':
        return LocalDatabaseSyncBehavior.manual;
      case 'paused':
        return LocalDatabaseSyncBehavior.paused;
      case 'automatic':
      default:
        return LocalDatabaseSyncBehavior.automatic;
    }
  }

  static AutomaticBackupInterval _automaticBackupIntervalFromStorage(String? value) {
    switch (value) {
      case 'daily':
        return AutomaticBackupInterval.daily;
      case 'weekly':
        return AutomaticBackupInterval.weekly;
      case 'monthly':
        return AutomaticBackupInterval.monthly;
      case 'disabled':
      default:
        return AutomaticBackupInterval.disabled;
    }
  }

  static List<LocalDatabaseBackupRecord> _backupHistoryFromStorage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const <LocalDatabaseBackupRecord>[];
    }

    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) {
        return const <LocalDatabaseBackupRecord>[];
      }
      return decoded
          .whereType<Map>()
          .map((item) => LocalDatabaseBackupRecord.fromJson(Map<String, dynamic>.from(item)))
          .where((record) => record.id.isNotEmpty && record.path.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const <LocalDatabaseBackupRecord>[];
    }
  }

  static Future<String> _readSqliteHeader(File file) async {
    final reader = await file.open();
    try {
      final bytes = await reader.read(15);
      if (bytes.length < 15) {
        return '';
      }
      return ascii.decode(bytes);
    } finally {
      await reader.close();
    }
  }

  static Map<String, dynamic> _offlineRecordToJson(OfflineSyncRecord record) {
    return <String, dynamic>{
      'id': record.id,
      'cacheKey': record.cacheKey,
      'modelType': record.modelType,
      'recordUuid': record.recordUuid,
      'payloadJson': record.payloadJson,
      'updatedAtMillis': record.updatedAtMillis,
      'remoteUpdatedAtMillis': record.remoteUpdatedAtMillis,
      'conflictDetectedAtMillis': record.conflictDetectedAtMillis,
      'syncState': record.syncState,
      'isDeleted': record.isDeleted,
    };
  }
}