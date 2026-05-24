import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/services/local_database.dart';

class BranchStoreUuidBackfillUpdate {
  const BranchStoreUuidBackfillUpdate({required this.branchUuid, required this.storeUuid});

  final String branchUuid;
  final String storeUuid;
}

class BranchStoreUuidBackfillService {
  BranchStoreUuidBackfillService._();

  static final BranchStoreUuidBackfillService instance = BranchStoreUuidBackfillService._();
  static const String _prefsKeyPrefix = 'dataRepair.branchStoreUuidBackfill.completed';

  Future<void> runForCurrentSessionBestEffort() async {
    SupabaseClient client;
    try {
      client = Supabase.instance.client;
    } catch (_) {
      return;
    }

    final authUser = client.auth.currentUser;
    if (authUser == null) {
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    final completedKey = '$_prefsKeyPrefix.${authUser.id}';
    if (preferences.getBool(completedKey) == true) {
      return;
    }

    try {
      final branchRows = await client.from('branch').select('uuid,storeUuid,deletedAt').isFilter('storeUuid', null).isFilter('deletedAt', null);
      final branchMaps = (branchRows as List<dynamic>).map((row) => Map<String, dynamic>.from(row as Map)).toList(growable: false);
      if (branchMaps.isEmpty) {
        await preferences.setBool(completedKey, true);
        return;
      }

      final branchUuids = branchMaps.map((row) => row['uuid']?.toString().trim() ?? '').where((uuid) => uuid.isNotEmpty).toList(growable: false);
      if (branchUuids.isEmpty) {
        await preferences.setBool(completedKey, true);
        return;
      }

      final storeBranchRows = await client
          .from('store_branches')
          .select('branchUuid,storeUuid,deletedAt')
          .inFilter('branchUuid', branchUuids)
          .isFilter('deletedAt', null);
      final storeBranchMaps = (storeBranchRows as List<dynamic>).map((row) => Map<String, dynamic>.from(row as Map)).toList(growable: false);

      final updates = planBranchStoreUuidBackfillForTesting(branchRows: branchMaps, storeBranchRows: storeBranchMaps);
      if (updates.isEmpty) {
        await preferences.setBool(completedKey, true);
        return;
      }

      var appliedAllUpdates = true;
      for (final update in updates) {
        final updatedAt = DateTime.now().millisecondsSinceEpoch;
        final updatedRow = await client
            .from('branch')
            .update(<String, dynamic>{'storeUuid': update.storeUuid, 'updatedAt': updatedAt})
            .eq('uuid', update.branchUuid)
            .select()
            .maybeSingle();
        if (updatedRow == null) {
          appliedAllUpdates = false;
          continue;
        }

        _updateLocalBranchCache(Map<String, dynamic>.from(updatedRow as Map));
      }

      if (appliedAllUpdates) {
        await preferences.setBool(completedKey, true);
      }
    } catch (error) {
      debugPrint('Branch storeUuid backfill skipped: $error');
    }
  }

  void _updateLocalBranchCache(Map<String, dynamic> row) {
    final database = LocalDatabase.current;
    if (database == null || !database.isAvailable) {
      return;
    }

    final branch = Branch.fromMap(row);
    final existingRecord = database.getRecord(modelType: LocalDatabase.branchModelType, recordUuid: branch.uuid);
    if (existingRecord != null && existingRecord.syncState != OfflineSyncState.synced) {
      return;
    }

    database.putBranch(
      branch,
      syncState: OfflineSyncState.synced,
      remoteUpdatedAtMillis: branch.updatedAt.millisecondsSinceEpoch,
    );
  }
}

List<BranchStoreUuidBackfillUpdate> planBranchStoreUuidBackfillForTesting({required List<Map<String, dynamic>> branchRows, required List<Map<String, dynamic>> storeBranchRows}) {
  final missingBranchUuids = branchRows
      .where((row) {
        final deletedAt = row['deletedAt'] ?? row['deleted_at'];
        final storeUuid = row['storeUuid'] ?? row['store_uuid'];
        return deletedAt == null && (storeUuid == null || storeUuid.toString().trim().isEmpty);
      })
      .map((row) => row['uuid']?.toString().trim() ?? '')
      .where((uuid) => uuid.isNotEmpty)
      .toSet();

  final updates = <BranchStoreUuidBackfillUpdate>[];
  final seenBranchUuids = <String>{};
  for (final row in storeBranchRows) {
    final deletedAt = row['deletedAt'] ?? row['deleted_at'];
    if (deletedAt != null) {
      continue;
    }

    final branchUuid = (row['branchUuid'] ?? row['branch_uuid'])?.toString().trim() ?? '';
    final storeUuid = (row['storeUuid'] ?? row['store_uuid'])?.toString().trim() ?? '';
    if (branchUuid.isEmpty || storeUuid.isEmpty || !missingBranchUuids.contains(branchUuid) || !seenBranchUuids.add(branchUuid)) {
      continue;
    }

    updates.add(BranchStoreUuidBackfillUpdate(branchUuid: branchUuid, storeUuid: storeUuid));
  }

  return updates;
}