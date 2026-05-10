import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/services/access_control_service.dart';

void main() {
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
}