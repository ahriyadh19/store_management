import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/owner_scope_service.dart';
import 'package:store_management/services/remote_failure_classifier.dart';
import 'package:store_management/services/sync_conflict_resolution.dart';
import 'package:store_management/services/sync_payload_normalizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, Supabase, SupabaseClient;

enum LocalDatabaseSyncRunState { idle, running, paused, offline, failed }

class LocalDatabaseSyncService extends ChangeNotifier {
  LocalDatabaseSyncService({
    required StoragePreference storagePreference,
    required bool automaticSyncEnabled,
    required bool syncPaused,
    OwnerScopeService? ownerScopeService,
    Duration automaticSyncInterval = const Duration(seconds: 30),
    Duration retrySyncInterval = const Duration(seconds: 10),
    bool Function()? isDatabaseBusy,
  }) : _storagePreference = storagePreference,
       _automaticSyncEnabled = automaticSyncEnabled,
       _syncPaused = syncPaused,
       _ownerScopeService = ownerScopeService ?? OwnerScopeService(),
       _automaticSyncInterval = automaticSyncInterval,
       _retrySyncInterval = retrySyncInterval,
       _isDatabaseBusy = isDatabaseBusy;

  final OwnerScopeService _ownerScopeService;
  final Duration _automaticSyncInterval;
  final Duration _retrySyncInterval;
  final bool Function()? _isDatabaseBusy;

  StoragePreference _storagePreference;
  bool _automaticSyncEnabled;
  bool _syncPaused;
  Timer? _timer;
  bool _started = false;
  bool _isRunning = false;
  int _pendingRecordsCount = 0;
  int _lastPushedCount = 0;
  int _lastPulledCount = 0;
  DateTime? _lastCompletedAt;
  String? _lastErrorMessage;
  LocalDatabaseSyncRunState _state = LocalDatabaseSyncRunState.idle;

  int get pendingRecordsCount => _pendingRecordsCount;
  int get lastPushedCount => _lastPushedCount;
  int get lastPulledCount => _lastPulledCount;
  DateTime? get lastCompletedAt => _lastCompletedAt;
  String? get lastErrorMessage => _lastErrorMessage;
  LocalDatabaseSyncRunState get state => _state;
  bool get isRunning => _isRunning;

  void start() {
    if (_started) {
      return;
    }

    _started = true;
    unawaited(refreshPendingCount());
    _applyConfigurationState();
    _scheduleNextRun();
  }

  void stop() {
    _started = false;
    _timer?.cancel();
  }

  void updateConfiguration({
    required StoragePreference storagePreference,
    required bool automaticSyncEnabled,
    required bool syncPaused,
  }) {
    _storagePreference = storagePreference;
    _automaticSyncEnabled = automaticSyncEnabled;
    _syncPaused = syncPaused;
    _applyConfigurationState();
    _scheduleNextRun();
  }

  Future<void> refreshPendingCount() async {
    final nextCount = _countPendingRecords();
    if (nextCount == _pendingRecordsCount) {
      return;
    }

    _pendingRecordsCount = nextCount;
    notifyListeners();
  }

  Future<void> syncNow({bool force = false}) {
    return _runSync(force: force, triggeredManually: true);
  }

  Future<void> _runSync({required bool force, required bool triggeredManually}) async {
    if (_isRunning || (_isDatabaseBusy?.call() ?? false)) {
      return;
    }

    if (!_canSync(force: force)) {
      await refreshPendingCount();
      _applyConfigurationState();
      return;
    }

    final database = LocalDatabase.current;
    if (database == null || !database.isAvailable) {
      _state = LocalDatabaseSyncRunState.failed;
      _lastErrorMessage = 'Local database is not available.';
      notifyListeners();
      return;
    }

    _timer?.cancel();
    _isRunning = true;
    _state = LocalDatabaseSyncRunState.running;
    _lastErrorMessage = null;
    notifyListeners();

    try {
      final client = _resolveClient();
      if (client == null) {
        throw StateError('Supabase client is not initialized.');
      }

      final syncResult = await _synchronizeDatabase(database: database, client: client);
      _lastPushedCount = syncResult.pushedCount;
      _lastPulledCount = syncResult.pulledCount;
      _lastCompletedAt = DateTime.now();
      _lastErrorMessage = null;
      await refreshPendingCount();
      _state = _configurationState();
    } catch (error) {
      await refreshPendingCount();
      _lastErrorMessage = error.toString();
      if (isRemoteConnectivityFailure(error)) {
        _state = LocalDatabaseSyncRunState.offline;
      } else {
        _state = LocalDatabaseSyncRunState.failed;
      }
      if (triggeredManually) {
        rethrow;
      }
    } finally {
      _isRunning = false;
      notifyListeners();
      _scheduleNextRun();
    }
  }

