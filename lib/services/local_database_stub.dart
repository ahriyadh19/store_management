import 'package:store_management/models/branch.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/models/store_branches.dart';

class LocalDatabase {
  static const String branchModelType = 'branch';
  static const String storeBranchesModelType = 'store_branches';

  LocalDatabase._();

  static Future<LocalDatabase> create() async {
    return LocalDatabase._();
  }

  bool get isAvailable => false;

  OfflineSyncRecord putRecord({
    required String modelType,
    required String recordUuid,
    required String payloadJson,
    required int updatedAtMillis,
    int? remoteUpdatedAtMillis,
    int syncState = OfflineSyncState.pendingUpsert,
    bool isDeleted = false,
  }) {
    return OfflineSyncRecord(
      cacheKey: '$modelType:$recordUuid',
      modelType: modelType,
      recordUuid: recordUuid,
      payloadJson: payloadJson,
      updatedAtMillis: updatedAtMillis,
      remoteUpdatedAtMillis: remoteUpdatedAtMillis,
      syncState: syncState,
      isDeleted: isDeleted,
    );
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

  OfflineSyncRecord? getRecord({required String modelType, required String recordUuid}) => null;

  List<OfflineSyncRecord> getRecordsForType(String modelType) => const [];

  bool removeRecord({required String modelType, required String recordUuid}) => false;

  Branch? getBranch(String branchUuid) => null;

  List<Branch> getBranches() => const [];

  bool removeBranch(String branchUuid) => false;

  StoreBranches? getStoreBranches(String storeBranchesUuid) => null;

  List<StoreBranches> getStoreBranchesList() => const [];

  bool removeStoreBranches(String storeBranchesUuid) => false;

  bool ping() => false;

  Future<void> close() async {}
}
