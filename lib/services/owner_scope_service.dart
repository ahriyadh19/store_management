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
  OwnerScopeService({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  static const Duration _cacheTtl = Duration(seconds: 20);

  final SupabaseClient _client;
  _CachedScope? _cached;

  Future<OwnerScope> resolveCurrentScope({bool forceRefresh = false}) async {
    final now = DateTime.now();
    if (!forceRefresh && _cached != null && now.isBefore(_cached!.expiresAt)) {
      return _cached!.scope;
    }

    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      return _cache(const OwnerScope(userUuid: null, ownerUuid: null, storeUuids: <String>{}, branchUuids: <String>{}));
    }

    try {
      final usersRows = await _client
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

      final memberships = await _client
          .from('owner_user_membership')
          .select('ownerUuid,status,deletedAt,createdAt')
          .eq('userUuid', userUuid)
          .eq('status', 1)
          .isFilter('deletedAt', null)
          .order('createdAt', ascending: true)
          .limit(1);

      final membershipRows = memberships as List<dynamic>;
      if (membershipRows.isEmpty) {
        return _cache(OwnerScope(userUuid: userUuid, ownerUuid: null, storeUuids: const <String>{}, branchUuids: const <String>{}));
      }

      final ownerUuid = (membershipRows.first as Map<String, dynamic>)['ownerUuid']?.toString();
      if (ownerUuid == null || ownerUuid.isEmpty) {
        return _cache(OwnerScope(userUuid: userUuid, ownerUuid: null, storeUuids: const <String>{}, branchUuids: const <String>{}));
      }

        final membershipRowsForScope = (await _client
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
          : await _client
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
        final storeRows = await _client.from('store').select('uuid').eq('ownerUuid', ownerUuid).isFilter('deletedAt', null);
        for (final raw in storeRows as List<dynamic>) {
          final uuid = (raw as Map<String, dynamic>)['uuid']?.toString();
          if (uuid != null && uuid.isNotEmpty) {
            storeUuids.add(uuid);
          }
        }
      }

      if (branchUuids.isEmpty) {
        final branchRows = await _client.from('branch').select('uuid').eq('ownerUuid', ownerUuid).isFilter('deletedAt', null);
        for (final raw in branchRows as List<dynamic>) {
          final uuid = (raw as Map<String, dynamic>)['uuid']?.toString();
          if (uuid != null && uuid.isNotEmpty) {
            branchUuids.add(uuid);
          }
        }
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
}

class _CachedScope {
  const _CachedScope({required this.scope, required this.expiresAt});

  final OwnerScope scope;
  final DateTime expiresAt;
}