  Future<_LocalDatabaseSyncResult> _synchronizeDatabase({required LocalDatabase database, required SupabaseClient client}) async {
    var pushedCount = 0;
    for (final tableName in _synchronizationOrder) {
      for (final record in database.getRecordsForType(tableName)) {
        if (record.syncState == OfflineSyncState.synced) {
          continue;
        }

        await _pushPendingRecord(database: database, client: client, record: record);
        pushedCount += 1;
      }
    }

    var pulledCount = 0;
    for (final tableName in _synchronizationOrder) {
      pulledCount += await _pullRemoteTable(database: database, client: client, tableName: tableName);
    }

    return _LocalDatabaseSyncResult(pushedCount: pushedCount, pulledCount: pulledCount);
  }

  Future<void> _pushPendingRecord({required LocalDatabase database, required SupabaseClient client, required OfflineSyncRecord record}) async {
    final payload = _payloadForRecord(database, record);
    if (payload == null) {
      database.removeRecord(modelType: record.modelType, recordUuid: record.recordUuid);
      return;
    }

    if (record.syncState == OfflineSyncState.pendingDelete || record.isDeleted) {
      await _pushPendingDelete(database: database, client: client, record: record, payload: payload);
      return;
    }

    await _pushPendingUpsert(database: database, client: client, record: record, payload: payload);
  }

  Future<void> _pushPendingUpsert({required LocalDatabase database, required SupabaseClient client, required OfflineSyncRecord record, required Map<String, dynamic> payload}) async {
    final scope = await _ownerScopeService.resolveCurrentScope();
    final now = DateTime.now().millisecondsSinceEpoch;
    final normalizedPayload = _sanitizeRemotePayload(
      tableName: record.modelType,
      payload: _enforceTenantPayloadScope(record.modelType, Map<String, dynamic>.from(payload)..removeWhere((key, value) => value == null), scope),
    );
    final looksLikeCreate = _looksLikeCreate(record, normalizedPayload);

    Map<String, dynamic> syncedPayload;
    if (looksLikeCreate) {
      normalizedPayload.removeWhere((key, value) => key == 'id' || value == null);
      final inserted = await _insertRemoteRecord(client: client, tableName: record.modelType, payload: normalizedPayload);
      syncedPayload = Map<String, dynamic>.from(inserted);
    } else {
      final identityPayload = Map<String, dynamic>.from(normalizedPayload);
      if (_remoteSupportsUpdatedAt(record.modelType)) {
        normalizedPayload['updatedAt'] = now;
      }
      normalizedPayload.remove('id');
      final updated = await _updateRemoteRecord(client: client, tableName: record.modelType, payload: normalizedPayload, scope: scope, identityPayload: identityPayload);
      syncedPayload = updated == null ? normalizedPayload : Map<String, dynamic>.from(updated);
    }

    if (record.modelType == 'purchase_order_item') {
      final purchaseOrderUuid = syncedPayload['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        await _recalculatePurchaseOrderTotalRemote(client: client, purchaseOrderUuid: purchaseOrderUuid);
      }
    }

    final normalizedSyncedPayload = normalizeSyncPayload(
      syncedPayload,
      syncState: OfflineSyncState.synced,
      fallbackUpdatedAtMillis: now,
    );
    final syncedRecordUuid = _recordUuidFromPayload(normalizedSyncedPayload, fallback: record.recordUuid);

    if (syncedRecordUuid != record.recordUuid) {
      _rewritePendingReferences(database, oldUuid: record.recordUuid, newUuid: syncedRecordUuid);
    }

    database.putRecord(
      modelType: record.modelType,
      recordUuid: syncedRecordUuid,
      payloadJson: jsonEncode(normalizedSyncedPayload),
      updatedAtMillis: _updatedAtMillisFromPayload(normalizedSyncedPayload, fallback: now),
      remoteUpdatedAtMillis: parseUpdatedAtMillisOrNull(normalizedSyncedPayload),
      syncState: OfflineSyncState.synced,
      isDeleted: false,
    );

    if (syncedRecordUuid != record.recordUuid) {
      database.removeRecord(modelType: record.modelType, recordUuid: record.recordUuid);
    }
  }

