import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:store_management/services/owner_scope_service.dart';

enum BatchSelectionStrategy { fifo, fefo }

class InventoryAllocationLot {
  const InventoryAllocationLot({required this.batchUuid, required this.quantity, required this.unitCost, this.expiryDate});

  final String batchUuid;
  final int quantity;
  final num unitCost;
  final DateTime? expiryDate;
}

class InventoryAllocationResult {
  const InventoryAllocationResult({required this.lots, required this.requestedQuantity, required this.allocatedQuantity});

  final List<InventoryAllocationLot> lots;
  final int requestedQuantity;
  final int allocatedQuantity;

  int get remainingQuantity => requestedQuantity - allocatedQuantity;
  bool get isFullyAllocated => remainingQuantity <= 0;
}

class InventoryTransactionService {
  InventoryTransactionService({SupabaseClient? client, OwnerScopeService? ownerScopeService})
      : _client = client ?? Supabase.instance.client,
        _ownerScopeService = ownerScopeService ?? OwnerScopeService(client: client);

  final SupabaseClient _client;
  final OwnerScopeService _ownerScopeService;

  Future<InventoryAllocationResult> allocateBatchesForSale({
    required String ownerUuid,
    required String branchUuid,
    required String productUuid,
    required int quantity,
    BatchSelectionStrategy strategy = BatchSelectionStrategy.fifo,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Quantity must be greater than zero.');
    }

    final scope = await _ownerScopeService.resolveCurrentScope();
    _ensureOwnerAccess(scope, ownerUuid);

    final balanceRowsDynamic = await _client
        .from('v_inventory_balance')
        .select('batchUuid,quantity')
        .eq('ownerUuid', ownerUuid)
        .eq('holderType', 'branch')
        .eq('holderUuid', branchUuid)
        .eq('productUuid', productUuid);

    final balanceRows = (balanceRowsDynamic as List<dynamic>).cast<Map<String, dynamic>>();
    final positiveBalanceByBatch = <String, int>{};
    for (final row in balanceRows) {
      final batchUuid = row['batchUuid']?.toString();
      final qty = (row['quantity'] as num?)?.toInt() ?? 0;
      if (batchUuid == null || batchUuid.isEmpty || qty <= 0) {
        continue;
      }
      positiveBalanceByBatch[batchUuid] = qty;
    }

    if (positiveBalanceByBatch.isEmpty) {
      return InventoryAllocationResult(lots: const <InventoryAllocationLot>[], requestedQuantity: quantity, allocatedQuantity: 0);
    }

    final batchRowsDynamic = await _client
        .from('inventory_batch')
        .select('uuid,unitCost,expiryDate,receivedAt,remainingQuantity')
        .eq('ownerUuid', ownerUuid)
        .eq('productUuid', productUuid)
        .isFilter('deletedAt', null)
        .inFilter('uuid', positiveBalanceByBatch.keys.toList(growable: false));

    final batchRows = (batchRowsDynamic as List<dynamic>).cast<Map<String, dynamic>>();

    batchRows.sort((a, b) {
      if (strategy == BatchSelectionStrategy.fefo) {
        final leftExpiry = (a['expiryDate'] as num?)?.toInt();
        final rightExpiry = (b['expiryDate'] as num?)?.toInt();
        final leftSafe = leftExpiry ?? 253402300799000;
        final rightSafe = rightExpiry ?? 253402300799000;
        if (leftSafe != rightSafe) {
          return leftSafe.compareTo(rightSafe);
        }
      }

      final leftReceivedAt = (a['receivedAt'] as num?)?.toInt() ?? 0;
      final rightReceivedAt = (b['receivedAt'] as num?)?.toInt() ?? 0;
      return leftReceivedAt.compareTo(rightReceivedAt);
    });

    var remaining = quantity;
    final lots = <InventoryAllocationLot>[];

    for (final batch in batchRows) {
      if (remaining <= 0) {
        break;
      }

      final batchUuid = batch['uuid']?.toString();
      if (batchUuid == null || batchUuid.isEmpty) {
        continue;
      }

      final available = positiveBalanceByBatch[batchUuid] ?? 0;
      if (available <= 0) {
        continue;
      }

      final allocated = available >= remaining ? remaining : available;
      final unitCost = (batch['unitCost'] as num?) ?? 0;
      final expiryMillis = (batch['expiryDate'] as num?)?.toInt();
      lots.add(InventoryAllocationLot(
        batchUuid: batchUuid,
        quantity: allocated,
        unitCost: unitCost,
        expiryDate: expiryMillis == null ? null : DateTime.fromMillisecondsSinceEpoch(expiryMillis),
      ));
      remaining -= allocated;
    }

    final allocatedQuantity = lots.fold<int>(0, (sum, lot) => sum + lot.quantity);
    return InventoryAllocationResult(lots: lots, requestedQuantity: quantity, allocatedQuantity: allocatedQuantity);
  }

