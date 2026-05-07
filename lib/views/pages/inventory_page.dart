import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/inventory_movement.dart';
import 'package:store_management/models/inventory_batch.dart';
import 'package:store_management/models/inventory_transaction.dart';
import 'package:store_management/models/branch_price.dart';
import 'package:store_management/models/purchase_order.dart';
import 'package:store_management/models/purchase_order_item.dart';
import 'package:store_management/models/promotion_rule.dart';
import 'package:store_management/models/sales_invoice.dart';
import 'package:store_management/models/sales_order.dart';
import 'package:store_management/models/sales_return.dart';
import 'package:store_management/models/staff_activity_log.dart';
import 'package:store_management/models/staff_attendance.dart';
import 'package:store_management/models/staff_shift.dart';
import 'package:store_management/models/supplier_invoice.dart';
import 'package:store_management/models/transfer_order.dart';
import 'package:store_management/models/transfer_order_item.dart';
import 'package:store_management/services/inventory_transaction_service.dart';
import 'package:store_management/services/owner_scope_service.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

typedef PurchaseReceiptPoster =
    Future<String> Function({
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
    });

class InventoryPage extends StatefulWidget {
  const InventoryPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.highlights = const <String>[],
    this.inventoryTransactionService,
    this.ownerScopeService,
    this.purchaseReceiptPoster,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;
  final InventoryTransactionService? inventoryTransactionService;
  final OwnerScopeService? ownerScopeService;
  final PurchaseReceiptPoster? purchaseReceiptPoster;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ownerUuidController;
  late final TextEditingController _storeUuidController;
  late final TextEditingController _branchUuidController;
  late final TextEditingController _supplierUuidController;
  late final TextEditingController _supplierInvoiceUuidController;
  late final TextEditingController _productUuidController;
  late final TextEditingController _batchNumberController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitCostController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _staffUserUuidController;

  InventoryTransactionService? _inventoryTransactionService;
  OwnerScopeService? _ownerScopeService;
  bool _postingReceipt = false;

  @override
  void initState() {
    super.initState();
    _ownerUuidController = TextEditingController();
    _storeUuidController = TextEditingController();
    _branchUuidController = TextEditingController();
    _supplierUuidController = TextEditingController();
    _supplierInvoiceUuidController = TextEditingController();
    _productUuidController = TextEditingController();
    _batchNumberController = TextEditingController(text: 'BATCH-${DateTime.now().millisecondsSinceEpoch}');
    _quantityController = TextEditingController(text: '1');
    _unitCostController = TextEditingController();
    _expiryDateController = TextEditingController();
    _staffUserUuidController = TextEditingController();

    _inventoryTransactionService = widget.inventoryTransactionService;
    _ownerScopeService = widget.ownerScopeService;
    _prefillOwnerFromScope();
  }

