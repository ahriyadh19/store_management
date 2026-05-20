import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:store_management/views/index/index_page.dart';

class AccessControlSnapshot {
  const AccessControlSnapshot({
    required this.isLoading,
    required this.userUuid,
    required this.ownerUuid,
    required this.membershipRoles,
    required this.roleNames,
    required this.allowPermissions,
    required this.denyPermissions,
    required this.lastError,
  });

  factory AccessControlSnapshot.initial() {
    return const AccessControlSnapshot(
      isLoading: false,
      userUuid: null,
      ownerUuid: null,
      membershipRoles: <String>{},
      roleNames: <String>{},
      allowPermissions: <String>{},
      denyPermissions: <String>{},
      lastError: null,
    );
  }

  final bool isLoading;
  final String? userUuid;
  final String? ownerUuid;
  final Set<String> membershipRoles;
  final Set<String> roleNames;
  final Set<String> allowPermissions;
  final Set<String> denyPermissions;
  final String? lastError;

  bool get hasOwnerScope => ownerUuid != null && ownerUuid!.isNotEmpty;

  bool get isOwnerAdmin {
    return allowPermissions.contains('*');
  }

  bool can(String permission) {
    if (isOwnerAdmin) {
      return true;
    }

    final normalized = _normalizePermissionKey(permission);
    if (normalized.isEmpty) {
      return false;
    }

    final denyCandidates = _permissionCandidates(normalized);
    for (final candidate in denyCandidates) {
      if (denyPermissions.contains(candidate)) {
        return false;
      }
    }

    final allowCandidates = _permissionCandidates(normalized);
    for (final candidate in allowCandidates) {
      if (allowPermissions.contains(candidate)) {
        return true;
      }
    }

    return false;
  }

  bool canViewPage(IndexPage page) {
    final pagePermission = PermissionCatalog.pageViewPermission(page);
    return can(pagePermission);
  }

  bool canUseSettings() => can(PermissionCatalog.settingsView);

  bool canTableAction(String tableName, String action) {
    if (isOwnerAdmin) {
      return true;
    }

    final normalizedTable = _normalizePermissionKey(tableName);
    final normalizedAction = _normalizePermissionKey(action);

    if (normalizedTable.isEmpty || normalizedAction.isEmpty) {
      return false;
    }

    final specificPermission = PermissionCatalog.tableActionPermission(normalizedTable, normalizedAction);
    if (can(specificPermission)) {
      return true;
    }

    final modulePermission = PermissionCatalog.moduleManagePermissionFromTable(normalizedTable);
    if (modulePermission != null && can(modulePermission)) {
      return true;
    }

    if (normalizedAction == 'read') {
      final pagePermission = PermissionCatalog.pagePermissionFromTable(normalizedTable);
      if (pagePermission != null && can(pagePermission)) {
        return true;
      }
    }

    return false;
  }

  AccessControlSnapshot copyWith({
    bool? isLoading,
    String? userUuid,
    bool clearUserUuid = false,
    String? ownerUuid,
    bool clearOwnerUuid = false,
    Set<String>? membershipRoles,
    Set<String>? roleNames,
    Set<String>? allowPermissions,
    Set<String>? denyPermissions,
    String? lastError,
    bool clearError = false,
  }) {
    return AccessControlSnapshot(
      isLoading: isLoading ?? this.isLoading,
      userUuid: clearUserUuid ? null : (userUuid ?? this.userUuid),
      ownerUuid: clearOwnerUuid ? null : (ownerUuid ?? this.ownerUuid),
      membershipRoles: membershipRoles ?? this.membershipRoles,
      roleNames: roleNames ?? this.roleNames,
      allowPermissions: allowPermissions ?? this.allowPermissions,
      denyPermissions: denyPermissions ?? this.denyPermissions,
      lastError: clearError ? null : (lastError ?? this.lastError),
    );
  }
}

