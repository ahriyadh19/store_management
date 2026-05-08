import 'package:objectbox/objectbox.dart' as obx;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/models/store_branches.dart';
import 'package:store_management/objectbox.g.dart';

class LocalDatabase {
  static const String branchModelType = 'branch';
  static const String storeBranchesModelType = 'store_branches';

  LocalDatabase._(this.store) : offlineSyncRecords = obx.Box<OfflineSyncRecord>(store);

  static LocalDatabase? _current;

  static LocalDatabase? get current => _current;

  final obx.Store store;
  final obx.Box<OfflineSyncRecord> offlineSyncRecords;

  static Future<LocalDatabase> create() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(appDirectory.path, 'objectbox'));
    final database = LocalDatabase._(store);
    _current = database;
    return database;
  }

  bool get isAvailable => true;

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
    final record = OfflineSyncRecord(
      cacheKey: _cacheKey(modelType, recordUuid),
      modelType: modelType,
      recordUuid: recordUuid,
      payloadJson: payloadJson,
      updatedAtMillis: updatedAtMillis,
      remoteUpdatedAtMillis: remoteUpdatedAtMillis,
      conflictDetectedAtMillis: conflictDetectedAtMillis,
      syncState: syncState,
      isDeleted: isDeleted,
    );

    final id = offlineSyncRecords.put(record);
    return offlineSyncRecords.get(id)!;
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
    final query = offlineSyncRecords.query(OfflineSyncRecord_.cacheKey.equals(_cacheKey(modelType, recordUuid))).build();
    try {
      return query.findFirst();
    } finally {
      query.close();
    }
  }

  List<OfflineSyncRecord> getRecordsForType(String modelType) {
    final query = offlineSyncRecords.query(OfflineSyncRecord_.modelType.equals(modelType)).build();
    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  List<OfflineSyncRecord> getConflictedRecords() {
    final query = offlineSyncRecords.query(OfflineSyncRecord_.conflictDetectedAtMillis.notNull()).build();
    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  bool removeRecord({required String modelType, required String recordUuid}) {
    final existing = getRecord(modelType: modelType, recordUuid: recordUuid);
    if (existing == null) {
      return false;
    }

    return offlineSyncRecords.remove(existing.id);
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
    return offlineSyncRecords.removeAll();
  }

  bool ping() {
    final query = offlineSyncRecords.query().build();
    try {
      query.findFirst();
      return true;
    } finally {
      query.close();
    }
  }

  Future<void> close() async {
    store.close();
  }

  String _cacheKey(String modelType, String recordUuid) => '$modelType:$recordUuid';
}