  @override
  void dispose() {
    _ownerUuidController.dispose();
    _storeUuidController.dispose();
    _branchUuidController.dispose();
    _supplierUuidController.dispose();
    _supplierInvoiceUuidController.dispose();
    _productUuidController.dispose();
    _batchNumberController.dispose();
    _quantityController.dispose();
    _unitCostController.dispose();
    _expiryDateController.dispose();
    _staffUserUuidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 16,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: TabBar(
              isScrollable: true,
              tabs: const [
                Tab(text: 'Movements'),
                Tab(text: 'Purchase Orders'),
                Tab(text: 'Order Items'),
                Tab(text: 'Supplier Invoices'),
                Tab(text: 'Batches'),
                Tab(text: 'Transactions'),
                Tab(text: 'Transfer Orders'),
                Tab(text: 'Transfer Items'),
                Tab(text: 'Sales Orders'),
                Tab(text: 'Sales Invoices'),
                Tab(text: 'Sales Returns'),
                Tab(text: 'Branch Prices'),
                Tab(text: 'Promotions'),
                Tab(text: 'Staff Shifts'),
                Tab(text: 'Attendance'),
                Tab(text: 'Activity Logs'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Column(
                  children: [
                    Padding(padding: const EdgeInsets.fromLTRB(24, 24, 24, 0), child: _buildPurchaseReceiptCard(context)),
                    Expanded(
                      child: ModelCrudPage<InventoryMovement>(
                        title: widget.title,
                        entityLabel: inventoryMovementEntityLabel(l10n),
                        description: widget.description,
                        icon: widget.icon,
                        highlights: widget.highlights,
                        formDefinition: inventoryMovementFormDefinition(l10n),
                      ),
                    ),
                  ],
                ),
                ModelCrudPage<PurchaseOrder>(
                  title: 'Purchase Orders',
                  entityLabel: purchaseOrderEntityLabel(l10n),
                  description: 'Manage purchase orders and procurement lifecycle records.',
                  icon: Icons.shopping_cart_checkout_rounded,
                  highlights: const ['Procurement', 'Approval flow', 'Expected delivery'],
                  formDefinition: purchaseOrderFormDefinition(l10n),
                ),
                ModelCrudPage<PurchaseOrderItem>(
                  title: 'Purchase Order Items',
                  entityLabel: purchaseOrderItemEntityLabel(l10n),
                  description: 'Manage line items for purchase orders and received quantities.',
                  icon: Icons.playlist_add_check_circle_rounded,
                  highlights: const ['Line totals', 'Received quantity', 'Offer linkage'],
                  formDefinition: purchaseOrderItemFormDefinition(l10n),
                ),
                ModelCrudPage<SupplierInvoice>(
                  title: 'Supplier Invoices',
                  entityLabel: supplierInvoiceEntityLabel(l10n),
                  description: 'Manage supplier invoices and payment status visibility.',
                  icon: Icons.request_quote_rounded,
                  highlights: const ['Invoice matching', 'Due dates', 'Open balance'],
                  formDefinition: supplierInvoiceFormDefinition(l10n),
                ),
                ModelCrudPage<InventoryBatch>(
                  title: 'Inventory Batches',
                  entityLabel: inventoryBatchEntityLabel(l10n),
                  description: 'Track item batches and their remaining quantities.',
                  icon: Icons.layers_rounded,
                  highlights: const ['Batch life-cycle', 'Expiry tracking', 'Cost layers'],
                  formDefinition: inventoryBatchFormDefinition(l10n),
                ),
                ModelCrudPage<InventoryTransaction>(
                  title: 'Inventory Transactions',
                  entityLabel: inventoryTransactionEntityLabel(l10n),
                  description: 'Track detailed inventory ledger entries and references.',
                  icon: Icons.receipt_long_rounded,
                  highlights: const ['Ledger entries', 'Reference linking', 'Holder movements'],
                  formDefinition: inventoryTransactionFormDefinition(l10n),
                ),
                ModelCrudPage<TransferOrder>(
                  title: 'Transfer Orders',
                  entityLabel: transferOrderEntityLabel(l10n),
                  description: 'Manage inter-branch stock transfer requests and lifecycle.',
                  icon: Icons.compare_arrows_rounded,
                  highlights: const ['Source to destination', 'Transfer status', 'Requested and received tracking'],
                  formDefinition: transferOrderFormDefinition(l10n),
                ),
                ModelCrudPage<TransferOrderItem>(
                  title: 'Transfer Order Items',
                  entityLabel: transferOrderItemEntityLabel(l10n),
                  description: 'Manage transfer order line items and shipped/received quantities.',
                  icon: Icons.format_list_numbered_rounded,
                  highlights: const ['Line quantities', 'Shipping progress', 'Receiving progress'],
                  formDefinition: transferOrderItemFormDefinition(l10n),
                ),
                ModelCrudPage<SalesOrder>(
                  title: 'Sales Orders',
                  entityLabel: salesOrderEntityLabel(l10n),
                  description: 'Manage customer sales orders and pricing strategy decisions.',
                  icon: Icons.shopping_bag_rounded,
                  highlights: const ['Order pipeline', 'Pricing strategy', 'Customer linkage'],
                  formDefinition: salesOrderFormDefinition(l10n),
                ),
                ModelCrudPage<SalesInvoice>(
                  title: 'Sales Invoices',
                  entityLabel: salesInvoiceEntityLabel(l10n),
                  description: 'Manage sales invoices, totals, and payment progress.',
                  icon: Icons.receipt_rounded,
                  highlights: const ['Invoice lifecycle', 'Outstanding balances', 'Payment status'],
                  formDefinition: salesInvoiceFormDefinition(l10n),
                ),
                ModelCrudPage<SalesReturn>(
                  title: 'Sales Returns',
                  entityLabel: salesReturnEntityLabel(l10n),
                  description: 'Track sales returns, reasons, and refund processing.',
                  icon: Icons.assignment_return_rounded,
                  highlights: const ['Return reason', 'Refund amount', 'Approval status'],
                  formDefinition: salesReturnFormDefinition(l10n),
                ),
                ModelCrudPage<BranchPrice>(
                  title: 'Branch Prices',
                  entityLabel: branchPriceEntityLabel(l10n),
                  description: 'Configure branch-level product prices and validity windows.',
                  icon: Icons.price_change_rounded,
                  highlights: const ['Price tiers', 'Effective dates', 'Priority handling'],
                  formDefinition: branchPriceFormDefinition(l10n),
                ),
                ModelCrudPage<PromotionRule>(
                  title: 'Promotion Rules',
                  entityLabel: promotionRuleEntityLabel(l10n),
                  description: 'Define discount promotions per branch or product scope.',
                  icon: Icons.local_offer_rounded,
                  highlights: const ['Discount rules', 'Date windows', 'Scope targeting'],
                  formDefinition: promotionRuleFormDefinition(l10n),
                ),
                ModelCrudPage<StaffShift>(
                  title: 'Staff Shifts',
                  entityLabel: staffShiftEntityLabel(l10n),
                  description: 'Plan and track employee shift schedules and completion.',
                  icon: Icons.badge_rounded,
                  highlights: const ['Scheduling', 'Coverage', 'Shift status'],
                  formDefinition: staffShiftFormDefinition(l10n),
                ),
                ModelCrudPage<StaffAttendance>(
                  title: 'Staff Attendance',
                  entityLabel: staffAttendanceEntityLabel(l10n),
                  description: 'Track check-ins, check-outs, and worked minutes.',
                  icon: Icons.fact_check_rounded,
                  highlights: const ['Presence records', 'Time worked', 'Attendance status'],
                  formDefinition: staffAttendanceFormDefinition(l10n),
                ),
                ModelCrudPage<StaffActivityLog>(
                  title: 'Staff Activity Logs',
                  entityLabel: staffActivityLogEntityLabel(l10n),
                  description: 'Audit user actions across operational entities.',
                  icon: Icons.history_rounded,
                  highlights: const ['Action traceability', 'Entity references', 'Metadata logs'],
                  formDefinition: staffActivityLogFormDefinition(l10n),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseReceiptCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Purchase receiving', style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text('Create inventory batch and post purchase receipt in one action.', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _field(_ownerUuidController, 'Owner UUID', fieldKey: 'ownerUuid', required: true),
                  _field(_storeUuidController, 'Store UUID', fieldKey: 'storeUuid', required: true),
                  _field(_branchUuidController, 'Branch UUID', fieldKey: 'branchUuid', required: true),
                  _field(_supplierUuidController, 'Supplier UUID', fieldKey: 'supplierUuid', required: true),
                  _field(_supplierInvoiceUuidController, 'Supplier invoice UUID', fieldKey: 'supplierInvoiceUuid', required: true),
                  _field(_productUuidController, 'Product UUID', fieldKey: 'productUuid', required: true),
                  _field(_batchNumberController, 'Batch number', fieldKey: 'batchNumber'),
                  _field(_quantityController, 'Quantity', fieldKey: 'quantity', required: true, isNumber: true),
                  _field(_unitCostController, 'Unit cost', fieldKey: 'unitCost', required: true, isNumber: true),
                  _field(_expiryDateController, 'Expiry date (YYYY-MM-DD)', fieldKey: 'expiryDate'),
                  _field(_staffUserUuidController, 'Staff user UUID', fieldKey: 'staffUserUuid'),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                key: const Key('purchase-receipt-submit'),
                onPressed: _postingReceipt ? null : _submitPurchaseReceipt,
                icon: _postingReceipt ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.inventory_2_rounded),
                label: Text(_postingReceipt ? 'Posting...' : 'Post purchase receipt'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {String? fieldKey, bool required = false, bool isNumber = false}) {
    return SizedBox(
      width: 260,
      child: TextFormField(
        key: fieldKey == null ? null : Key('purchase-receipt-$fieldKey'),
        controller: controller,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }
          if (isNumber && value != null && value.trim().isNotEmpty && num.tryParse(value.trim()) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _prefillOwnerFromScope() async {
    final ownerScopeService = _ownerScopeService;
    if (ownerScopeService == null) {
      return;
    }

    try {
      final scope = await ownerScopeService.resolveCurrentScope();
      if (!mounted || !scope.hasOwner) {
        return;
      }
      _ownerUuidController.text = scope.ownerUuid!;
    } catch (_) {
      // Best-effort prefill only; UI remains usable with manual owner UUID.
    }
  }

  Future<void> _submitPurchaseReceipt() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final quantity = int.tryParse(_quantityController.text.trim());
    final unitCost = num.tryParse(_unitCostController.text.trim());
    if (quantity == null || quantity <= 0 || unitCost == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity and unit cost must be valid positive numbers.')),
      );
      return;
    }

    DateTime? expiryDate;
    final expiryRaw = _expiryDateController.text.trim();
    if (expiryRaw.isNotEmpty) {
      try {
        expiryDate = DateTime.parse(expiryRaw);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expiry date must use YYYY-MM-DD format.')));
        return;
      }
    }

    setState(() {
      _postingReceipt = true;
    });

    try {
      final postPurchaseReceipt =
          widget.purchaseReceiptPoster ??
          ({
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
          }) {
            final inventoryTransactionService = _inventoryTransactionService ?? InventoryTransactionService();
            return inventoryTransactionService.postPurchaseReceipt(
              ownerUuid: ownerUuid,
              storeUuid: storeUuid,
              branchUuid: branchUuid,
              supplierUuid: supplierUuid,
              productUuid: productUuid,
              supplierInvoiceUuid: supplierInvoiceUuid,
              batchNumber: batchNumber,
              expiryDate: expiryDate,
              quantity: quantity,
              unitCost: unitCost,
              staffUserUuid: staffUserUuid,
            );
          };

      final batchUuid = await postPurchaseReceipt(
        ownerUuid: _ownerUuidController.text.trim(),
        storeUuid: _storeUuidController.text.trim(),
        branchUuid: _branchUuidController.text.trim(),
        supplierUuid: _supplierUuidController.text.trim(),
        productUuid: _productUuidController.text.trim(),
        supplierInvoiceUuid: _supplierInvoiceUuidController.text.trim(),
        batchNumber: _batchNumberController.text.trim().isEmpty ? null : _batchNumberController.text.trim(),
        expiryDate: expiryDate,
        quantity: quantity,
        unitCost: unitCost,
        staffUserUuid: _staffUserUuidController.text.trim().isEmpty ? null : _staffUserUuidController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase receipt posted. Batch: $batchUuid')));
      _batchNumberController.text = 'BATCH-${DateTime.now().millisecondsSinceEpoch}';
      _quantityController.text = '1';
      _unitCostController.clear();
      _expiryDateController.clear();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to post purchase receipt: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _postingReceipt = false;
        });
      }
    }
  }
}
