import 'package:store_management/models/offline_sync_record.dart';

bool shouldUsePendingLocalRecordInHybridMerge({
  required OfflineSyncRecord localRecord,
  required int? remoteUpdatedAtMillis,
}) {
  if (localRecord.syncState == OfflineSyncState.pendingDelete || localRecord.isDeleted) {
    return true;
  }

  if (localRecord.syncState != OfflineSyncState.pendingUpsert) {
    return true;
  }

  if (remoteUpdatedAtMillis == null) {
    return true;
  }

  final localBaselineRemoteUpdatedAt = localRecord.remoteUpdatedAtMillis;
  if (localBaselineRemoteUpdatedAt == null) {
    return true;
  }

  if (remoteUpdatedAtMillis <= localBaselineRemoteUpdatedAt) {
    return true;
  }

  if (localRecord.updatedAtMillis >= remoteUpdatedAtMillis) {
    return true;
  }

  return false;
}
