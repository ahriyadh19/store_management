import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/models/store_branches.dart';
import 'package:store_management/services/local_database_stub.dart';

void main() {
  final createdAt = DateTime.fromMillisecondsSinceEpoch(1713744000000);
  final updatedAt = DateTime.fromMillisecondsSinceEpoch(1713830400000);

  test(
    'stub local database stores Branch payloads using branch model type',
    () async {
      final database = await LocalDatabase.create();
      final branch = Branch(
        id: 1,
        uuid: 'branch-uuid',
        name: 'City Branch',
        description: 'Handles downtown customers',
        address: '1 Market Street',
        phone: '+256700100200',
        email: 'branch@example.com',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final record = database.putBranch(
        branch,
        syncState: OfflineSyncState.pendingUpsert,
      );

      expect(record.modelType, LocalDatabase.branchModelType);
      expect(record.recordUuid, branch.uuid);
      expect(record.payloadJson, branch.toJson());
      expect(record.updatedAtMillis, updatedAt.millisecondsSinceEpoch);
    },
  );

  test(
    'stub local database stores StoreBranches payloads using store_branches model type',
    () async {
      final database = await LocalDatabase.create();
      final storeBranch = StoreBranches(
        id: 1,
        uuid: 'store-branch-uuid',
        storeUuid: '11111111-1111-4111-8111-111111111111',
        branchUuid: '22222222-2222-4222-8222-222222222222',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final record = database.putStoreBranches(storeBranch, isDeleted: true);

      expect(record.modelType, LocalDatabase.storeBranchesModelType);
      expect(record.recordUuid, storeBranch.uuid);
      expect(record.payloadJson, storeBranch.toJson());
      expect(record.isDeleted, isTrue);
    },
  );
}