class AccessControlService extends ChangeNotifier {
  AccessControlService({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  static final AccessControlService instance = AccessControlService();

  final SupabaseClient _client;
  AccessControlSnapshot _snapshot = AccessControlSnapshot.initial();

  AccessControlSnapshot get snapshot => _snapshot;

  bool can(String permission) => _snapshot.can(permission);

  bool canViewPage(IndexPage page) => _snapshot.canViewPage(page);

  bool canUseSettings() => _snapshot.canUseSettings();

  bool canTableAction(String tableName, String action) => _snapshot.canTableAction(tableName, action);

  Future<void> refresh({bool provisionIfNeeded = false}) async {
    _snapshot = _snapshot.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      _snapshot = AccessControlSnapshot.initial();
      notifyListeners();
      return;
    }

    try {
      if (provisionIfNeeded) {
        await _bootstrapCurrentUserAccessBestEffort();
      }

      final userUuid = await _loadCurrentUserUuid(authUser.id);
      if (userUuid == null || userUuid.isEmpty) {
        _snapshot = AccessControlSnapshot.initial().copyWith(lastError: 'Unable to resolve current profile uuid.');
        notifyListeners();
        return;
      }

      final membershipRows = await _loadMembershipRows(userUuid);
      if (membershipRows.isEmpty && provisionIfNeeded) {
        await _bootstrapCurrentUserAccessBestEffort();
      }

      final refreshedMembershipRows = membershipRows.isEmpty ? await _loadMembershipRows(userUuid) : membershipRows;
      final normalizedMemberships = refreshedMembershipRows.map(_normalizeRow).toList(growable: false);

      final membershipUuids = normalizedMemberships
          .map((row) => row['uuid'])
          .whereType<String>()
          .where((value) => value.trim().isNotEmpty)
          .toSet();

      String? ownerUuid;
      if (normalizedMemberships.isNotEmpty) {
        ownerUuid = normalizedMemberships.first['ownerUuid']?.toString();
      }

      final membershipRoles = <String>{};
      final allowPermissions = <String>{};
      final denyPermissions = <String>{};

      for (final row in normalizedMemberships) {
        final role = row['role']?.toString();
        final normalizedRole = _normalizePermissionKey(role ?? '');
        if (role != null && role.trim().isNotEmpty) {
          membershipRoles.add(normalizedRole);
        }

        final parsed = _parsePermissions(row['permissionsJson']);
        allowPermissions.addAll(parsed.allow);
        denyPermissions.addAll(parsed.deny);

        if (parsed.allow.isEmpty && parsed.deny.isEmpty) {
          allowPermissions.addAll(_defaultAllowPermissionsForSystemRole(normalizedRole));
        }
      }

      if (membershipUuids.isNotEmpty) {
        final permissionScopeRows = await _loadPermissionScopeRows(membershipUuids);
        for (final row in permissionScopeRows) {
          final permission = _normalizePermissionKey(row['permission']?.toString() ?? '');
          if (permission.isEmpty) {
            continue;
          }
          allowPermissions.add(permission);
        }
      }

      final roleRows = await _loadRoleRowsForUser(userUuid: userUuid, ownerUuid: ownerUuid);
      final roleNames = <String>{};
      for (final row in roleRows) {
        final roleName = row['name']?.toString();
        final normalizedRoleName = _normalizePermissionKey(roleName ?? '');
        if (roleName != null && roleName.trim().isNotEmpty) {
          roleNames.add(normalizedRoleName);
        }

        final parsed = _parsePermissions(row['permissionsJson']);
        allowPermissions.addAll(parsed.allow);
        denyPermissions.addAll(parsed.deny);

        if (parsed.allow.isEmpty && parsed.deny.isEmpty) {
          allowPermissions.addAll(_defaultAllowPermissionsForSystemRole(normalizedRoleName));
        }
      }

      final hasPrivilegedRole =
          membershipRoles.any(_isPrivilegedRoleName) || roleNames.any(_isPrivilegedRoleName);
      if (hasPrivilegedRole) {
        // Ensure tenant owner/admin users remain fully functional even if
        // permissionsJson payloads were partially customized or malformed.
        allowPermissions.add('*');
        denyPermissions.remove('*');
      }

      if (!allowPermissions.contains('*') && !allowPermissions.contains(PermissionCatalog.dashboardView)) {
        allowPermissions.add(PermissionCatalog.dashboardView);
      }

      _snapshot = AccessControlSnapshot(
        isLoading: false,
        userUuid: userUuid,
        ownerUuid: ownerUuid,
        membershipRoles: UnmodifiableSetView<String>(membershipRoles),
        roleNames: UnmodifiableSetView<String>(roleNames),
        allowPermissions: UnmodifiableSetView<String>(allowPermissions),
        denyPermissions: UnmodifiableSetView<String>(denyPermissions),
        lastError: null,
      );
      notifyListeners();
    } catch (error) {
      _snapshot = _snapshot.copyWith(
        isLoading: false,
        lastError: error.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> _bootstrapCurrentUserAccessBestEffort() async {
    try {
      await _client.rpc('bootstrap_current_user_access');
    } catch (_) {
      // Bootstrap is best-effort. Existing systems may use a custom provisioning process.
    }
  }

  Future<String?> _loadCurrentUserUuid(String authUserId) async {
    final rows = await _client.from('users').select('uuid').eq('auth_user_id', authUserId).limit(1);
    final list = rows as List<dynamic>;
    if (list.isEmpty) {
      return null;
    }

    final row = _normalizeRow(list.first);
    final uuid = row['uuid']?.toString();
    if (uuid == null || uuid.trim().isEmpty) {
      return null;
    }

    return uuid;
  }

  Future<List<dynamic>> _loadMembershipRows(String userUuid) async {
    final rows = await _client
        .from('owner_user_membership')
        .select('uuid,ownerUuid,role,permissionsJson,status,deletedAt,createdAt')
        .eq('userUuid', userUuid)
        .eq('status', 1)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: true);

    return rows as List<dynamic>;
  }

  Future<List<Map<String, dynamic>>> _loadRoleRowsForUser({required String userUuid, required String? ownerUuid}) async {
    final userRoleRows = await _client
        .from('user_roles')
        .select('roleUuid,status,deletedAt')
        .eq('userUuid', userUuid)
        .eq('status', 1)
        .isFilter('deletedAt', null);

    final roleUuids = (userRoleRows as List<dynamic>)
        .map(_normalizeRow)
        .map((row) => row['roleUuid'])
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .toSet();

    if (roleUuids.isEmpty) {
      return const <Map<String, dynamic>>[];
    }

    dynamic query = _client
        .from('roles')
        .select('uuid,name,permissionsJson,ownerUuid,status,deletedAt')
        .inFilter('uuid', roleUuids.toList(growable: false))
        .eq('status', 1)
        .isFilter('deletedAt', null);

    if (ownerUuid != null && ownerUuid.trim().isNotEmpty) {
      query = query.eq('ownerUuid', ownerUuid);
    }

    final rows = await query;
    return (rows as List<dynamic>).map(_normalizeRow).toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> _loadPermissionScopeRows(Set<String> membershipUuids) async {
    final rows = await _client
        .from('owner_permission_scope')
        .select('permission,status,deletedAt')
        .inFilter('ownerMembershipUuid', membershipUuids.toList(growable: false))
        .eq('status', 1)
        .isFilter('deletedAt', null);

    return (rows as List<dynamic>).map(_normalizeRow).toList(growable: false);
  }

  static Map<String, dynamic> _normalizeRow(dynamic row) {
    if (row is Map<String, dynamic>) {
      return row;
    }
    if (row is Map) {
      return Map<String, dynamic>.from(row);
    }
    return const <String, dynamic>{};
  }
}

Set<String> _defaultAllowPermissionsForSystemRole(String normalizedRole) {
  switch (_canonicalSystemRole(normalizedRole)) {
    case 'owner':
    case 'admin':
      return const <String>{'*'};
    case 'manager':
      return const <String>{
        PermissionCatalog.dashboardView,
        'page.inventory.view',
        'page.transactions.view',
        'page.products.view',
        'page.invoices.view',
        'page.clients.view',
        'page.suppliers.view',
      };
    case 'staff':
      return const <String>{
        PermissionCatalog.dashboardView,
        'page.inventory.view',
        'page.transactions.view',
        'page.products.view',
        'page.invoices.view',
      };
    case 'viewer':
      return const <String>{
        PermissionCatalog.dashboardView,
        'page.inventory.view',
        'page.products.view',
        'page.invoices.view',
        'page.clients.view',
        'page.suppliers.view',
      };
    case 'accountant':
      return const <String>{
        PermissionCatalog.dashboardView,
        PermissionCatalog.reportsView,
        'page.invoices.view',
        'page.transactions.view',
        'page.clients.view',
      };
    default:
      return const <String>{};
  }
}

class PermissionCatalog {
  static const String dashboardView = 'page.dashboard.view';
  static const String reportsView = 'page.reports.view';
  static const String settingsView = 'page.settings.view';

  static const String usersManage = 'users.manage';
  static const String rolesManage = 'roles.manage';
  static const String permissionsManage = 'permissions.manage';

  static const List<String> tableActions = <String>['read', 'create', 'update', 'delete', 'sync'];

  static const List<String> managedTables = <String>[
    'users',
    'roles',
    'user_roles',
    'store',
    'branch',
    'products',
    'category',
    'tags',
    'client',
    'supplier',
    'store_supplier',
    'store_client',
    'store_user',
    'store_branches',
    'branch_product',
    'store_invoice',
    'store_invoice_item',
    'store_return',
    'store_return_item',
    'store_payment_voucher',
    'payment_allocation',
    'inventory_movement',
    'store_financial_transaction',
    'purchase_order',
    'purchase_order_item',
    'supplier_invoice',
    'inventory_batch',
    'inventory_transaction',
    'transfer_order',
    'transfer_order_item',
    'sales_order',
    'sales_invoice',
    'sales_return',
    'branch_price',
    'promotion_rule',
    'staff_shift',
    'staff_attendance',
    'staff_activity_log',
    'owner_account',
    'owner_user_membership',
    'owner_permission_scope',
  ];

  static List<PermissionGroupDefinition> permissionGroups() {
    final pagePermissions = <PermissionOptionDefinition>[];
    for (final page in IndexPage.values) {
      final key = pageViewPermission(page);
      pagePermissions.add(
        PermissionOptionDefinition(
          key: key,
          label: 'View ${_humanize(page.name)}',
          description: 'Controls navigation and page visibility for ${_humanize(page.name)}.',
        ),
      );
    }

    final systemPermissions = <PermissionOptionDefinition>[
      const PermissionOptionDefinition(
        key: usersManage,
        label: 'Manage Users',
        description: 'Grant broad user administration capabilities.',
      ),
      const PermissionOptionDefinition(
        key: rolesManage,
        label: 'Manage Roles',
        description: 'Grant role creation/editing management access.',
      ),
      const PermissionOptionDefinition(
        key: permissionsManage,
        label: 'Manage Permissions',
        description: 'Grant permission scope and assignment administration.',
      ),
      const PermissionOptionDefinition(
        key: '*',
        label: 'Full Access (*)',
        description: 'Allows all pages and actions across the platform.',
      ),
    ];

    final tablePermissions = <PermissionOptionDefinition>[];
    for (final tableName in managedTables) {
      for (final action in tableActions) {
        final key = tableActionPermission(tableName, action);
        tablePermissions.add(
          PermissionOptionDefinition(
            key: key,
            label: '${_humanize(action)} ${_humanize(tableName)}',
            description: 'Controls ${_humanize(action).toLowerCase()} on table $tableName.',
          ),
        );
      }
      tablePermissions.add(
        PermissionOptionDefinition(
          key: 'table.$tableName.*',
          label: 'All ${_humanize(tableName)} Actions',
          description: 'Allows all CRUD and sync actions on $tableName.',
        ),
      );
    }

    return <PermissionGroupDefinition>[
      PermissionGroupDefinition(key: 'pages', title: 'Page Visibility', options: pagePermissions),
      PermissionGroupDefinition(key: 'system', title: 'System Management', options: systemPermissions),
      PermissionGroupDefinition(key: 'tables', title: 'Table Actions', options: tablePermissions),
    ];
  }

  static String pageViewPermission(IndexPage page) {
    return switch (page) {
      IndexPage.dashboard => dashboardView,
      IndexPage.reports => reportsView,
      IndexPage.stores => 'page.stores.view',
      IndexPage.branches => 'page.branches.view',
      IndexPage.products => 'page.products.view',
      IndexPage.categories => 'page.categories.view',
      IndexPage.tags => 'page.tags.view',
      IndexPage.invoices => 'page.invoices.view',
      IndexPage.returns => 'page.returns.view',
      IndexPage.paymentVouchers => 'page.paymentVouchers.view',
      IndexPage.clients => 'page.clients.view',
      IndexPage.suppliers => 'page.suppliers.view',
      IndexPage.users => 'page.users.view',
      IndexPage.roles => 'page.roles.view',
      IndexPage.inventory => 'page.inventory.view',
      IndexPage.transactions => 'page.transactions.view',
      IndexPage.settings => settingsView,
    };
  }

  static String tableActionPermission(String tableName, String action) => 'table.${_normalizePermissionKey(tableName)}.${_normalizePermissionKey(action)}';

  static String? moduleManagePermissionFromTable(String tableName) {
    return switch (_normalizePermissionKey(tableName)) {
      'users' => usersManage,
      'roles' => rolesManage,
      'user_roles' => permissionsManage,
      'owner_permission_scope' => permissionsManage,
      _ => null,
    };
  }

  static String? pagePermissionFromTable(String tableName) {
    final normalized = _normalizePermissionKey(tableName);
    return switch (normalized) {
      'store' => pageViewPermission(IndexPage.stores),
      'branch' => pageViewPermission(IndexPage.branches),
      'products' => pageViewPermission(IndexPage.products),
      'category' => pageViewPermission(IndexPage.categories),
      'tags' => pageViewPermission(IndexPage.tags),
      'store_invoice' => pageViewPermission(IndexPage.invoices),
      'store_return' => pageViewPermission(IndexPage.returns),
      'store_payment_voucher' => pageViewPermission(IndexPage.paymentVouchers),
      'client' => pageViewPermission(IndexPage.clients),
      'supplier' => pageViewPermission(IndexPage.suppliers),
      'users' => pageViewPermission(IndexPage.users),
      'roles' => pageViewPermission(IndexPage.roles),
      'user_roles' => pageViewPermission(IndexPage.roles),
      'inventory_batch' => pageViewPermission(IndexPage.inventory),
      'inventory_transaction' => pageViewPermission(IndexPage.inventory),
      'inventory_movement' => pageViewPermission(IndexPage.inventory),
      'store_financial_transaction' => pageViewPermission(IndexPage.transactions),
      'purchase_order' => pageViewPermission(IndexPage.transactions),
      'purchase_order_item' => pageViewPermission(IndexPage.transactions),
      'supplier_invoice' => pageViewPermission(IndexPage.transactions),
      'transfer_order' => pageViewPermission(IndexPage.transactions),
      'transfer_order_item' => pageViewPermission(IndexPage.transactions),
      'sales_order' => pageViewPermission(IndexPage.transactions),
      'sales_invoice' => pageViewPermission(IndexPage.transactions),
      'sales_return' => pageViewPermission(IndexPage.transactions),
      'branch_price' => pageViewPermission(IndexPage.transactions),
      'promotion_rule' => pageViewPermission(IndexPage.transactions),
      'staff_shift' => pageViewPermission(IndexPage.transactions),
      'staff_attendance' => pageViewPermission(IndexPage.transactions),
      'staff_activity_log' => pageViewPermission(IndexPage.transactions),
      _ => null,
    };
  }

  static String _humanize(String raw) {
    final normalized = raw.replaceAll('_', ' ').trim();
    if (normalized.isEmpty) {
      return raw;
    }
    return normalized[0].toUpperCase() + normalized.substring(1);
  }
}

class PermissionGroupDefinition {
  const PermissionGroupDefinition({required this.key, required this.title, required this.options});

  final String key;
  final String title;
  final List<PermissionOptionDefinition> options;
}

class PermissionOptionDefinition {
  const PermissionOptionDefinition({required this.key, required this.label, this.description});

  final String key;
  final String label;
  final String? description;
}

class _PermissionSet {
  const _PermissionSet({required this.allow, required this.deny});

  final Set<String> allow;
  final Set<String> deny;
}

_PermissionSet _parsePermissions(dynamic value) {
  if (value == null) {
    return const _PermissionSet(allow: <String>{}, deny: <String>{});
  }

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return const _PermissionSet(allow: <String>{}, deny: <String>{});
    }

    try {
      final decoded = jsonDecode(trimmed);
      return _parsePermissions(decoded);
    } catch (_) {
      return _PermissionSet(allow: <String>{_normalizePermissionKey(trimmed)}, deny: const <String>{});
    }
  }

  if (value is List) {
    final allow = value
        .map((item) => _normalizePermissionKey(item.toString()))
        .where((permission) => permission.isNotEmpty)
        .toSet();
    return _PermissionSet(allow: allow, deny: const <String>{});
  }

  if (value is! Map) {
    return const _PermissionSet(allow: <String>{}, deny: <String>{});
  }

  final map = Map<String, dynamic>.from(value);
  final allow = <String>{};
  final deny = <String>{};

  for (final entry in map.entries) {
    final key = _normalizePermissionKey(entry.key);
    if (key.isEmpty) {
      continue;
    }

    final value = entry.value;
    if (value is bool) {
      if (value) {
        allow.add(key);
      } else {
        deny.add(key);
      }
      continue;
    }

    if (value is num) {
      if (value != 0) {
        allow.add(key);
      } else {
        deny.add(key);
      }
      continue;
    }

    if (value is String) {
      final normalizedValue = value.trim().toLowerCase();
      if (normalizedValue == 'true' || normalizedValue == 'allow' || normalizedValue == '1') {
        allow.add(key);
      } else if (normalizedValue == 'false' || normalizedValue == 'deny' || normalizedValue == '0') {
        deny.add(key);
      }
      continue;
    }

    if (key == 'allow' && value is List) {
      for (final item in value) {
        final permission = _normalizePermissionKey(item.toString());
        if (permission.isNotEmpty) {
          allow.add(permission);
        }
      }
      continue;
    }

    if (key == 'deny' && value is List) {
      for (final item in value) {
        final permission = _normalizePermissionKey(item.toString());
        if (permission.isNotEmpty) {
          deny.add(permission);
        }
      }
      continue;
    }
  }

  return _PermissionSet(allow: allow, deny: deny);
}

String _normalizePermissionKey(String value) {
  return value.trim().replaceAll(' ', '').replaceAll('/', '.').toLowerCase();
}

@visibleForTesting
String canonicalSystemRoleForTesting(String role) => _canonicalSystemRole(role);

String _canonicalSystemRole(String role) {
  final normalized = _normalizePermissionKey(role);
  if (normalized.isEmpty) {
    return '';
  }

  final canonical = normalized.replaceAll('_', '').replaceAll('-', '').replaceAll('.', '');
  if (canonical.contains('owner')) {
    return 'owner';
  }

  return switch (canonical) {
    'admin' || 'amin' || 'administrator' || 'adminstrator' || 'systemadmin' || 'systemadministrator' || 'superadmin' || 'superadministrator' => 'admin',
    'manager' => 'manager',
    'staff' => 'staff',
    'viewer' => 'viewer',
    'accountant' => 'accountant',
    _ => normalized,
  };
}

bool _isPrivilegedRoleName(String normalizedRole) {
  return switch (_canonicalSystemRole(normalizedRole)) {
    'owner' || 'admin' => true,
    _ => false,
  };
}

List<String> _permissionCandidates(String permission) {
  final normalized = _normalizePermissionKey(permission);
  if (normalized.isEmpty) {
    return const <String>[];
  }

  final candidates = <String>{normalized, '*'};
  final parts = normalized.split('.');
  if (parts.length > 1) {
    for (var index = parts.length - 1; index > 0; index--) {
      final prefix = parts.sublist(0, index).join('.');
      candidates.add('$prefix.*');
    }
  }

  return candidates.toList(growable: false);
}
