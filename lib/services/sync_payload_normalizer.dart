import 'package:store_management/models/offline_sync_record.dart';

Map<String, dynamic> normalizeSyncPayload(
  Map<String, dynamic> payload, {
  required int syncState,
  int? fallbackUpdatedAtMillis,
  int? nowMillis,
}) {
  final normalized = Map<String, dynamic>.from(payload);
  final resolvedNowMillis = nowMillis ?? DateTime.now().millisecondsSinceEpoch;
  final resolvedUpdatedAtMillis =
      parseUpdatedAtMillisOrNull(normalized) ?? fallbackUpdatedAtMillis ?? resolvedNowMillis;

  normalized['updatedAt'] = resolvedUpdatedAtMillis;
  normalized['updated_at'] = resolvedUpdatedAtMillis;

  final isSynced = syncState == OfflineSyncState.synced;
  normalized['synced'] = isSynced;
  if (isSynced) {
    normalized['syncedAt'] =
        normalized['syncedAt'] ?? normalized['synced_at'] ?? resolvedUpdatedAtMillis;
    normalized['synced_at'] = normalized['syncedAt'];
  } else {
    normalized['syncedAt'] = null;
    normalized['synced_at'] = null;
  }

  return normalized;
}

int? parseUpdatedAtMillisOrNull(Map<String, dynamic> payload) {
  final value = payload['updatedAt'] ?? payload['updated_at'];
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    final asInt = int.tryParse(value);
    if (asInt != null) {
      return asInt;
    }
    return DateTime.tryParse(value)?.toUtc().millisecondsSinceEpoch;
  }
  return null;
}
