import 'package:objectbox/objectbox.dart' as obx;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/objectbox.g.dart';

class LocalDatabase {
  LocalDatabase._(this.store) : offlineSyncRecords = obx.Box<OfflineSyncRecord>(store);

  final obx.Store store;
  final obx.Box<OfflineSyncRecord> offlineSyncRecords;

  static Future<LocalDatabase> create() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(appDirectory.path, 'objectbox'));
    return LocalDatabase._(store);
  }

  bool get isAvailable => true;

  OfflineSyncRecord putRecord({
    required String modelType,
    required String recordUuid,
    required String payloadJson,
    required int updatedAtMillis,
    int? remoteUpdatedAtMillis,
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
      syncState: syncState,
      isDeleted: isDeleted,
    );

    final id = offlineSyncRecords.put(record);
    return offlineSyncRecords.get(id)!;
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

  bool removeRecord({required String modelType, required String recordUuid}) {
    final existing = getRecord(modelType: modelType, recordUuid: recordUuid);
    if (existing == null) {
      return false;
    }

    return offlineSyncRecords.remove(existing.id);
  }

  int clearAllRecords() {
    return offlineSyncRecords.removeAll();
  }

  Future<void> close() async {
    store.close();
  }

  String _cacheKey(String modelType, String recordUuid) => '$modelType:$recordUuid';
}