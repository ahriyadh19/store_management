import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/services/sync_conflict_resolution.dart';

void main() {
  OfflineSyncRecord buildRecord({
    required int syncState,
    required int updatedAtMillis,
    int? remoteUpdatedAtMillis,
    bool isDeleted = false,
  }) {
    return OfflineSyncRecord(
      cacheKey: 'products:record-1',
      modelType: 'products',
      recordUuid: 'record-1',
      payloadJson: '{"uuid":"record-1"}',
      updatedAtMillis: updatedAtMillis,
      remoteUpdatedAtMillis: remoteUpdatedAtMillis,
      syncState: syncState,
      isDeleted: isDeleted,
    );
  }

  test('pending delete always wins and remains applied in merge', () {
    final localRecord = buildRecord(
      syncState: OfflineSyncState.pendingDelete,
      updatedAtMillis: 1000,
      remoteUpdatedAtMillis: 900,
      isDeleted: true,
    );

    final useLocal = shouldUsePendingLocalRecordInHybridMerge(
      localRecord: localRecord,
      remoteUpdatedAtMillis: 2000,
    );

    expect(useLocal, isTrue);
  });

  test('pending upsert is preserved when remote timestamp is unknown', () {
    final localRecord = buildRecord(
      syncState: OfflineSyncState.pendingUpsert,
      updatedAtMillis: 1000,
      remoteUpdatedAtMillis: 900,
    );

    final useLocal = shouldUsePendingLocalRecordInHybridMerge(
      localRecord: localRecord,
      remoteUpdatedAtMillis: null,
    );

    expect(useLocal, isTrue);
  });

  test('pending upsert is preserved when remote is not newer than local baseline', () {
    final localRecord = buildRecord(
      syncState: OfflineSyncState.pendingUpsert,
      updatedAtMillis: 1000,
      remoteUpdatedAtMillis: 900,
    );

    final useLocal = shouldUsePendingLocalRecordInHybridMerge(
      localRecord: localRecord,
      remoteUpdatedAtMillis: 900,
    );

    expect(useLocal, isTrue);
  });

  test('pending upsert is dropped when remote becomes newer than both baseline and local edit time', () {
    final localRecord = buildRecord(
      syncState: OfflineSyncState.pendingUpsert,
      updatedAtMillis: 1100,
      remoteUpdatedAtMillis: 1000,
    );

    final useLocal = shouldUsePendingLocalRecordInHybridMerge(
      localRecord: localRecord,
      remoteUpdatedAtMillis: 1200,
    );

    expect(useLocal, isFalse);
  });

  test('pending upsert is preserved when local edit time is newer than latest remote', () {
    final localRecord = buildRecord(
      syncState: OfflineSyncState.pendingUpsert,
      updatedAtMillis: 1300,
      remoteUpdatedAtMillis: 1000,
    );

    final useLocal = shouldUsePendingLocalRecordInHybridMerge(
      localRecord: localRecord,
      remoteUpdatedAtMillis: 1200,
    );

    expect(useLocal, isTrue);
  });
}