  Future<void> _pushPendingDelete({required LocalDatabase database, required SupabaseClient client, required OfflineSyncRecord record, required Map<String, dynamic> payload}) async {
    final scope = await _ownerScopeService.resolveCurrentScope();
    final now = DateTime.now().millisecondsSinceEpoch;
    final supportsSoftDelete = !_hardDeleteTables.contains(record.modelType);

    if (supportsSoftDelete) {
      await _softDeleteRemoteRecord(
        client: client,
        tableName: record.modelType,
        payload: _sanitizeRemotePayload(tableName: record.modelType, payload: <String, dynamic>{'deletedAt': now, if (_remoteSupportsUpdatedAt(record.modelType)) 'updatedAt': now}),
        scope: scope,
        identityPayload: payload,
      );
    } else {
      dynamic query = client.from(record.modelType).delete();
      query = _applyTenantQueryScope(query, record.modelType, scope);
      query = _applyRecordIdentityFilter(query, payload);
      await query;
    }

    if (record.modelType == 'purchase_order_item') {
      final purchaseOrderUuid = payload['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        await _recalculatePurchaseOrderTotalRemote(client: client, purchaseOrderUuid: purchaseOrderUuid);
      }
    }

    database.removeRecord(modelType: record.modelType, recordUuid: record.recordUuid);
  }

  Future<int> _pullRemoteTable({required LocalDatabase database, required SupabaseClient client, required String tableName}) async {
    final scope = await _ownerScopeService.resolveCurrentScope();
    dynamic query = client.from(tableName).select();
    query = _applyTenantQueryScope(query, tableName, scope);
    final response = await query;
    final rows = (response as List<dynamic>).map((row) => Map<String, dynamic>.from(row as Map)).toList(growable: false);

    final remoteRecordUuids = <String>{};
    for (final row in rows) {
      final normalizedRow = normalizeSyncPayload(row, syncState: OfflineSyncState.synced, fallbackUpdatedAtMillis: DateTime.now().millisecondsSinceEpoch);
      final recordUuid = _recordUuidFromPayload(normalizedRow, fallback: normalizedRow.toString());
      remoteRecordUuids.add(recordUuid);
      final remoteUpdatedAtMillis = parseUpdatedAtMillisOrNull(normalizedRow);
      final existingRecord = database.getRecord(modelType: tableName, recordUuid: recordUuid);
      if (existingRecord != null && existingRecord.syncState != OfflineSyncState.synced) {
        final shouldKeepPendingLocal = shouldUsePendingLocalRecordInHybridMerge(localRecord: existingRecord, remoteUpdatedAtMillis: remoteUpdatedAtMillis);
        if (shouldKeepPendingLocal) {
          continue;
        }
      }

      final conflictDetectedAtMillis = existingRecord != null && existingRecord.syncState != OfflineSyncState.synced ? DateTime.now().millisecondsSinceEpoch : null;
      database.putRecord(
        modelType: tableName,
        recordUuid: recordUuid,
        payloadJson: jsonEncode(normalizedRow),
        updatedAtMillis: remoteUpdatedAtMillis ?? DateTime.now().millisecondsSinceEpoch,
        remoteUpdatedAtMillis: remoteUpdatedAtMillis,
        conflictDetectedAtMillis: conflictDetectedAtMillis,
        syncState: OfflineSyncState.synced,
        isDeleted: false,
      );
    }

    for (final localRecord in database.getRecordsForType(tableName)) {
      if (localRecord.syncState != OfflineSyncState.synced) {
        continue;
      }
      if (!remoteRecordUuids.contains(localRecord.recordUuid)) {
        database.removeRecord(modelType: tableName, recordUuid: localRecord.recordUuid);
      }
    }

    return rows.length;
  }

