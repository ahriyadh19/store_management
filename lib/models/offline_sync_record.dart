import 'package:objectbox/objectbox.dart';

class OfflineSyncState {
  static const int synced = 0;
  static const int pendingUpsert = 1;
  static const int pendingDelete = 2;

  static bool isValid(int value) {
    return value == synced || value == pendingUpsert || value == pendingDelete;
  }
}

@Entity()
class OfflineSyncRecord {
  OfflineSyncRecord({
    this.id = 0,
    required this.cacheKey,
    required this.modelType,
    required this.recordUuid,
    required this.payloadJson,
    required this.updatedAtMillis,
    this.remoteUpdatedAtMillis,
    this.conflictDetectedAtMillis,
    this.syncState = OfflineSyncState.pendingUpsert,
    this.isDeleted = false,
  });

  @Id()
  int id;

  @Unique(onConflict: ConflictStrategy.replace)
  String cacheKey;

  String modelType;
  String recordUuid;
  String payloadJson;
  int updatedAtMillis;
  int? remoteUpdatedAtMillis;
  int? conflictDetectedAtMillis;
  int syncState;
  bool isDeleted;
}
