import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/models/store_branches.dart';
import 'package:store_management/services/sync_payload_normalizer.dart';

part 'local_database_drift.g.dart';

class SyncRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cacheKey => text().unique()();
  TextColumn get modelType => text()();
  TextColumn get recordUuid => text()();
  TextColumn get payloadJson => text()();
  IntColumn get updatedAtMillis => integer()();
  IntColumn get remoteUpdatedAtMillis => integer().nullable()();
  IntColumn get conflictDetectedAtMillis => integer().nullable()();
  IntColumn get syncState => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

}

@DriftDatabase(tables: <Type>[SyncRecords])
class _LocalStoreDatabase extends _$_LocalStoreDatabase {
  _LocalStoreDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}

class LocalDatabase {
  static const int schemaVersionValue = 1;
  static const String defaultDirectoryName = 'drift';
  static const String defaultFileName = 'store_management.sqlite';
  static const String branchModelType = 'branch';
  static const String storeBranchesModelType = 'store_branches';
  static const Set<String> managedModelTypes = <String>{
    'store',
    'branch',
    'products',
    'category',
    'tags',
    'client',
    'supplier',
    'users',
    'roles',
    'user_roles',
    'pages',
    'permissions',
    'role_permissions',
    'user_permissions',
    'store_supplier',
    'store_client',
    'store_user',
    'store_branches',
    'branch_product',
    'store_invoice_item',
    'payment_allocation',
    'store_return_item',
    'store_invoice',
    'store_return',
    'store_payment_voucher',
    'inventory_movement',
    'store_financial_transaction',
    'purchase_order',
    'purchase_order_item',
    'supplier_invoice',
    'inventory_batch',
    'inventory_transaction',
    'transfer_order',
    'transfer_order_item',
    'sales_order',
    'sales_invoice',
    'sales_return',
    'branch_price',
    'promotion_rule',
    'staff_shift',
    'staff_attendance',
    'staff_activity_log',
  };
  static const String _recordUuidColumn = '__record_uuid';

  LocalDatabase._(this._database, this._databaseFile);

  static LocalDatabase? _current;

  static LocalDatabase? get current => _current;

  final _LocalStoreDatabase _database;
  final File _databaseFile;
  final Map<String, OfflineSyncRecord> _recordsByCacheKey = <String, OfflineSyncRecord>{};
  final Map<String, Map<String, Map<String, dynamic>>> _rowsByTable = <String, Map<String, Map<String, dynamic>>>{};
  final Map<String, Set<String>> _tableColumns = <String, Set<String>>{};
  final Map<String, Map<String, String>> _tableColumnTypes = <String, Map<String, String>>{};
  int _nextId = 1;
  bool _isClosed = false;

  static Future<LocalDatabase> create({String? databasePath}) async {
    final databaseFile = await resolveDatabaseFile(databasePath: databasePath);
    final existing = _current;
    if (existing != null && !existing._isClosed) {
      if (existing.databasePath == databaseFile.path) {
        return existing;
      }
      await existing.close();
    }

    final database = _LocalStoreDatabase(NativeDatabase.createInBackground(databaseFile));
    final localDatabase = LocalDatabase._(database, databaseFile);
    await localDatabase._initializeBusinessTables();
    await localDatabase._hydrateRowCache();
    await localDatabase._hydrateCache();
    _current = localDatabase;
    return localDatabase;
  }

