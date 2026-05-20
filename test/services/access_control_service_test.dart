import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/services/access_control_service.dart';
import 'package:store_management/views/index/index_page.dart';

void main() {
  test('canonical system role maps privileged admin and owner variants', () {
    expect(canonicalSystemRoleForTesting('Administrator'), 'admin');
    expect(canonicalSystemRoleForTesting('system_admin'), 'admin');
    expect(canonicalSystemRoleForTesting('Owner Admin'), 'owner');
    expect(canonicalSystemRoleForTesting('store-owner'), 'owner');
  });

  test('role names do not grant implicit wildcard access', () {
    const snapshot = AccessControlSnapshot(
      isLoading: false,
      userUuid: 'user-1',
      ownerUuid: 'owner-1',
      membershipRoles: <String>{'staff'},
      roleNames: <String>{'admin'},
      allowPermissions: <String>{PermissionCatalog.dashboardView},
      denyPermissions: <String>{},
      lastError: null,
    );

    expect(snapshot.isOwnerAdmin, isFalse);
    expect(snapshot.can(PermissionCatalog.dashboardView), isTrue);
    expect(snapshot.can(PermissionCatalog.settingsView), isFalse);
    expect(snapshot.can(PermissionCatalog.rolesManage), isFalse);
  });

  test('explicit wildcard permission still grants full access', () {
    const snapshot = AccessControlSnapshot(
      isLoading: false,
      userUuid: 'user-1',
      ownerUuid: 'owner-1',
      membershipRoles: <String>{'viewer'},
      roleNames: <String>{'custom auditor'},
      allowPermissions: <String>{'*'},
      denyPermissions: <String>{},
      lastError: null,
    );

    expect(snapshot.isOwnerAdmin, isTrue);
    expect(snapshot.can(PermissionCatalog.settingsView), isTrue);
    expect(snapshot.can(PermissionCatalog.rolesManage), isTrue);
  });

  test('explicit deny still overrides wildcard access', () {
    const snapshot = AccessControlSnapshot(
      isLoading: false,
      userUuid: 'user-1',
      ownerUuid: 'owner-1',
      membershipRoles: <String>{'owner'},
      roleNames: <String>{'owner'},
      allowPermissions: <String>{'*'},
      denyPermissions: <String>{PermissionCatalog.rolesManage},
      lastError: null,
    );

    expect(snapshot.isOwnerAdmin, isTrue);
    expect(snapshot.can(PermissionCatalog.settingsView), isTrue);
    expect(snapshot.can(PermissionCatalog.rolesManage), isFalse);
  });

  test('inventory-owned tables inherit inventory page read access after refactor', () {
    expect(pagePermissionFromTableForTesting('purchase_order'), PermissionCatalog.pageViewPermission(IndexPage.inventory));
    expect(pagePermissionFromTableForTesting('sales_invoice'), PermissionCatalog.pageViewPermission(IndexPage.inventory));
    expect(pagePermissionFromTableForTesting('branch_price'), PermissionCatalog.pageViewPermission(IndexPage.inventory));
    expect(pagePermissionFromTableForTesting('store_invoice_item'), PermissionCatalog.pageViewPermission(IndexPage.inventory));
    expect(pagePermissionFromTableForTesting('store_client'), PermissionCatalog.pageViewPermission(IndexPage.inventory));
  });

  test('assigned roles keep owner-compatible and legacy unscoped rows', () {
    final rows = filterRoleRowsForOwnerForTesting(
      ownerUuid: 'owner-1',
      rows: <Map<String, dynamic>>[
        <String, dynamic>{'uuid': 'role-1', 'ownerUuid': 'owner-1', 'name': 'Owner'},
        <String, dynamic>{'uuid': 'role-2', 'ownerUuid': '', 'name': 'Admin'},
        <String, dynamic>{'uuid': 'role-3', 'ownerUuid': 'owner-2', 'name': 'Viewer'},
      ],
    );

    expect(rows.map((row) => row['uuid']), containsAll(<String>['role-1', 'role-2']));
    expect(rows.map((row) => row['uuid']), isNot(contains('role-3')));
  });

  test('assigned roles fall back to all rows when owner scoping finds no matches', () {
    final rows = filterRoleRowsForOwnerForTesting(
      ownerUuid: 'owner-1',
      rows: <Map<String, dynamic>>[
        <String, dynamic>{'uuid': 'role-1', 'ownerUuid': 'owner-2', 'name': 'Owner'},
        <String, dynamic>{'uuid': 'role-2', 'ownerUuid': 'owner-3', 'name': 'Admin'},
      ],
    );

    expect(rows.map((row) => row['uuid']), <String>['role-1', 'role-2']);
  });

  test('explicit allow removes matching deny candidates', () {
    final result = applyExplicitPermissionGrantForTesting(
      allowPermissions: <String>{PermissionCatalog.dashboardView},
      denyPermissions: <String>{'page.users.*', 'page.users.view'},
      permission: 'page.users.view',
      isAllowed: true,
    );

    expect(result['allow'], contains('page.users.view'));
    expect(result['deny'], isNot(contains('page.users.view')));
    expect(result['deny'], isNot(contains('page.users.*')));
  });

  test('explicit deny removes exact allow permission', () {
    final result = applyExplicitPermissionGrantForTesting(allowPermissions: <String>{'page.users.view', PermissionCatalog.dashboardView}, denyPermissions: <String>{}, permission: 'page.users.view', isAllowed: false);

    expect(result['allow'], isNot(contains('page.users.view')));
    expect(result['deny'], contains('page.users.view'));
    expect(result['allow'], contains(PermissionCatalog.dashboardView));
  });

  test('stale snapshots should refresh when the max age is exceeded', () {
    final now = DateTime(2026, 5, 20, 12, 0, 0);

    expect(shouldRefreshAccessSnapshotForTesting(isLoading: false, hasError: false, lastSuccessfulRefreshAt: now.subtract(const Duration(minutes: 2)), maxAge: const Duration(seconds: 45), now: now), isTrue);

    expect(shouldRefreshAccessSnapshotForTesting(isLoading: false, hasError: false, lastSuccessfulRefreshAt: now.subtract(const Duration(seconds: 10)), maxAge: const Duration(seconds: 45), now: now), isFalse);
  });

  test('missing or errored snapshots refresh immediately unless loading is already active', () {
    final now = DateTime(2026, 5, 20, 12, 0, 0);

    expect(shouldRefreshAccessSnapshotForTesting(isLoading: false, hasError: true, lastSuccessfulRefreshAt: now, maxAge: const Duration(seconds: 45), now: now), isTrue);

    expect(shouldRefreshAccessSnapshotForTesting(isLoading: false, hasError: false, lastSuccessfulRefreshAt: null, maxAge: const Duration(seconds: 45), now: now), isTrue);

    expect(shouldRefreshAccessSnapshotForTesting(isLoading: true, hasError: true, lastSuccessfulRefreshAt: null, maxAge: const Duration(seconds: 45), now: now), isFalse);
  });
}