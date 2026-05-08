import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/services/owner_scope_service.dart';

void main() {
  test('extractBranchUuidsFromStoreBranchRowsForTesting collects distinct branch UUIDs', () {
    final branchUuids = extractBranchUuidsFromStoreBranchRowsForTesting(<dynamic>[
      <String, dynamic>{'branchUuid': 'branch-a', 'status': 1, 'deletedAt': null},
      <String, dynamic>{'branchUuid': 'branch-b', 'status': 1, 'deletedAt': null},
      <String, dynamic>{'branchUuid': 'branch-a', 'status': 1, 'deletedAt': null},
      <String, dynamic>{'branchUuid': '', 'status': 1, 'deletedAt': null},
      <String, dynamic>{'status': 1, 'deletedAt': null},
    ]);

    expect(branchUuids, <String>{'branch-a', 'branch-b'});
  });

  test('extractBranchUuidsFromStoreBranchRowsForTesting ignores rows without branch UUIDs', () {
    final branchUuids = extractBranchUuidsFromStoreBranchRowsForTesting(<dynamic>[
      <String, dynamic>{'branchUuid': null},
      <String, dynamic>{'deletedAt': null},
    ]);

    expect(branchUuids, isEmpty);
  });
}