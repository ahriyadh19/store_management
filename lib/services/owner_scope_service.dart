import 'package:supabase_flutter/supabase_flutter.dart';

class OwnerScope {
  const OwnerScope({required this.userUuid, required this.ownerUuid, required this.storeUuids, required this.branchUuids});

  final String? userUuid;
  final String? ownerUuid;
  final Set<String> storeUuids;
  final Set<String> branchUuids;

  bool get hasOwner => ownerUuid != null && ownerUuid!.isNotEmpty;
}

class OwnerScopeService {
  OwnerScopeService({SupabaseClient? client}) : _client = client;

  static const Duration _cacheTtl = Duration(seconds: 20);

  final SupabaseClient? _client;
  _CachedScope? _cached;

  Future<OwnerScope> resolveCurrentScope({bool forceRefresh = false}) async {
    final now = DateTime.now();
    if (!forceRefresh && _cached != null && now.isBefore(_cached!.expiresAt)) {
      return _cached!.scope;
    }

    final client = _resolveClient();
    if (client == null) {
      return _cache(const OwnerScope(userUuid: null, ownerUuid: null, storeUuids: <String>{}, branchUuids: <String>{}));
    }

    final authUser = client.auth.currentUser;
    if (authUser == null) {
      return _cache(const OwnerScope(userUuid: null, ownerUuid: null, storeUuids: <String>{}, branchUuids: <String>{}));
    }

    try {
      final usersRows = await client
          .from('users')
          .select('uuid')
          .eq('auth_user_id', authUser.id)
          .limit(1);

      final userRowsList = usersRows as List<dynamic>;
      if (userRowsList.isEmpty) {
        return _cache(const OwnerScope(userUuid: null, ownerUuid: null, storeUuids: <String>{}, branchUuids: <String>{}));
      }

      final userUuid = (userRowsList.first as Map<String, dynamic>)['uuid']?.toString();
      if (userUuid == null || userUuid.isEmpty) {
        return _cache(const OwnerScope(userUuid: null, ownerUuid: null, storeUuids: <String>{}, branchUuids: <String>{}));
      }

      String? ownerUuid;
      try {
        final memberships = await client
            .from('owner_user_membership')
            .select('ownerUuid,status,deletedAt,createdAt')
            .eq('userUuid', userUuid)
            .eq('status', 1)
            .isFilter('deletedAt', null)
            .order('createdAt', ascending: true)
            .limit(1);

        final membershipRows = memberships as List<dynamic>;
        if (membershipRows.isNotEmpty) {
          ownerUuid = (membershipRows.first as Map<String, dynamic>)['ownerUuid']?.toString();
        }
      } catch (_) {
        // Fall back to role-based scope resolution if membership query fails.
      }

      ownerUuid ??= await _resolveOwnerUuidFromAssignedRoles(userUuid);

      if (ownerUuid == null || ownerUuid.isEmpty) {
        return _cache(OwnerScope(userUuid: userUuid, ownerUuid: null, storeUuids: const <String>{}, branchUuids: const <String>{}));
      }

      final membershipRowsForScope = (await client
            .from('owner_user_membership')
            .select('uuid')
            .eq('userUuid', userUuid)
            .eq('ownerUuid', ownerUuid)
            .eq('status', 1)
            .isFilter('deletedAt', null))
          as List<dynamic>;

        final membershipUuids = membershipRowsForScope
          .map((e) => (e as Map<String, dynamic>)['uuid'])
          .whereType<String>()
          .toList(growable: false);

        final scopeRows = membershipUuids.isEmpty
          ? <dynamic>[]
          : await client
            .from('owner_permission_scope')
            .select('scopeType,scopeUuid,status,deletedAt')
            .eq('status', 1)
            .isFilter('deletedAt', null)
            .inFilter('ownerMembershipUuid', membershipUuids);

      final storeUuids = <String>{};
      final branchUuids = <String>{};
      for (final raw in scopeRows) {
        final row = raw as Map<String, dynamic>;
        final scopeType = row['scopeType']?.toString();
        final scopeUuid = row['scopeUuid']?.toString();
        if (scopeUuid == null || scopeUuid.isEmpty) {
          continue;
        }

        if (scopeType == 'store') {
          storeUuids.add(scopeUuid);
        } else if (scopeType == 'branch') {
          branchUuids.add(scopeUuid);
        }
      }

      // Fallback to all owner stores/branches when no explicit scope rows exist.
      if (storeUuids.isEmpty) {
        final storeRows = await client.from('store').select('uuid').eq('ownerUuid', ownerUuid).isFilter('deletedAt', null);
        for (final raw in storeRows as List<dynamic>) {
          final uuid = (raw as Map<String, dynamic>)['uuid']?.toString();
          if (uuid != null && uuid.isNotEmpty) {
            storeUuids.add(uuid);
          }
        }
      }

      if (branchUuids.isEmpty) {
        final storeBranchRows = storeUuids.isEmpty
            ? const <dynamic>[]
            : await client.from('store_branches').select('branchUuid,status,deletedAt').eq('status', 1).isFilter('deletedAt', null).inFilter('storeUuid', storeUuids.toList(growable: false));
        branchUuids.addAll(extractBranchUuidsFromStoreBranchRowsForTesting(storeBranchRows));
      }

      return _cache(OwnerScope(userUuid: userUuid, ownerUuid: ownerUuid, storeUuids: storeUuids, branchUuids: branchUuids));
    } catch (_) {
      return _cache(const OwnerScope(userUuid: null, ownerUuid: null, storeUuids: <String>{}, branchUuids: <String>{}));
    }
  }

