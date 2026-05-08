import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/services/sync_payload_normalizer.dart';

void main() {
  test('normalizer marks synced payload and backfills syncedAt', () {
    final payload = <String, dynamic>{
      'uuid': 'record-1',
      'updatedAt': 1700,
      'synced': false,
      'syncedAt': null,
    };

    final normalized = normalizeSyncPayload(
      payload,
      syncState: OfflineSyncState.synced,
      fallbackUpdatedAtMillis: 1000,
      nowMillis: 900,
    );

    expect(normalized['synced'], isTrue);
    expect(normalized['syncedAt'], 1700);
    expect(normalized['synced_at'], 1700);
    expect(normalized['updatedAt'], 1700);
  });

  test('normalizer keeps pending upsert unsynced and clears syncedAt', () {
    final payload = <String, dynamic>{
      'uuid': 'record-1',
      'updatedAt': 1700,
      'synced': true,
      'syncedAt': 1690,
      'synced_at': 1690,
    };

    final normalized = normalizeSyncPayload(
      payload,
      syncState: OfflineSyncState.pendingUpsert,
      fallbackUpdatedAtMillis: 1000,
      nowMillis: 900,
    );

    expect(normalized['synced'], isFalse);
    expect(normalized['syncedAt'], isNull);
    expect(normalized['synced_at'], isNull);
    expect(normalized['updatedAt'], 1700);
  });

  test('normalizer keeps pending delete unsynced and stable updatedAt', () {
    final payload = <String, dynamic>{
      'uuid': 'record-1',
      'updatedAt': 2000,
      'deletedAt': 2000,
      'synced': true,
      'syncedAt': 2000,
    };

    final normalized = normalizeSyncPayload(
      payload,
      syncState: OfflineSyncState.pendingDelete,
      fallbackUpdatedAtMillis: 1000,
      nowMillis: 900,
    );

    expect(normalized['synced'], isFalse);
    expect(normalized['syncedAt'], isNull);
    expect(normalized['updatedAt'], 2000);
    expect(normalized['deletedAt'], 2000);
  });

  test('normalizer falls back updatedAt from fallback millis', () {
    final payload = <String, dynamic>{'uuid': 'record-1'};

    final normalized = normalizeSyncPayload(
      payload,
      syncState: OfflineSyncState.synced,
      fallbackUpdatedAtMillis: 4567,
      nowMillis: 900,
    );

    expect(normalized['updatedAt'], 4567);
    expect(normalized['updated_at'], 4567);
    expect(normalized['syncedAt'], 4567);
  });

  test('parseUpdatedAtMillisOrNull supports ISO and integer strings', () {
    final fromIntString = parseUpdatedAtMillisOrNull(<String, dynamic>{'updatedAt': '12345'});
    final fromIsoString = parseUpdatedAtMillisOrNull(<String, dynamic>{'updated_at': '2026-05-08T12:34:56Z'});

    expect(fromIntString, 12345);
    expect(fromIsoString, DateTime.parse('2026-05-08T12:34:56Z').toUtc().millisecondsSinceEpoch);
  });
}