  void _rewritePendingReferences(LocalDatabase database, {required String oldUuid, required String newUuid}) {
    if (oldUuid == newUuid) {
      return;
    }

    for (final tableName in _synchronizationOrder) {
      for (final record in database.getRecordsForType(tableName)) {
        final payload = _payloadForRecord(database, record);
        if (payload == null) {
          continue;
        }

        final rewrittenPayload = _rewritePayloadValue(payload, oldUuid: oldUuid, newUuid: newUuid);
        if (rewrittenPayload is! Map<String, dynamic>) {
          continue;
        }

        final didChange = jsonEncode(rewrittenPayload) != jsonEncode(payload) || record.recordUuid == oldUuid;
        if (!didChange) {
          continue;
        }

        final nextRecordUuid = record.recordUuid == oldUuid ? newUuid : record.recordUuid;
        final normalizedPayload = normalizeSyncPayload(
          rewrittenPayload,
          syncState: record.syncState,
          fallbackUpdatedAtMillis: record.updatedAtMillis,
        );
        database.putRecord(
          modelType: tableName,
          recordUuid: nextRecordUuid,
          payloadJson: jsonEncode(normalizedPayload),
          updatedAtMillis: _updatedAtMillisFromPayload(normalizedPayload, fallback: record.updatedAtMillis),
          remoteUpdatedAtMillis: record.remoteUpdatedAtMillis,
          conflictDetectedAtMillis: record.conflictDetectedAtMillis,
          syncState: record.syncState,
          isDeleted: record.isDeleted,
        );

        if (record.recordUuid == oldUuid && nextRecordUuid != oldUuid) {
          database.removeRecord(modelType: tableName, recordUuid: oldUuid);
        }
      }
    }
  }

  Map<String, dynamic>? _payloadForRecord(LocalDatabase database, OfflineSyncRecord record) {
    final row = database.getRow(modelType: record.modelType, recordUuid: record.recordUuid);
    if (row != null) {
      return Map<String, dynamic>.from(row);
    }

    try {
      return Map<String, dynamic>.from(jsonDecode(record.payloadJson) as Map);
    } catch (_) {
      return null;
    }
  }

  bool _looksLikeCreate(OfflineSyncRecord record, Map<String, dynamic> payload) {
    final uuid = payload['uuid']?.toString().trim() ?? '';
    final id = payload['id'];
    return uuid.isEmpty || uuid.startsWith('local-') || id == null || id == 0 || record.remoteUpdatedAtMillis == null;
  }

  int _countPendingRecords() {
    final database = LocalDatabase.current;
    if (database == null || !database.isAvailable) {
      return 0;
    }

    var count = 0;
    for (final tableName in LocalDatabase.managedModelTypes) {
      count += database.getRecordsForType(tableName).where((record) => record.syncState != OfflineSyncState.synced).length;
    }
    return count;
  }

  SupabaseClient? _resolveClient() {
    try {
      return Supabase.instance.client;
    } on AssertionError {
      return null;
    } catch (_) {
      return null;
    }
  }

  bool _canSync({required bool force}) {
    if (_storagePreference != StoragePreference.hybrid) {
      return false;
    }
    if (_syncPaused && !force) {
      return false;
    }
    if (!_automaticSyncEnabled && !force) {
      return false;
    }
    return true;
  }

  void _applyConfigurationState() {
    if (_isRunning) {
      return;
    }

    final nextState = _configurationState();
    if (_state != nextState) {
      _state = nextState;
      notifyListeners();
    }
  }

  LocalDatabaseSyncRunState _configurationState() {
    if (_storagePreference != StoragePreference.hybrid) {
      return LocalDatabaseSyncRunState.idle;
    }
    if (_syncPaused) {
      return LocalDatabaseSyncRunState.paused;
    }
    return _state == LocalDatabaseSyncRunState.offline || _state == LocalDatabaseSyncRunState.failed ? _state : LocalDatabaseSyncRunState.idle;
  }

  void _scheduleNextRun() {
    _timer?.cancel();
    if (!_started || _storagePreference != StoragePreference.hybrid || !_automaticSyncEnabled || _syncPaused) {
      return;
    }

    final delay = _state == LocalDatabaseSyncRunState.offline ? _retrySyncInterval : _automaticSyncInterval;
    _timer = Timer(delay, () {
      unawaited(_runSync(force: false, triggeredManually: false));
    });
  }

