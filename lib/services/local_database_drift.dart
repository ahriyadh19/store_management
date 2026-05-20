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
  static const String branchModelType = 'branch';
  static const String storeBranchesModelType = 'store_branches';

  LocalDatabase._(this._database, this._databaseFile);

  static LocalDatabase? _current;

  static LocalDatabase? get current => _current;

  final _LocalStoreDatabase _database;
  final File _databaseFile;
  final Map<String, OfflineSyncRecord> _recordsByCacheKey = <String, OfflineSyncRecord>{};
  int _nextId = 1;
  bool _isClosed = false;

  static Future<LocalDatabase> create() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final databaseDirectory = Directory(p.join(appDirectory.path, 'drift'));
    if (!await databaseDirectory.exists()) {
      await databaseDirectory.create(recursive: true);
    }

    final databaseFile = File(p.join(databaseDirectory.path, 'store_management.sqlite'));
    final database = _LocalStoreDatabase(NativeDatabase.createInBackground(databaseFile));
    final localDatabase = LocalDatabase._(database, databaseFile);
    await localDatabase._hydrateCache();
    _current = localDatabase;
    return localDatabase;
  }

  bool get isAvailable => !_isClosed;

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

  bool removeRecord({required String modelType, required String recordUuid}) {
    final cacheKey = _cacheKey(modelType, recordUuid);
    final removed = _recordsByCacheKey.remove(cacheKey);
    if (removed == null) {
      return false;
    }

    unawaited((_database.delete(_database.syncRecords)..where((tbl) => tbl.cacheKey.equals(cacheKey))).go());
    return true;
  }

  Branch? getBranch(String branchUuid) {
    final record = getRecord(modelType: branchModelType, recordUuid: branchUuid);
    if (record == null || record.isDeleted) {
      return null;
    }

    return Branch.fromJson(record.payloadJson);
  }

  List<Branch> getBranches() {
    return getRecordsForType(branchModelType).where((record) => !record.isDeleted).map((record) => Branch.fromJson(record.payloadJson)).toList(growable: false);
  }

  bool removeBranch(String branchUuid) {
    return removeRecord(modelType: branchModelType, recordUuid: branchUuid);
  }

  StoreBranches? getStoreBranches(String storeBranchesUuid) {
    final record = getRecord(modelType: storeBranchesModelType, recordUuid: storeBranchesUuid);
    if (record == null || record.isDeleted) {
      return null;
    }

    return StoreBranches.fromJson(record.payloadJson);
  }

  List<StoreBranches> getStoreBranchesList() {
    return getRecordsForType(storeBranchesModelType).where((record) => !record.isDeleted).map((record) => StoreBranches.fromJson(record.payloadJson)).toList(growable: false);
  }

  bool removeStoreBranches(String storeBranchesUuid) {
    return removeRecord(modelType: storeBranchesModelType, recordUuid: storeBranchesUuid);
  }

  int clearAllRecords() {
    final count = _recordsByCacheKey.length;
    _recordsByCacheKey.clear();
    unawaited(_database.delete(_database.syncRecords).go());
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

  String _cacheKey(String modelType, String recordUuid) => '$modelType:$recordUuid';
}