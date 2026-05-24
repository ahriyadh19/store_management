import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/services/branch_store_uuid_backfill_service.dart';

void main() {
  test('plans updates only for active branches missing storeUuid with active store links', () {
    final updates = planBranchStoreUuidBackfillForTesting(
      branchRows: const <Map<String, dynamic>>[
        <String, dynamic>{'uuid': 'branch-1', 'storeUuid': null, 'deletedAt': null},
        <String, dynamic>{'uuid': 'branch-2', 'storeUuid': 'store-2', 'deletedAt': null},
        <String, dynamic>{'uuid': 'branch-3', 'storeUuid': null, 'deletedAt': 1},
      ],
      storeBranchRows: const <Map<String, dynamic>>[
        <String, dynamic>{'branchUuid': 'branch-1', 'storeUuid': 'store-1', 'deletedAt': null},
        <String, dynamic>{'branchUuid': 'branch-1', 'storeUuid': 'store-duplicate', 'deletedAt': null},
        <String, dynamic>{'branchUuid': 'branch-2', 'storeUuid': 'store-should-skip', 'deletedAt': null},
        <String, dynamic>{'branchUuid': 'branch-3', 'storeUuid': 'store-deleted-branch', 'deletedAt': null},
        <String, dynamic>{'branchUuid': 'branch-4', 'storeUuid': 'store-unknown-branch', 'deletedAt': null},
        <String, dynamic>{'branchUuid': 'branch-1', 'storeUuid': 'store-deleted-link', 'deletedAt': 1},
      ],
    );

    expect(updates, hasLength(1));
    expect(updates.single.branchUuid, 'branch-1');
    expect(updates.single.storeUuid, 'store-1');
  });
}