  Future<void> postSaleTransactions({
    required String ownerUuid,
    required String branchUuid,
    required String productUuid,
    required String salesInvoiceUuid,
    required int quantity,
    required num unitPrice,
    BatchSelectionStrategy strategy = BatchSelectionStrategy.fifo,
    String? staffUserUuid,
  }) async {
    final allocation = await allocateBatchesForSale(
      ownerUuid: ownerUuid,
      branchUuid: branchUuid,
      productUuid: productUuid,
      quantity: quantity,
      strategy: strategy,
    );

    if (!allocation.isFullyAllocated) {
      throw StateError('Insufficient stock for product $productUuid in branch $branchUuid. Requested $quantity, allocated ${allocation.allocatedQuantity}.');
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final txRows = allocation.lots
        .map(
          (lot) => <String, dynamic>{
            'ownerUuid': ownerUuid,
            'productUuid': productUuid,
            'batchUuid': lot.batchUuid,
            'holderType': 'branch',
            'holderUuid': branchUuid,
            'transactionType': 'sale',
            'quantity': -lot.quantity,
            'unitCost': lot.unitCost,
            'unitPrice': unitPrice,
            'referenceType': 'sales_invoice',
            'referenceUuid': salesInvoiceUuid,
            'staffUserUuid': staffUserUuid,
            'occurredAt': now,
            'note': strategy == BatchSelectionStrategy.fefo ? 'Auto allocation FEFO' : 'Auto allocation FIFO',
          },
        )
        .toList(growable: false);

    if (txRows.isNotEmpty) {
      await _client.from('inventory_transaction').insert(txRows);
    }
  }

  Future<void> postTransferTransactions({
    required String ownerUuid,
    required String transferOrderUuid,
    required String sourceBranchUuid,
    required String destinationBranchUuid,
    required String productUuid,
    required List<InventoryAllocationLot> lots,
    String? staffUserUuid,
  }) async {
    final scope = await _ownerScopeService.resolveCurrentScope();
    _ensureOwnerAccess(scope, ownerUuid);

    if (lots.isEmpty) {
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = <Map<String, dynamic>>[];

    for (final lot in lots) {
      rows.add(<String, dynamic>{
        'ownerUuid': ownerUuid,
        'productUuid': productUuid,
        'batchUuid': lot.batchUuid,
        'holderType': 'branch',
        'holderUuid': sourceBranchUuid,
        'transactionType': 'transfer_out',
        'quantity': -lot.quantity,
        'unitCost': lot.unitCost,
        'referenceType': 'transfer_order',
        'referenceUuid': transferOrderUuid,
        'staffUserUuid': staffUserUuid,
        'occurredAt': now,
        'note': 'Stock transfer out',
      });

      rows.add(<String, dynamic>{
        'ownerUuid': ownerUuid,
        'productUuid': productUuid,
        'batchUuid': lot.batchUuid,
        'holderType': 'branch',
        'holderUuid': destinationBranchUuid,
        'transactionType': 'transfer_in',
        'quantity': lot.quantity,
        'unitCost': lot.unitCost,
        'referenceType': 'transfer_order',
        'referenceUuid': transferOrderUuid,
        'staffUserUuid': staffUserUuid,
        'occurredAt': now,
        'note': 'Stock transfer in',
      });
    }

    await _client.from('inventory_transaction').insert(rows);
  }

  Future<String> postPurchaseReceipt({
    required String ownerUuid,
    required String storeUuid,
    required String branchUuid,
    required String supplierUuid,
    required String productUuid,
    required String supplierInvoiceUuid,
    String? batchNumber,
    DateTime? expiryDate,
    required int quantity,
    required num unitCost,
    String? staffUserUuid,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Quantity must be greater than zero.');
    }

    final scope = await _ownerScopeService.resolveCurrentScope();
    _ensureOwnerAccess(scope, ownerUuid);

    final now = DateTime.now().millisecondsSinceEpoch;
    final batchPayload = <String, dynamic>{
      'ownerUuid': ownerUuid,
      'storeUuid': storeUuid,
      'supplierUuid': supplierUuid,
      'productUuid': productUuid,
      'supplierInvoiceUuid': supplierInvoiceUuid,
      'batchNumber': batchNumber,
      'receivedAt': now,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'unitCost': unitCost,
      'initialQuantity': quantity,
      'remainingQuantity': quantity,
      'status': 1,
    }..removeWhere((key, value) => value == null);

    final insertedBatch = await _client.from('inventory_batch').insert(batchPayload).select('uuid').single();
    final batchUuid = insertedBatch['uuid']?.toString();
    if (batchUuid == null || batchUuid.isEmpty) {
      throw StateError('Failed to create inventory batch.');
    }

    await _client.from('inventory_transaction').insert(<String, dynamic>{
      'ownerUuid': ownerUuid,
      'productUuid': productUuid,
      'batchUuid': batchUuid,
      'holderType': 'branch',
      'holderUuid': branchUuid,
      'transactionType': 'purchase',
      'quantity': quantity,
      'unitCost': unitCost,
      'referenceType': 'supplier_invoice',
      'referenceUuid': supplierInvoiceUuid,
      'staffUserUuid': staffUserUuid,
      'occurredAt': now,
      'note': 'Purchase receipt',
    }..removeWhere((key, value) => value == null));

    return batchUuid;
  }

  void _ensureOwnerAccess(OwnerScope scope, String ownerUuid) {
    if (!scope.hasOwner || scope.ownerUuid != ownerUuid) {
      throw StateError('Access denied for owner scope.');
    }
  }
}