  static Future<String> defaultDatabaseDirectoryPath() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    return p.join(appDirectory.path, defaultDirectoryName);
  }

  static Future<String> defaultDatabasePath() async {
    return p.join(await defaultDatabaseDirectoryPath(), defaultFileName);
  }

  static Future<File> resolveDatabaseFile({String? databasePath}) async {
    final normalizedPath = (databasePath == null || databasePath.trim().isEmpty) ? await defaultDatabasePath() : databasePath.trim();
    final databaseFile = File(normalizedPath);
    final databaseDirectory = databaseFile.parent;
    if (!await databaseDirectory.exists()) {
      await databaseDirectory.create(recursive: true);
    }
    return databaseFile;
  }

  bool get isAvailable => !_isClosed;
  int get schemaVersion => schemaVersionValue;
  String get databasePath => _databaseFile.path;
  String get databaseFileName => p.basename(_databaseFile.path);

  OfflineSyncRecord putRecord({
    required String modelType,
    required String recordUuid,
    required String payloadJson,
    required int updatedAtMillis,
    int? remoteUpdatedAtMillis,
    int? conflictDetectedAtMillis,
    int syncState = OfflineSyncState.pendingUpsert,
    bool isDeleted = false,
  }) {
    final cacheKey = _cacheKey(modelType, recordUuid);
    final existingRecord = _recordsByCacheKey[cacheKey];
    final record = OfflineSyncRecord(
      id: existingRecord?.id ?? _nextId++,
      cacheKey: cacheKey,
      modelType: modelType,
      recordUuid: recordUuid,
      payloadJson: payloadJson,
      updatedAtMillis: updatedAtMillis,
      remoteUpdatedAtMillis: remoteUpdatedAtMillis,
      conflictDetectedAtMillis: conflictDetectedAtMillis,
      syncState: syncState,
      isDeleted: isDeleted,
    );

    _recordsByCacheKey[cacheKey] = record;
    _cacheBusinessRow(modelType: modelType, recordUuid: recordUuid, payloadJson: payloadJson);
    unawaited(_upsertRecord(record));
    return _cloneRecord(record);
  }

  OfflineSyncRecord putBranch(Branch branch, {int syncState = OfflineSyncState.pendingUpsert, bool isDeleted = false, int? remoteUpdatedAtMillis}) {
    return putRecord(
      modelType: branchModelType,
      recordUuid: branch.uuid,
      payloadJson: branch.toJson(),
      updatedAtMillis: branch.updatedAt.millisecondsSinceEpoch,
      remoteUpdatedAtMillis: remoteUpdatedAtMillis,
      syncState: syncState,
      isDeleted: isDeleted,
    );
  }

  OfflineSyncRecord putStoreBranches(StoreBranches storeBranches, {int syncState = OfflineSyncState.pendingUpsert, bool isDeleted = false, int? remoteUpdatedAtMillis}) {
    return putRecord(
      modelType: storeBranchesModelType,
      recordUuid: storeBranches.uuid,
      payloadJson: storeBranches.toJson(),
      updatedAtMillis: storeBranches.updatedAt.millisecondsSinceEpoch,
      remoteUpdatedAtMillis: remoteUpdatedAtMillis,
      syncState: syncState,
      isDeleted: isDeleted,
    );
  }

  OfflineSyncRecord? getRecord({required String modelType, required String recordUuid}) {
    final record = _recordsByCacheKey[_cacheKey(modelType, recordUuid)];
    if (record == null) {
      return null;
    }
    return _cloneRecord(record);
  }

  List<OfflineSyncRecord> getRecordsForType(String modelType) {
    return _recordsByCacheKey.values
        .where((record) => record.modelType == modelType)
        .map(_cloneRecord)
        .toList(growable: false);
  }

  List<OfflineSyncRecord> getConflictedRecords() {
    return _recordsByCacheKey.values
        .where((record) => record.conflictDetectedAtMillis != null)
        .map(_cloneRecord)
        .toList(growable: false);
  }

  Map<String, dynamic>? getRow({required String modelType, required String recordUuid}) {
    final tableRows = _rowsByTable[modelType];
    if (tableRows == null) {
      return null;
    }
    final row = tableRows[recordUuid];
    if (row == null) {
      return null;
    }
    return _clonePayload(row);
  }

  List<Map<String, dynamic>> getRowsForType(String modelType) {
    final tableRows = _rowsByTable[modelType];
    if (tableRows == null) {
      return const <Map<String, dynamic>>[];
    }
    return tableRows.values.map(_clonePayload).toList(growable: false);
  }

  bool removeRecord({required String modelType, required String recordUuid}) {
    final cacheKey = _cacheKey(modelType, recordUuid);
    final removed = _recordsByCacheKey.remove(cacheKey);
    if (removed == null) {
      return false;
    }

    _rowsByTable[modelType]?.remove(recordUuid);
    unawaited((_database.delete(_database.syncRecords)..where((tbl) => tbl.cacheKey.equals(cacheKey))).go());
    unawaited(_deleteBusinessRow(modelType: modelType, recordUuid: recordUuid));
    return true;
  }

  Branch? getBranch(String branchUuid) {
    final row = getRow(modelType: branchModelType, recordUuid: branchUuid);
    if (row == null) {
      return null;
    }

    return Branch.fromMap(row);
  }

  List<Branch> getBranches() {
    return getRowsForType(branchModelType).where((row) => row['deletedAt'] == null && row['deleted_at'] == null).map(Branch.fromMap).toList(growable: false);
  }

  bool removeBranch(String branchUuid) {
    return removeRecord(modelType: branchModelType, recordUuid: branchUuid);
  }

  StoreBranches? getStoreBranches(String storeBranchesUuid) {
    final row = getRow(modelType: storeBranchesModelType, recordUuid: storeBranchesUuid);
    if (row == null) {
      return null;
    }

    return StoreBranches.fromMap(row);
  }

  List<StoreBranches> getStoreBranchesList() {
    return getRowsForType(storeBranchesModelType).where((row) => row['deletedAt'] == null && row['deleted_at'] == null).map(StoreBranches.fromMap).toList(growable: false);
  }

  bool removeStoreBranches(String storeBranchesUuid) {
    return removeRecord(modelType: storeBranchesModelType, recordUuid: storeBranchesUuid);
  }

  int clearAllRecords() {
    final count = _recordsByCacheKey.length;
    _recordsByCacheKey.clear();
    for (final tableRows in _rowsByTable.values) {
      tableRows.clear();
    }
    unawaited(_database.delete(_database.syncRecords).go());
    for (final modelType in managedModelTypes) {
      unawaited(_database.customStatement('DELETE FROM ${_quotedIdentifier(modelType)}'));
    }
    return count;
  }

  int reconcileSyncMetadata() {
    var updatedCount = 0;
    final records = _recordsByCacheKey.values.toList(growable: false);

    for (final record in records) {
      Map<String, dynamic> payload;
      try {
        payload = Map<String, dynamic>.from(jsonDecode(record.payloadJson) as Map);
      } catch (_) {
        continue;
      }

      final normalizedPayload = normalizeSyncPayload(payload, syncState: record.syncState, fallbackUpdatedAtMillis: record.updatedAtMillis);
      final normalizedPayloadJson = jsonEncode(normalizedPayload);
      final normalizedUpdatedAtMillis = parseUpdatedAtMillisOrNull(normalizedPayload) ?? record.updatedAtMillis;

      if (record.payloadJson == normalizedPayloadJson && record.updatedAtMillis == normalizedUpdatedAtMillis) {
        continue;
      }

      record.payloadJson = normalizedPayloadJson;
      record.updatedAtMillis = normalizedUpdatedAtMillis;
      _recordsByCacheKey[record.cacheKey] = record;
      unawaited(_upsertRecord(record));
      updatedCount += 1;
    }

    return updatedCount;
  }

  bool ping() {
    return !_isClosed && _databaseFile.existsSync();
  }

  Future<int> fileSizeBytes() async {
    if (!await _databaseFile.exists()) {
      return 0;
    }
    return _databaseFile.length();
  }

  Future<DateTime?> lastModified() async {
    if (!await _databaseFile.exists()) {
      return null;
    }
    return _databaseFile.lastModified();
  }

  Future<void> close() async {
    if (_isClosed) {
      return;
    }

    _isClosed = true;
    await _database.close();
    if (identical(_current, this)) {
      _current = null;
    }
  }

  Future<void> _hydrateCache() async {
    final rows = await _database.select(_database.syncRecords).get();
    _recordsByCacheKey
      ..clear()
      ..addEntries(rows.map((row) {
        final record = OfflineSyncRecord(
          id: row.id,
          cacheKey: row.cacheKey,
          modelType: row.modelType,
          recordUuid: row.recordUuid,
          payloadJson: row.payloadJson,
          updatedAtMillis: row.updatedAtMillis,
          remoteUpdatedAtMillis: row.remoteUpdatedAtMillis,
          conflictDetectedAtMillis: row.conflictDetectedAtMillis,
          syncState: row.syncState,
          isDeleted: row.isDeleted,
        );
        return MapEntry(record.cacheKey, record);
      }));

    if (_recordsByCacheKey.isEmpty) {
      _nextId = 1;
      return;
    }

    _nextId = _recordsByCacheKey.values.map((record) => record.id).reduce((left, right) => left > right ? left : right) + 1;
  }

  Future<void> _initializeBusinessTables() async {
    for (final modelType in managedModelTypes) {
      await _ensureBusinessTable(modelType);
    }
  }

  Future<void> _hydrateRowCache() async {
    for (final modelType in managedModelTypes) {
      await _ensureBusinessTable(modelType);
      final rows = await _database.customSelect('SELECT * FROM ${_quotedIdentifier(modelType)}').get();
      final columnTypes = _tableColumnTypes[modelType] ?? const <String, String>{};
      final tableRows = <String, Map<String, dynamic>>{};

      for (final row in rows) {
        final data = Map<String, dynamic>.from(row.data);
        final recordUuid = data.remove(_recordUuidColumn)?.toString();
        if (recordUuid == null || recordUuid.isEmpty) {
          continue;
        }

        final payload = <String, dynamic>{};
        data.forEach((key, value) {
          payload[key] = _restoreStoredValue(value, declaredType: columnTypes[key]);
        });
        tableRows[recordUuid] = payload;
      }

      _rowsByTable[modelType] = tableRows;
    }
  }

  Future<void> _ensureBusinessTable(String modelType) async {
    if (_tableColumns.containsKey(modelType)) {
      _rowsByTable.putIfAbsent(modelType, () => <String, Map<String, dynamic>>{});
      return;
    }

    await _database.customStatement('CREATE TABLE IF NOT EXISTS ${_quotedIdentifier(modelType)} (${_quotedIdentifier(_recordUuidColumn)} TEXT NOT NULL UNIQUE)');

    final pragmaRows = await _database.customSelect('PRAGMA table_info(${_quotedIdentifier(modelType)})').get();
    final columns = <String>{};
    final columnTypes = <String, String>{};
    for (final pragmaRow in pragmaRows) {
      final data = pragmaRow.data;
      final name = data['name']?.toString();
      if (name == null || name.isEmpty) {
        continue;
      }
      columns.add(name);
      columnTypes[name] = (data['type']?.toString() ?? 'TEXT').toUpperCase();
    }

    _tableColumns[modelType] = columns;
    _tableColumnTypes[modelType] = columnTypes;
    _rowsByTable.putIfAbsent(modelType, () => <String, Map<String, dynamic>>{});
  }

  void _cacheBusinessRow({required String modelType, required String recordUuid, required String payloadJson}) {
    try {
      final payload = Map<String, dynamic>.from(jsonDecode(payloadJson) as Map);
      _rowsByTable.putIfAbsent(modelType, () => <String, Map<String, dynamic>>{})[recordUuid] = _clonePayload(payload);
      unawaited(_upsertBusinessRow(modelType: modelType, recordUuid: recordUuid, payload: payload));
    } catch (_) {
      // Ignore malformed payloads in the sync metadata cache.
    }
  }

  Future<void> _upsertBusinessRow({required String modelType, required String recordUuid, required Map<String, dynamic> payload}) async {
    await _ensureBusinessTable(modelType);
    await _ensureBusinessColumns(modelType, payload);

    final columns = <String>[_recordUuidColumn, ...payload.keys];
    final placeholders = List<String>.filled(columns.length, '?').join(', ');
    final assignments = payload.keys.map((column) => '${_quotedIdentifier(column)} = excluded.${_quotedIdentifier(column)}').join(', ');
    final values = <Object?>[recordUuid, ...payload.keys.map((key) => _toStoredValue(payload[key]))];

    await _database.customStatement(
      'INSERT INTO ${_quotedIdentifier(modelType)} (${columns.map(_quotedIdentifier).join(', ')}) VALUES ($placeholders) '
      'ON CONFLICT(${_quotedIdentifier(_recordUuidColumn)}) DO UPDATE SET $assignments',
      values,
    );
  }

  Future<void> _ensureBusinessColumns(String modelType, Map<String, dynamic> payload) async {
    await _ensureBusinessTable(modelType);
    final existingColumns = _tableColumns[modelType]!;
    final existingTypes = _tableColumnTypes[modelType]!;

    for (final entry in payload.entries) {
      if (existingColumns.contains(entry.key)) {
        continue;
      }

      final sqliteType = _sqliteTypeForValue(entry.value);
      await _database.customStatement('ALTER TABLE ${_quotedIdentifier(modelType)} ADD COLUMN ${_quotedIdentifier(entry.key)} $sqliteType');
      existingColumns.add(entry.key);
      existingTypes[entry.key] = sqliteType;
    }
  }

  Future<void> _deleteBusinessRow({required String modelType, required String recordUuid}) async {
    await _ensureBusinessTable(modelType);
    await _database.customStatement('DELETE FROM ${_quotedIdentifier(modelType)} WHERE ${_quotedIdentifier(_recordUuidColumn)} = ?', <Object?>[recordUuid]);
  }

  Future<void> _upsertRecord(OfflineSyncRecord record) {
    return _database.into(_database.syncRecords).insertOnConflictUpdate(
      SyncRecordsCompanion.insert(
        id: Value(record.id),
        cacheKey: record.cacheKey,
        modelType: record.modelType,
        recordUuid: record.recordUuid,
        payloadJson: record.payloadJson,
        updatedAtMillis: record.updatedAtMillis,
        remoteUpdatedAtMillis: Value(record.remoteUpdatedAtMillis),
        conflictDetectedAtMillis: Value(record.conflictDetectedAtMillis),
        syncState: record.syncState,
        isDeleted: Value(record.isDeleted),
      ),
    );
  }

  OfflineSyncRecord _cloneRecord(OfflineSyncRecord record) {
    return OfflineSyncRecord(
      id: record.id,
      cacheKey: record.cacheKey,
      modelType: record.modelType,
      recordUuid: record.recordUuid,
      payloadJson: record.payloadJson,
      updatedAtMillis: record.updatedAtMillis,
      remoteUpdatedAtMillis: record.remoteUpdatedAtMillis,
      conflictDetectedAtMillis: record.conflictDetectedAtMillis,
      syncState: record.syncState,
      isDeleted: record.isDeleted,
    );
  }

  Map<String, dynamic> _clonePayload(Map<String, dynamic> payload) {
    return Map<String, dynamic>.from(jsonDecode(jsonEncode(payload)) as Map);
  }

  Object? _toStoredValue(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value ? 1 : 0;
    }
    if (value is int || value is double || value is num || value is String) {
      return value;
    }
    if (value is Map || value is List) {
      return jsonEncode(value);
    }
    return value.toString();
  }

  Object? _restoreStoredValue(Object? value, {String? declaredType}) {
    if (value == null) {
      return null;
    }

    final normalizedType = (declaredType ?? 'TEXT').toUpperCase();
    if (normalizedType.contains('BOOL')) {
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
    }

    if (normalizedType.contains('JSON') && value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
        if (decoded is List) {
          return List<dynamic>.from(decoded);
        }
      } catch (_) {
        return value;
      }
    }

    return value;
  }

  String _sqliteTypeForValue(Object? value) {
    if (value is bool) {
      return 'BOOLEAN_INT';
    }
    if (value is int) {
      return 'INTEGER';
    }
    if (value is double || value is num) {
      return 'REAL';
    }
    if (value is Map || value is List) {
      return 'JSON_TEXT';
    }
    return 'TEXT';
  }

  String _quotedIdentifier(String identifier) {
    return '"${identifier.replaceAll('"', '""')}"';
  }

  String _cacheKey(String modelType, String recordUuid) => '$modelType:$recordUuid';
}