  dynamic _applyRecordIdentityFilter(dynamic query, Map<String, dynamic> payload) {
    final uuid = payload['uuid'];
    final id = payload['id'];
    if (uuid != null && uuid.toString().trim().isNotEmpty) {
      return query.eq('uuid', uuid);
    }
    if (id != null) {
      return query.eq('id', id);
    }
    throw StateError('The pending record has no UUID or id to match against the remote row.');
  }

  Future<void> _recalculatePurchaseOrderTotalRemote({required SupabaseClient client, required String purchaseOrderUuid}) async {
    final scope = await _ownerScopeService.resolveCurrentScope();
    final rows = await client.from('purchase_order_item').select('lineTotal').eq('purchaseOrderUuid', purchaseOrderUuid);
    var total = Decimal.zero;
    for (final raw in rows as List<dynamic>) {
      final row = raw as Map<String, dynamic>;
      total += _decimalOrZero(row['lineTotal']);
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    await _updateRemoteRecord(
      client: client,
      tableName: 'purchase_order',
      payload: _sanitizeRemotePayload(tableName: 'purchase_order', payload: <String, dynamic>{'totalAmount': total.toString(), 'updatedAt': now}),
      scope: scope,
      identityPayload: <String, dynamic>{'uuid': purchaseOrderUuid},
    );
  }

  Future<Map<String, dynamic>> _insertRemoteRecord({required SupabaseClient client, required String tableName, required Map<String, dynamic> payload}) async {
    try {
      final inserted = await client.from(tableName).insert(payload).select().single();
      return Map<String, dynamic>.from(inserted);
    } on PostgrestException catch (error) {
      if (!_isMissingUpdatedAtColumnError(error, tableName) || !_containsUpdatedAtField(payload)) {
        rethrow;
      }

      final fallbackPayload = _withoutUpdatedAtField(payload);
      final inserted = await client.from(tableName).insert(fallbackPayload).select().single();
      return Map<String, dynamic>.from(inserted);
    }
  }

  Future<Map<String, dynamic>?> _updateRemoteRecord({
    required SupabaseClient client,
    required String tableName,
    required Map<String, dynamic> payload,
    required OwnerScope scope,
    required Map<String, dynamic> identityPayload,
  }) async {
    try {
      dynamic query = client.from(tableName).update(payload);
      query = _applyTenantQueryScope(query, tableName, scope);
      query = _applyRecordIdentityFilter(query, identityPayload);
      final updated = await query.select().maybeSingle();
      return updated == null ? null : Map<String, dynamic>.from(updated);
    } on PostgrestException catch (error) {
      if (!_isMissingUpdatedAtColumnError(error, tableName) || !_containsUpdatedAtField(payload)) {
        rethrow;
      }

      final fallbackPayload = _withoutUpdatedAtField(payload);
      dynamic query = client.from(tableName).update(fallbackPayload);
      query = _applyTenantQueryScope(query, tableName, scope);
      query = _applyRecordIdentityFilter(query, identityPayload);
      final updated = await query.select().maybeSingle();
      return updated == null ? null : Map<String, dynamic>.from(updated);
    }
  }

  Future<void> _softDeleteRemoteRecord({required SupabaseClient client, required String tableName, required Map<String, dynamic> payload, required OwnerScope scope, required Map<String, dynamic> identityPayload}) async {
    try {
      dynamic query = client.from(tableName).update(payload);
      query = _applyTenantQueryScope(query, tableName, scope);
      query = _applyRecordIdentityFilter(query, identityPayload);
      await query;
    } on PostgrestException catch (error) {
      if (!_isMissingUpdatedAtColumnError(error, tableName) || !_containsUpdatedAtField(payload)) {
        rethrow;
      }

      final fallbackPayload = _withoutUpdatedAtField(payload);
      dynamic query = client.from(tableName).update(fallbackPayload);
      query = _applyTenantQueryScope(query, tableName, scope);
      query = _applyRecordIdentityFilter(query, identityPayload);
      await query;
    }
  }

  static bool _isMissingUpdatedAtColumnError(PostgrestException error, String tableName) {
    if (error.code != 'PGRST204') {
      return false;
    }

    final normalizedMessage = error.message.toLowerCase();
    return normalizedMessage.contains("could not find the 'updatedat' column") && normalizedMessage.contains("'$tableName'");
  }

  static bool _containsUpdatedAtField(Map<String, dynamic> payload) {
    return payload.containsKey('updatedAt') || payload.containsKey('updated_at');
  }

  static bool _remoteSupportsUpdatedAt(String tableName) {
    return !_remoteTablesWithoutUpdatedAt.contains(tableName);
  }

  static Map<String, dynamic> _sanitizeRemotePayload({required String tableName, required Map<String, dynamic> payload}) {
    if (_remoteSupportsUpdatedAt(tableName)) {
      return payload;
    }
    return _withoutUpdatedAtField(payload);
  }

  static Map<String, dynamic> _withoutUpdatedAtField(Map<String, dynamic> payload) {
    final sanitizedPayload = Map<String, dynamic>.from(payload);
    sanitizedPayload.remove('updatedAt');
    sanitizedPayload.remove('updated_at');
    return sanitizedPayload;
  }

  static const Set<String> _ownerScopedTables = <String>{
    'store',
    'products',
    'supplier',
    'client',
    'category',
    'tags',
    'roles',
    'pages',
    'permissions',
    'role_permissions',
    'user_permissions',
    'store_invoice',
    'store_payment_voucher',
    'store_return',
    'store_financial_transaction',
    'inventory_movement',
    'owner_account',
    'owner_user_membership',
    'owner_permission_scope',
    'purchase_order',
    'supplier_invoice',
    'inventory_batch',
    'inventory_transaction',
    'transfer_order',
    'sales_order',
    'sales_invoice',
    'sales_return',
    'branch_price',
    'promotion_rule',
    'staff_shift',
    'staff_attendance',
    'staff_activity_log',
    'audit_log',
    'sync_conflict_log',
    'external_integration_endpoint',
    'notification_event',
  };

  static const Set<String> _storeScopedTables = <String>{'store_supplier', 'store_client', 'store_user', 'store_branches'};
  static const Set<String> _branchScopedTables = <String>{'branch_product'};
  static const Set<String> _selfScopedTables = <String>{'users'};
  static const Set<String> _hardDeleteTables = <String>{'purchase_order_item', 'transfer_order_item', 'staff_attendance', 'staff_activity_log'};
  static const Set<String> _remoteTablesWithoutUpdatedAt = <String>{'store'};
  static const List<String> _synchronizationOrder = <String>[
    'store',
    'branch',
    'products',
    'category',
    'tags',
    'client',
    'supplier',
    'users',
    'roles',
    'pages',
    'permissions',
    'role_permissions',
    'user_roles',
    'user_permissions',
    'store_supplier',
    'store_client',
    'store_user',
    'store_branches',
    'branch_product',
    'purchase_order',
    'purchase_order_item',
    'supplier_invoice',
    'inventory_batch',
    'inventory_transaction',
    'transfer_order',
    'transfer_order_item',
    'sales_order',
    'store_invoice',
    'store_invoice_item',
    'store_return',
    'store_return_item',
    'store_payment_voucher',
    'payment_allocation',
    'inventory_movement',
    'store_financial_transaction',
    'sales_invoice',
    'sales_return',
    'branch_price',
    'promotion_rule',
    'staff_shift',
    'staff_attendance',
    'staff_activity_log',
  ];

  static Map<String, dynamic> _enforceTenantPayloadScope(String tableName, Map<String, dynamic> payload, OwnerScope scope) {
    final scopedPayload = Map<String, dynamic>.from(payload);

    if (_ownerScopedTables.contains(tableName)) {
      if (!scope.hasOwner) {
        throw StateError('No owner scope available for table $tableName');
      }
      final payloadOwnerUuid = scopedPayload['ownerUuid']?.toString().trim();
      if (payloadOwnerUuid == null || payloadOwnerUuid.isEmpty) {
        scopedPayload['ownerUuid'] = scope.ownerUuid;
      } else if (payloadOwnerUuid != scope.ownerUuid) {
        throw StateError('Owner scope mismatch for table $tableName');
      }
    }

    if (_storeScopedTables.contains(tableName)) {
      final storeUuid = scopedPayload['storeUuid']?.toString().trim();
      if (storeUuid == null || storeUuid.isEmpty || !scope.storeUuids.contains(storeUuid)) {
        throw StateError('Store scope mismatch for table $tableName');
      }
    }

    if (_branchScopedTables.contains(tableName)) {
      final branchUuid = scopedPayload['branchUuid']?.toString().trim();
      if (branchUuid == null || branchUuid.isEmpty || !scope.branchUuids.contains(branchUuid)) {
        throw StateError('Branch scope mismatch for table $tableName');
      }
    }

    if (_selfScopedTables.contains(tableName)) {
      final uuid = scopedPayload['uuid']?.toString().trim();
      if (scope.userUuid != null && uuid != null && uuid.isNotEmpty && uuid != scope.userUuid) {
        throw StateError('Self scope mismatch for table $tableName');
      }
    }

    return scopedPayload;
  }

  static dynamic _applyTenantQueryScope(dynamic query, String tableName, OwnerScope scope) {
    dynamic scopedQuery = query;

    if (_ownerScopedTables.contains(tableName)) {
      if (!scope.hasOwner) {
        throw StateError('No owner scope available for table $tableName');
      }
      scopedQuery = scopedQuery.eq('ownerUuid', scope.ownerUuid);
    }

    if (_storeScopedTables.contains(tableName)) {
      if (scope.storeUuids.isEmpty) {
        throw StateError('No store scope available for table $tableName');
      }
      scopedQuery = scopedQuery.inFilter('storeUuid', scope.storeUuids.toList(growable: false));
    }

    if (_branchScopedTables.contains(tableName)) {
      if (scope.branchUuids.isEmpty) {
        throw StateError('No branch scope available for table $tableName');
      }
      scopedQuery = scopedQuery.inFilter('branchUuid', scope.branchUuids.toList(growable: false));
    }

    if (_selfScopedTables.contains(tableName)) {
      if (scope.userUuid == null || scope.userUuid!.isEmpty) {
        throw StateError('No user scope available for table $tableName');
      }
      scopedQuery = scopedQuery.eq('uuid', scope.userUuid);
    }

    return scopedQuery;
  }

  static String _recordUuidFromPayload(Map<String, dynamic> payload, {required String fallback}) {
    final uuid = payload['uuid']?.toString().trim();
    if (uuid != null && uuid.isNotEmpty) {
      return uuid;
    }
    final id = payload['id']?.toString().trim();
    if (id != null && id.isNotEmpty) {
      return id;
    }
    return fallback;
  }

  static int _updatedAtMillisFromPayload(Map<String, dynamic> payload, {required int fallback}) {
    final value = payload['updatedAt'] ?? payload['updated_at'];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      final parsedInt = int.tryParse(value);
      if (parsedInt != null) {
        return parsedInt;
      }
      final parsedDateTime = DateTime.tryParse(value);
      if (parsedDateTime != null) {
        return parsedDateTime.toUtc().millisecondsSinceEpoch;
      }
    }
    return fallback;
  }

  static Object? _rewritePayloadValue(Object? value, {required String oldUuid, required String newUuid}) {
    if (value is String) {
      return value == oldUuid ? newUuid : value;
    }
    if (value is List) {
      return value.map((entry) => _rewritePayloadValue(entry, oldUuid: oldUuid, newUuid: newUuid)).toList(growable: false);
    }
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map(
          (entry) => MapEntry(entry.key.toString(), _rewritePayloadValue(entry.value, oldUuid: oldUuid, newUuid: newUuid)),
        ),
      );
    }
    return value;
  }

  static Decimal _decimalOrZero(Object? value) {
    if (value is Decimal) {
      return value;
    }
    if (value is num) {
      return Decimal.parse(value.toString());
    }
    final normalized = value?.toString().trim();
    if (normalized == null || normalized.isEmpty) {
      return Decimal.zero;
    }
    return Decimal.tryParse(normalized) ?? Decimal.zero;
  }
}

class _LocalDatabaseSyncResult {
  const _LocalDatabaseSyncResult({required this.pushedCount, required this.pulledCount});

  final int pushedCount;
  final int pulledCount;
}