  OwnerScope _cache(OwnerScope scope) {
    _cached = _CachedScope(scope: scope, expiresAt: DateTime.now().add(_cacheTtl));
    return scope;
  }

  SupabaseClient? _resolveClient() {
    if (_client != null) {
      return _client;
    }

    try {
      return Supabase.instance.client;
    } on AssertionError {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _resolveOwnerUuidFromAssignedRoles(String userUuid) async {
    final client = _resolveClient();
    if (client == null) {
      return null;
    }

    try {
      final userRoleRows = (await client
          .from('user_roles')
          .select('roleUuid,status,deletedAt')
          .eq('userUuid', userUuid)
          .eq('status', 1)
          .isFilter('deletedAt', null)) as List<dynamic>;

      final roleUuids = userRoleRows
          .map((row) => (row as Map<String, dynamic>)['roleUuid']?.toString())
          .whereType<String>()
          .where((uuid) => uuid.isNotEmpty)
          .toList(growable: false);

      if (roleUuids.isEmpty) {
        return null;
      }

      final roleRows =
          (await client
          .from('roles')
          .select('ownerUuid,status,deletedAt,createdAt')
          .inFilter('uuid', roleUuids)
          .eq('status', 1)
          .isFilter('deletedAt', null)
          .order('createdAt', ascending: true)
          .limit(1)) as List<dynamic>;

      if (roleRows.isEmpty) {
        return null;
      }

      final ownerUuid = (roleRows.first as Map<String, dynamic>)['ownerUuid']?.toString();
      if (ownerUuid == null || ownerUuid.isEmpty) {
        return null;
      }

      return ownerUuid;
    } catch (_) {
      return null;
    }
  }
}

Set<String> extractBranchUuidsFromStoreBranchRowsForTesting(List<dynamic> rows) {
  final branchUuids = <String>{};
  for (final raw in rows) {
    final row = raw as Map<String, dynamic>;
    final uuid = row['branchUuid']?.toString();
    if (uuid != null && uuid.isNotEmpty) {
      branchUuids.add(uuid);
    }
  }
  return branchUuids;
}

class _CachedScope {
  const _CachedScope({required this.scope, required this.expiresAt});

  final OwnerScope scope;
  final DateTime expiresAt;
}
