import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/inventory_movement.dart';
import 'package:store_management/models/access_page.dart';
import 'package:store_management/models/access_permission.dart';
import 'package:store_management/models/inventory_batch.dart';
import 'package:store_management/models/inventory_transaction.dart';
import 'package:store_management/models/branch_product.dart';
import 'package:store_management/models/branch_price.dart';
import 'package:store_management/models/payment_allocation.dart';
import 'package:store_management/models/purchase_order.dart';
import 'package:store_management/models/purchase_order_item.dart';
import 'package:store_management/models/promotion_rule.dart';
import 'package:store_management/models/role_permission.dart';
import 'package:store_management/models/sales_invoice.dart';
import 'package:store_management/models/sales_order.dart';
import 'package:store_management/models/sales_return.dart';
import 'package:store_management/models/staff_activity_log.dart';
import 'package:store_management/models/staff_attendance.dart';
import 'package:store_management/models/staff_shift.dart';
import 'package:store_management/models/store_branches.dart';
import 'package:store_management/models/store_client.dart';
import 'package:store_management/models/store_invoice_item.dart';
import 'package:store_management/models/store_return_item.dart';
import 'package:store_management/models/store_supplier.dart';
import 'package:store_management/models/store_user.dart';
import 'package:store_management/models/supplier_invoice.dart';
import 'package:store_management/models/transfer_order.dart';
import 'package:store_management/models/transfer_order_item.dart';
import 'package:store_management/models/user_permission.dart';
import 'package:store_management/models/user_roles.dart';
import 'package:store_management/services/access_control_service.dart';
import 'package:store_management/services/inventory_transaction_service.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/owner_scope_service.dart';
import 'package:store_management/views/components/app_notification.dart';
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
    this.accessSnapshot,
    this.aclUnavailable,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;
  final InventoryTransactionService? inventoryTransactionService;
  final OwnerScopeService? ownerScopeService;
  final PurchaseReceiptPoster? purchaseReceiptPoster;
  final AccessControlSnapshot? accessSnapshot;
  final bool? aclUnavailable;

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
  _InventorySection _activeSection = _InventorySection.operations;
  _InventoryRelationsGroup _activeRelationsGroup = _InventoryRelationsGroup.access;

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
    final visibleSections = _visibleSections(l10n);
    final activeSection = visibleSections.contains(_activeSection) ? _activeSection : (visibleSections.isEmpty ? null : visibleSections.first);

    return Column(
      children: [
        _buildSectionSelector(context, visibleSections: visibleSections, activeSection: activeSection),
        const SizedBox(height: 8),
        Expanded(child: _buildSectionContent(context, l10n, activeSection: activeSection)),
      ],
    );
  }

  Widget _buildSectionSelector(BuildContext context, {required List<_InventorySection> visibleSections, required _InventorySection? activeSection}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (visibleSections.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final section in visibleSections)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                avatar: Icon(_sectionIcon(section), size: 18),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_sectionLabel(section)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: activeSection == section ? colorScheme.onPrimary.withValues(alpha: 0.18) : colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)),
                      child: Text('${_sectionCount(section)}', style: theme.textTheme.labelSmall),
                    ),
                  ],
                ),
                selected: activeSection == section,
                onSelected: (_) {
                  if (_activeSection != section) {
                    setState(() => _activeSection = section);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, AppLocalizations l10n, {required _InventorySection? activeSection}) {
    if (activeSection == null) {
      return _buildUnavailableSectionCard(context);
    }

    switch (activeSection) {
      case _InventorySection.operations:
        return _buildSectionFromModules(context, _modulesForSection(l10n, _InventorySection.operations));
      case _InventorySection.procurement:
        return _buildSectionFromModules(context, _modulesForSection(l10n, _InventorySection.procurement));
      case _InventorySection.transfer:
        return _buildSectionFromModules(context, _modulesForSection(l10n, _InventorySection.transfer));
      case _InventorySection.sales:
        return _buildSectionFromModules(context, _modulesForSection(l10n, _InventorySection.sales));
      case _InventorySection.pricing:
        return _buildSectionFromModules(context, _modulesForSection(l10n, _InventorySection.pricing));
      case _InventorySection.workforce:
        return _buildSectionFromModules(context, _modulesForSection(l10n, _InventorySection.workforce));
      case _InventorySection.relations:
        return _buildRelationsSection(l10n);
    }
  }

  Widget _buildRelationsSection(AppLocalizations l10n) {
    final visibleGroups = _visibleRelationGroups(l10n);
    final activeGroup = visibleGroups.contains(_activeRelationsGroup) ? _activeRelationsGroup : (visibleGroups.isEmpty ? null : visibleGroups.first);

    if (activeGroup == null) {
      return _buildUnavailableSectionCard(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _buildRelationsGroupSelector(groups: visibleGroups, activeGroup: activeGroup),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildSectionFromModules(context, _modulesForRelationGroup(l10n, activeGroup), tabBarKey: const Key('inventory-relations-tabbar'))),
      ],
    );
  }

  Widget _buildRelationsGroupSelector({required List<_InventoryRelationsGroup> groups, required _InventoryRelationsGroup activeGroup}) {
    return SingleChildScrollView(
      key: const Key('inventory-relations-groups'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final group in groups)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: Key('inventory-relations-group-${group.name}'),
                avatar: Icon(_relationsGroupIcon(group), size: 18),
                label: Text(_relationsGroupLabel(group)),
                selected: activeGroup == group,
                onSelected: (_) {
                  if (_activeRelationsGroup != group) {
                    setState(() {
                      _activeRelationsGroup = group;
                    });
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  String _relationsGroupLabel(_InventoryRelationsGroup group) {
    switch (group) {
      case _InventoryRelationsGroup.access:
        return 'Access';
      case _InventoryRelationsGroup.partners:
        return 'Partners';
      case _InventoryRelationsGroup.structure:
        return 'Structure';
      case _InventoryRelationsGroup.financials:
        return 'Financial Lines';
    }
  }

  IconData _relationsGroupIcon(_InventoryRelationsGroup group) {
    switch (group) {
      case _InventoryRelationsGroup.access:
        return Icons.admin_panel_settings_rounded;
      case _InventoryRelationsGroup.partners:
        return Icons.handshake_rounded;
      case _InventoryRelationsGroup.structure:
        return Icons.account_tree_rounded;
      case _InventoryRelationsGroup.financials:
        return Icons.request_quote_rounded;
    }
  }

  Widget _buildSectionTabs({required List<Tab> tabs, required List<Widget> children, Key? tabBarKey}) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: TabBar(key: tabBarKey, isScrollable: true, tabs: tabs),
          ),
          Expanded(child: TabBarView(children: children)),
        ],
      ),
    );
  }

  String _sectionLabel(_InventorySection section) {
    switch (section) {
      case _InventorySection.operations:
        return 'Operations';
      case _InventorySection.procurement:
        return 'Procurement';
      case _InventorySection.transfer:
        return 'Transfer';
      case _InventorySection.sales:
        return 'Sales';
      case _InventorySection.pricing:
        return 'Pricing';
      case _InventorySection.workforce:
        return 'Workforce';
      case _InventorySection.relations:
        return 'Relations';
    }
  }

  IconData _sectionIcon(_InventorySection section) {
    switch (section) {
      case _InventorySection.operations:
        return Icons.inventory_2_rounded;
      case _InventorySection.procurement:
        return Icons.local_shipping_rounded;
      case _InventorySection.transfer:
        return Icons.compare_arrows_rounded;
      case _InventorySection.sales:
        return Icons.point_of_sale_rounded;
      case _InventorySection.pricing:
        return Icons.price_change_rounded;
      case _InventorySection.workforce:
        return Icons.badge_rounded;
      case _InventorySection.relations:
        return Icons.schema_rounded;
    }
  }

  int _sectionCount(_InventorySection section) {
    return _sectionCountForPermissions(context.l10n, section);
  }

  List<_InventorySection> _visibleSections(AppLocalizations l10n) {
    return _InventorySection.values.where((section) => _sectionCountForPermissions(l10n, section) > 0).toList(growable: false);
  }

  int _sectionCountForPermissions(AppLocalizations l10n, _InventorySection section) {
    if (section == _InventorySection.relations) {
      return _visibleRelationGroups(l10n).fold<int>(0, (count, group) => count + _modulesForRelationGroup(l10n, group).where((module) => _canReadTable(module.tableName)).length);
    }

    return _modulesForSection(l10n, section).where((module) => _canReadTable(module.tableName)).length;
  }

  List<_InventoryRelationsGroup> _visibleRelationGroups(AppLocalizations l10n) {
    return _InventoryRelationsGroup.values.where((group) => _modulesForRelationGroup(l10n, group).where((module) => _canReadTable(module.tableName)).isNotEmpty).toList(growable: false);
  }

  Widget _buildSectionFromModules(BuildContext context, List<_InventoryModule> modules, {Key? tabBarKey}) {
    final visibleModules = modules.where((module) => _canReadTable(module.tableName)).toList(growable: false);
    if (visibleModules.isEmpty) {
      return _buildUnavailableSectionCard(context);
    }

    return _buildSectionTabs(
      tabBarKey: tabBarKey,
      tabs: [for (final module in visibleModules) Tab(text: module.label)],
      children: [for (final module in visibleModules) module.child],
    );
  }

  Widget _buildUnavailableSectionCard(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(context.l10n.unauthorizedSectionMessage, style: theme.textTheme.bodyLarge),
          ),
        ),
      ),
    );
  }

  AccessControlSnapshot get _effectiveAccessSnapshot => widget.accessSnapshot ?? AccessControlService.instance.snapshot;

  bool get _isAclUnavailable => widget.aclUnavailable ?? AccessControlService.instance.isSupabaseUnavailable;

  bool _canReadTable(String? tableName) {
    if (_isAclUnavailable) {
      return true;
    }

    final accessSnapshot = _effectiveAccessSnapshot;
    if (accessSnapshot.isLoading || accessSnapshot.lastError != null) {
      return true;
    }

    if (tableName == null || tableName.trim().isEmpty) {
      return true;
    }

    return accessSnapshot.canTableAction(tableName, 'read');
  }

  List<_InventoryModule> _modulesForSection(AppLocalizations l10n, _InventorySection section) {
    String tr(String english, String arabic) => l10n.pick(english, arabic);
    List<String> trList(List<String> english, List<String> arabic) => l10n.isArabic ? arabic : english;

    switch (section) {
      case _InventorySection.operations:
        return [
          _InventoryModule(
            label: tr('Movements', 'الحركات'),
            tableName: 'inventory_movement',
            child: Column(
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
          ),
          _InventoryModule(
            label: tr('Batches', 'الدفعات'),
            tableName: 'inventory_batch',
            child: ModelCrudPage<InventoryBatch>(
              title: tr('Inventory Batches', 'دفعات المخزون'),
              entityLabel: inventoryBatchEntityLabel(l10n),
              description: tr('Track item batches and their remaining quantities.', 'تتبع دفعات الأصناف والكميات المتبقية منها.'),
              icon: Icons.layers_rounded,
              highlights: trList(const ['Batch life-cycle', 'Expiry tracking', 'Cost layers'], const ['دورة حياة الدفعة', 'تتبع الانتهاء', 'طبقات التكلفة']),
              formDefinition: inventoryBatchFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Transactions', 'المعاملات'),
            tableName: 'inventory_transaction',
            child: ModelCrudPage<InventoryTransaction>(
              title: tr('Inventory Transactions', 'معاملات المخزون'),
              entityLabel: inventoryTransactionEntityLabel(l10n),
              description: tr('Track detailed inventory ledger entries and references.', 'تتبع قيود دفتر المخزون التفصيلية والمراجع المرتبطة بها.'),
              icon: Icons.receipt_long_rounded,
              highlights: trList(const ['Ledger entries', 'Reference linking', 'Holder movements'], const ['قيود الدفتر', 'ربط المراجع', 'حركات الحائز']),
              formDefinition: inventoryTransactionFormDefinition(l10n),
            ),
          ),
        ];
      case _InventorySection.procurement:
        return [
          _InventoryModule(
            label: tr('Purchase Orders', 'أوامر الشراء'),
            tableName: 'purchase_order',
            child: ModelCrudPage<PurchaseOrder>(
              title: tr('Purchase Orders', 'أوامر الشراء'),
              entityLabel: purchaseOrderEntityLabel(l10n),
              description: tr('Manage purchase orders and procurement lifecycle records.', 'إدارة أوامر الشراء وسجلات دورة حياة التوريد.'),
              icon: Icons.shopping_cart_checkout_rounded,
              highlights: trList(const ['Procurement', 'Approval flow', 'Expected delivery'], const ['التوريد', 'مسار الموافقة', 'التسليم المتوقع']),
              formDefinition: purchaseOrderFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Order Items', 'عناصر الطلب'),
            tableName: 'purchase_order_item',
            child: ModelCrudPage<PurchaseOrderItem>(
              title: tr('Purchase Order Items', 'عناصر أمر الشراء'),
              entityLabel: purchaseOrderItemEntityLabel(l10n),
              description: tr('Manage line items for purchase orders and received quantities.', 'إدارة عناصر أوامر الشراء والكميات المستلمة.'),
              icon: Icons.playlist_add_check_circle_rounded,
              highlights: trList(const ['Line totals', 'Received quantity', 'Offer linkage'], const ['إجماليات البنود', 'الكمية المستلمة', 'ربط العرض']),
              formDefinition: purchaseOrderItemFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Supplier Invoices', 'فواتير الموردين'),
            tableName: 'supplier_invoice',
            child: ModelCrudPage<SupplierInvoice>(
              title: tr('Supplier Invoices', 'فواتير الموردين'),
              entityLabel: supplierInvoiceEntityLabel(l10n),
              description: tr('Manage supplier invoices and payment status visibility.', 'إدارة فواتير الموردين وإظهار حالة الدفع.'),
              icon: Icons.request_quote_rounded,
              highlights: trList(const ['Invoice matching', 'Due dates', 'Open balance'], const ['مطابقة الفواتير', 'تواريخ الاستحقاق', 'الرصيد المفتوح']),
              formDefinition: supplierInvoiceFormDefinition(l10n),
            ),
          ),
        ];
      case _InventorySection.transfer:
        return [
          _InventoryModule(
            label: tr('Transfer Orders', 'أوامر التحويل'),
            tableName: 'transfer_order',
            child: ModelCrudPage<TransferOrder>(
              title: tr('Transfer Orders', 'أوامر التحويل'),
              entityLabel: transferOrderEntityLabel(l10n),
              description: tr('Manage inter-branch stock transfer requests and lifecycle.', 'إدارة طلبات تحويل المخزون بين الفروع ودورة حياتها.'),
              icon: Icons.compare_arrows_rounded,
              highlights: trList(const ['Source to destination', 'Transfer status', 'Requested and received tracking'], const ['من المصدر إلى الوجهة', 'حالة التحويل', 'تتبع المطلوب والمستلم']),
              formDefinition: transferOrderFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Transfer Items', 'عناصر التحويل'),
            tableName: 'transfer_order_item',
            child: ModelCrudPage<TransferOrderItem>(
              title: tr('Transfer Order Items', 'عناصر أمر التحويل'),
              entityLabel: transferOrderItemEntityLabel(l10n),
              description: tr('Manage transfer order line items and shipped/received quantities.', 'إدارة بنود أوامر التحويل وكميات الشحن والاستلام.'),
              icon: Icons.format_list_numbered_rounded,
              highlights: trList(const ['Line quantities', 'Shipping progress', 'Receiving progress'], const ['كميات البنود', 'تقدم الشحن', 'تقدم الاستلام']),
              formDefinition: transferOrderItemFormDefinition(l10n),
            ),
          ),
        ];
      case _InventorySection.sales:
        return [
          _InventoryModule(
            label: tr('Sales Orders', 'أوامر البيع'),
            tableName: 'sales_order',
            child: ModelCrudPage<SalesOrder>(
              title: tr('Sales Orders', 'أوامر البيع'),
              entityLabel: salesOrderEntityLabel(l10n),
              description: tr('Manage customer sales orders and pricing strategy decisions.', 'إدارة أوامر بيع العملاء وقرارات استراتيجية التسعير.'),
              icon: Icons.shopping_bag_rounded,
              highlights: trList(const ['Order pipeline', 'Pricing strategy', 'Customer linkage'], const ['مسار الطلب', 'استراتيجية التسعير', 'ربط العميل']),
              formDefinition: salesOrderFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Sales Invoices', 'فواتير البيع'),
            tableName: 'sales_invoice',
            child: ModelCrudPage<SalesInvoice>(
              title: tr('Sales Invoices', 'فواتير البيع'),
              entityLabel: salesInvoiceEntityLabel(l10n),
              description: tr('Manage sales invoices, totals, and payment progress.', 'إدارة فواتير البيع والإجماليات وتقدم الدفع.'),
              icon: Icons.receipt_rounded,
              highlights: trList(const ['Invoice lifecycle', 'Outstanding balances', 'Payment status'], const ['دورة حياة الفاتورة', 'الأرصدة المستحقة', 'حالة الدفع']),
              formDefinition: salesInvoiceFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Sales Returns', 'مرتجعات البيع'),
            tableName: 'sales_return',
            child: ModelCrudPage<SalesReturn>(
              title: tr('Sales Returns', 'مرتجعات البيع'),
              entityLabel: salesReturnEntityLabel(l10n),
              description: tr('Track sales returns, reasons, and refund processing.', 'تتبع مرتجعات البيع والأسباب ومعالجة الاسترداد.'),
              icon: Icons.assignment_return_rounded,
              highlights: trList(const ['Return reason', 'Refund amount', 'Approval status'], const ['سبب الإرجاع', 'مبلغ الاسترداد', 'حالة الموافقة']),
              formDefinition: salesReturnFormDefinition(l10n),
            ),
          ),
        ];
      case _InventorySection.pricing:
        return [
          _InventoryModule(
            label: tr('Branch Prices', 'أسعار الفروع'),
            tableName: 'branch_price',
            child: ModelCrudPage<BranchPrice>(
              title: tr('Branch Prices', 'أسعار الفروع'),
              entityLabel: branchPriceEntityLabel(l10n),
              description: tr('Configure branch-level product prices and validity windows.', 'تهيئة أسعار المنتجات على مستوى الفرع وفترات الصلاحية.'),
              icon: Icons.price_change_rounded,
              highlights: trList(const ['Price tiers', 'Effective dates', 'Priority handling'], const ['شرائح الأسعار', 'تواريخ السريان', 'معالجة الأولوية']),
              formDefinition: branchPriceFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Promotions', 'العروض الترويجية'),
            tableName: 'promotion_rule',
            child: ModelCrudPage<PromotionRule>(
              title: tr('Promotion Rules', 'قواعد العروض الترويجية'),
              entityLabel: promotionRuleEntityLabel(l10n),
              description: tr('Define discount promotions per branch or product scope.', 'تحديد العروض والخصومات حسب نطاق الفرع أو المنتج.'),
              icon: Icons.local_offer_rounded,
              highlights: trList(const ['Discount rules', 'Date windows', 'Scope targeting'], const ['قواعد الخصم', 'نوافذ التاريخ', 'استهداف النطاق']),
              formDefinition: promotionRuleFormDefinition(l10n),
            ),
          ),
        ];
      case _InventorySection.workforce:
        return [
          _InventoryModule(
            label: tr('Staff Shifts', 'ورديات الموظفين'),
            tableName: 'staff_shift',
            child: ModelCrudPage<StaffShift>(
              title: tr('Staff Shifts', 'ورديات الموظفين'),
              entityLabel: staffShiftEntityLabel(l10n),
              description: tr('Plan and track employee shift schedules and completion.', 'تخطيط وتتبع جداول ورديات الموظفين وإتمامها.'),
              icon: Icons.badge_rounded,
              highlights: trList(const ['Scheduling', 'Coverage', 'Shift status'], const ['الجدولة', 'التغطية', 'حالة الوردية']),
              formDefinition: staffShiftFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Attendance', 'الحضور'),
            tableName: 'staff_attendance',
            child: ModelCrudPage<StaffAttendance>(
              title: tr('Staff Attendance', 'حضور الموظفين'),
              entityLabel: staffAttendanceEntityLabel(l10n),
              description: tr('Track check-ins, check-outs, and worked minutes.', 'تتبع تسجيلات الدخول والخروج والدقائق المنجزة.'),
              icon: Icons.fact_check_rounded,
              highlights: trList(const ['Presence records', 'Time worked', 'Attendance status'], const ['سجلات الحضور', 'الوقت المنجز', 'حالة الحضور']),
              formDefinition: staffAttendanceFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Activity Logs', 'سجلات النشاط'),
            tableName: 'staff_activity_log',
            child: ModelCrudPage<StaffActivityLog>(
              title: tr('Staff Activity Logs', 'سجلات نشاط الموظفين'),
              entityLabel: staffActivityLogEntityLabel(l10n),
              description: tr('Audit user actions across operational entities.', 'تدقيق إجراءات المستخدمين عبر الكيانات التشغيلية.'),
              icon: Icons.history_rounded,
              highlights: trList(const ['Action traceability', 'Entity references', 'Metadata logs'], const ['تتبع الإجراءات', 'مراجع الكيانات', 'سجلات البيانات الوصفية']),
              formDefinition: staffActivityLogFormDefinition(l10n),
            ),
          ),
        ];
      case _InventorySection.relations:
        return const <_InventoryModule>[];
    }
  }

  List<_InventoryModule> _modulesForRelationGroup(AppLocalizations l10n, _InventoryRelationsGroup group) {
    String tr(String english, String arabic) => l10n.pick(english, arabic);
    List<String> trList(List<String> english, List<String> arabic) => l10n.isArabic ? arabic : english;

    switch (group) {
      case _InventoryRelationsGroup.access:
        return [
          _InventoryModule(
            label: tr('Pages', 'الصفحات'),
            tableName: 'pages',
            child: ModelCrudPage<AccessPage>(
              title: tr('Pages', 'الصفحات'),
              entityLabel: accessPageEntityLabel(l10n),
              description: tr('Define the page catalog that can be shown in menus and route guards.', 'حدد فهرس الصفحات التي يمكن إظهارها في القوائم وحمايات المسارات.'),
              icon: Icons.web_asset_rounded,
              highlights: trList(const ['Page catalog', 'Route mapping', 'Menu visibility'], const ['فهرس الصفحات', 'ربط المسارات', 'إظهار القوائم']),
              formDefinition: accessPageFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Permissions', 'الصلاحيات'),
            tableName: 'permissions',
            child: ModelCrudPage<AccessPermission>(
              title: tr('Permissions', 'الصلاحيات'),
              entityLabel: accessPermissionEntityLabel(l10n),
              description: tr('Register permission keys that roles and users can be granted or denied.', 'سجل مفاتيح الصلاحيات التي يمكن منحها أو منعها للأدوار والمستخدمين.'),
              icon: Icons.key_rounded,
              highlights: trList(const ['Permission keys', 'Action mapping', 'Catalog control'], const ['مفاتيح الصلاحيات', 'ربط الإجراءات', 'التحكم في الفهرس']),
              formDefinition: accessPermissionFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Role Permissions', 'صلاحيات الأدوار'),
            tableName: 'role_permissions',
            child: ModelCrudPage<RolePermission>(
              title: tr('Role Permissions', 'صلاحيات الأدوار'),
              entityLabel: rolePermissionEntityLabel(l10n),
              description: tr('Assign page and action permissions to roles with explicit allow or deny decisions.', 'عيّن صلاحيات الصفحات والإجراءات للأدوار مع قرارات صريحة بالسماح أو المنع.'),
              icon: Icons.admin_panel_settings_rounded,
              highlights: trList(const ['Role grants', 'Deny overrides', 'Tenant policy'], const ['منح الأدوار', 'تجاوزات المنع', 'سياسة المستأجر']),
              formDefinition: rolePermissionFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('User Permissions', 'صلاحيات المستخدمين'),
            tableName: 'user_permissions',
            child: ModelCrudPage<UserPermission>(
              title: tr('User Permissions', 'صلاحيات المستخدمين'),
              entityLabel: userPermissionEntityLabel(l10n),
              description: tr('Grant or deny targeted permissions directly to individual users.', 'امنح أو امنع صلاحيات محددة مباشرةً للمستخدمين الأفراد.'),
              icon: Icons.manage_accounts_rounded,
              highlights: trList(const ['Direct overrides', 'Staff exceptions', 'Access tuning'], const ['تجاوزات مباشرة', 'استثناءات الموظفين', 'ضبط الوصول']),
              formDefinition: userPermissionFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('User Roles', 'أدوار المستخدمين'),
            tableName: 'user_roles',
            child: ModelCrudPage<UserRoles>(
              title: tr('User Roles', 'أدوار المستخدمين'),
              entityLabel: userRoleEntityLabel(l10n),
              description: tr('Manage role assignments between users and permission roles.', 'إدارة تعيينات الأدوار بين المستخدمين وأدوار الصلاحيات.'),
              icon: Icons.verified_user_rounded,
              highlights: trList(const ['Role assignment', 'Status tracking', 'Access mapping'], const ['تعيين الأدوار', 'تتبع الحالة', 'ربط الوصول']),
              formDefinition: userRolesFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Store Users', 'مستخدمو المتجر'),
            tableName: 'store_user',
            child: ModelCrudPage<StoreUser>(
              title: tr('Store Users', 'مستخدمو المتجر'),
              entityLabel: storeUserEntityLabel(l10n),
              description: tr('Map users to stores and optional branches with role context.', 'اربط المستخدمين بالمتاجر والفروع الاختيارية ضمن سياق الدور.'),
              icon: Icons.group_rounded,
              highlights: trList(const ['Store membership', 'Branch assignment', 'Role link'], const ['عضوية المتجر', 'تعيين الفرع', 'ربط الدور']),
              formDefinition: storeUserFormDefinition(l10n),
            ),
          ),
        ];
      case _InventoryRelationsGroup.partners:
        return [
          _InventoryModule(
            label: tr('Store Suppliers', 'موردو المتجر'),
            tableName: 'store_supplier',
            child: ModelCrudPage<StoreSupplier>(
              title: tr('Store Suppliers', 'موردو المتجر'),
              entityLabel: storeSupplierEntityLabel(l10n),
              description: tr('Map suppliers to stores for procurement and fulfillment scope.', 'اربط الموردين بالمتاجر ضمن نطاق التوريد والتنفيذ.'),
              icon: Icons.factory_rounded,
              highlights: trList(const ['Store links', 'Supplier scope', 'Activation state'], const ['روابط المتجر', 'نطاق المورد', 'حالة التفعيل']),
              formDefinition: storeSupplierFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Store Clients', 'عملاء المتجر'),
            tableName: 'store_client',
            child: ModelCrudPage<StoreClient>(
              title: tr('Store Clients', 'عملاء المتجر'),
              entityLabel: storeClientEntityLabel(l10n),
              description: tr('Map clients to stores for sales and credit workflows.', 'اربط العملاء بالمتاجر ضمن عمليات البيع والائتمان.'),
              icon: Icons.handshake_rounded,
              highlights: trList(const ['Client scope', 'Store visibility', 'Status lifecycle'], const ['نطاق العميل', 'إظهار المتجر', 'دورة الحالة']),
              formDefinition: storeClientFormDefinition(l10n),
            ),
          ),
        ];
      case _InventoryRelationsGroup.structure:
        return [
          _InventoryModule(
            label: tr('Store Branches', 'فروع المتجر'),
            tableName: 'store_branches',
            child: ModelCrudPage<StoreBranches>(
              title: tr('Store Branch Links', 'روابط فروع المتجر'),
              entityLabel: storeBranchEntityLabel(l10n),
              description: tr('Link stores and branches for operational scoping.', 'اربط المتاجر والفروع لتحديد النطاق التشغيلي.'),
              icon: Icons.hub_rounded,
              highlights: trList(const ['Store/branch mapping', 'Operational scope', 'Status control'], const ['ربط المتجر والفرع', 'النطاق التشغيلي', 'التحكم في الحالة']),
              formDefinition: storeBranchesFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Branch Products', 'منتجات الفروع'),
            tableName: 'branch_product',
            child: ModelCrudPage<BranchProduct>(
              title: tr('Branch Products', 'منتجات الفروع'),
              entityLabel: branchProductEntityLabel(l10n),
              description: tr('Track branch-level product stock, reserves, and reorder thresholds.', 'تتبع مخزون المنتجات على مستوى الفرع والاحتياطي وحدود إعادة الطلب.'),
              icon: Icons.inventory_rounded,
              highlights: trList(const ['Stock position', 'Reserved quantity', 'Reorder levels'], const ['موضع المخزون', 'الكمية المحجوزة', 'مستويات إعادة الطلب']),
              formDefinition: branchProductFormDefinition(l10n),
            ),
          ),
        ];
      case _InventoryRelationsGroup.financials:
        return [
          _InventoryModule(
            label: tr('Invoice Items', 'عناصر الفاتورة'),
            tableName: 'store_invoice_item',
            child: ModelCrudPage<StoreInvoiceItem>(
              title: tr('Store Invoice Items', 'عناصر فاتورة المتجر'),
              entityLabel: invoiceItemEntityLabel(l10n),
              description: tr('Manage line items for store invoices including taxes and discounts.', 'إدارة بنود فواتير المتجر بما في ذلك الضرائب والخصومات.'),
              icon: Icons.receipt_long_rounded,
              highlights: trList(const ['Line totals', 'Discount/tax', 'Product linkage'], const ['إجماليات البنود', 'الخصم والضريبة', 'ربط المنتج']),
              formDefinition: storeInvoiceItemFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Payment Allocations', 'تخصيصات الدفع'),
            tableName: 'payment_allocation',
            child: ModelCrudPage<PaymentAllocation>(
              title: tr('Payment Allocations', 'تخصيصات الدفع'),
              entityLabel: paymentAllocationEntityLabel(l10n),
              description: tr('Allocate payment vouchers to invoices with dated allocations.', 'خصص سندات الدفع للفواتير مع تسجيل التخصيصات بتاريخها.'),
              icon: Icons.account_balance_wallet_rounded,
              highlights: trList(const ['Voucher matching', 'Allocation amount', 'Allocation date'], const ['مطابقة السند', 'مبلغ التخصيص', 'تاريخ التخصيص']),
              formDefinition: paymentAllocationFormDefinition(l10n),
            ),
          ),
          _InventoryModule(
            label: tr('Return Items', 'عناصر المرتجع'),
            tableName: 'store_return_item',
            child: ModelCrudPage<StoreReturnItem>(
              title: tr('Store Return Items', 'عناصر مرتجع المتجر'),
              entityLabel: returnItemEntityLabel(l10n),
              description: tr('Manage line items returned against invoices and products.', 'إدارة البنود المرتجعة مقابل الفواتير والمنتجات.'),
              icon: Icons.assignment_return_rounded,
              highlights: trList(const ['Return linkage', 'Reason tracking', 'Line totals'], const ['ربط المرتجع', 'تتبع السبب', 'إجماليات البنود']),
              formDefinition: storeReturnItemFormDefinition(l10n),
            ),
          ),
        ];
    }
  }

  Widget _buildPurchaseReceiptCard(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final storeOptions = _relationOptions(tableName: 'store', fallbackValue: 'store-central-001', fallbackLabel: l10n.pick('Central Store', 'المتجر المركزي'), labelKeys: const <String>['name']);
    final branchOptions = _relationOptions(tableName: 'branch', fallbackValue: 'branch-north-001', fallbackLabel: l10n.pick('North Branch', 'الفرع الشمالي'), labelKeys: const <String>['name']);
    final supplierOptions = _relationOptions(tableName: 'supplier', fallbackValue: 'supplier-alnoor-001', fallbackLabel: l10n.pick('Al Noor Trading', 'تجارة النور'), labelKeys: const <String>['name']);
    final supplierInvoiceOptions = _relationOptions(tableName: 'supplier_invoice', fallbackValue: 'supplier-invoice-sample-001', fallbackLabel: 'SI-2026-0012', labelKeys: const <String>['supplierInvoiceNumber']);
    final productOptions = _relationOptions(tableName: 'products', fallbackValue: 'product-flour-001', fallbackLabel: l10n.pick('Premium Flour 25kg', 'دقيق ممتاز 25 كجم'), labelKeys: const <String>['name']);
    final userOptions = _relationOptions(
      tableName: 'users',
      fallbackValue: 'user-ops-manager-001',
      fallbackLabel: l10n.pick('Operations Manager', 'مدير العمليات'),
      labelKeys: const <String>['name', 'username', 'email'],
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.purchaseReceiving, style: theme.textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(l10n.purchaseReceivingDescription, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _field(_ownerUuidController, l10n.ownerUuidLabel, fieldKey: 'ownerUuid', required: true),
                  _relationField(_storeUuidController, l10n.storeUuidLabel, fieldKey: 'storeUuid', options: storeOptions, required: true),
                  _relationField(_branchUuidController, l10n.branchUuidLabel, fieldKey: 'branchUuid', options: branchOptions, required: true),
                  _relationField(_supplierUuidController, l10n.supplierUuidLabel, fieldKey: 'supplierUuid', options: supplierOptions, required: true),
                  _relationField(_supplierInvoiceUuidController, l10n.supplierInvoiceUuidLabel, fieldKey: 'supplierInvoiceUuid', options: supplierInvoiceOptions, required: true),
                  _relationField(_productUuidController, l10n.productUuidLabel, fieldKey: 'productUuid', options: productOptions, required: true),
                  _field(_batchNumberController, l10n.batchNumberLabel, fieldKey: 'batchNumber'),
                  _field(_quantityController, l10n.quantityLabel, fieldKey: 'quantity', required: true, isNumber: true),
                  _field(_unitCostController, l10n.unitCostLabel, fieldKey: 'unitCost', required: true, isNumber: true),
                  _field(_expiryDateController, l10n.expiryDateLabel, fieldKey: 'expiryDate'),
                  _relationField(_staffUserUuidController, l10n.staffUserUuidLabel, fieldKey: 'staffUserUuid', options: userOptions, allowEmpty: true),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                key: const Key('purchase-receipt-submit'),
                onPressed: _postingReceipt ? null : _submitPurchaseReceipt,
                icon: _postingReceipt ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.inventory_2_rounded),
                label: Text(_postingReceipt ? l10n.posting : l10n.postPurchaseReceipt),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {String? fieldKey, bool required = false, bool isNumber = false}) {
    final l10n = context.l10n;
    return SizedBox(
      width: 260,
      child: TextFormField(
        key: fieldKey == null ? null : Key('purchase-receipt-$fieldKey'),
        controller: controller,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return l10n.fieldRequired(label);
          }
          if (isNumber && value != null && value.trim().isNotEmpty && num.tryParse(value.trim()) == null) {
            return l10n.fieldMustBeNumber(label);
          }
          if (fieldKey == 'expiryDate' && value != null && value.trim().isNotEmpty) {
            try {
              DateTime.parse(value.trim());
            } catch (_) {
              return l10n.expiryDateFormatError;
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _relationField(TextEditingController controller, String label, {required String fieldKey, required List<_InventorySelectOption> options, bool required = false, bool allowEmpty = false}) {
    final l10n = context.l10n;
    final currentValue = controller.text.trim();
    final dropdownItems = <DropdownMenuItem<String>>[
      if (allowEmpty) const DropdownMenuItem<String>(value: '', child: Text('-')),
      ...options.map(
        (option) => DropdownMenuItem<String>(
          value: option.value,
          child: Text(option.label, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    final hasCurrentValue = dropdownItems.any((item) => item.value == currentValue);

    return SizedBox(
      width: 260,
      child: DropdownButtonFormField<String>(
        key: Key('purchase-receipt-$fieldKey'),
        initialValue: hasCurrentValue ? currentValue : (allowEmpty ? '' : null),
        isExpanded: true,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            controller.text = (value ?? '').trim();
          });
        },
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return l10n.fieldRequired(label);
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
      final sortedStoreUuids = scope.storeUuids.toList(growable: false)..sort();
      final sortedBranchUuids = scope.branchUuids.toList(growable: false)..sort();

      setState(() {
        _ownerUuidController.text = scope.ownerUuid!;
        if (_storeUuidController.text.trim().isEmpty && sortedStoreUuids.isNotEmpty) {
          _storeUuidController.text = sortedStoreUuids.first;
        }
        if (_branchUuidController.text.trim().isEmpty && sortedBranchUuids.isNotEmpty) {
          _branchUuidController.text = sortedBranchUuids.first;
        }
        if (_staffUserUuidController.text.trim().isEmpty && scope.userUuid != null && scope.userUuid!.isNotEmpty) {
          _staffUserUuidController.text = scope.userUuid!;
        }
      });
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
      AppNotification.show(context, message: context.l10n.validPositiveNumbersRequired, type: AppNotificationType.warning);
      return;
    }

    DateTime? expiryDate;
    final expiryRaw = _expiryDateController.text.trim();
    if (expiryRaw.isNotEmpty) {
      try {
        expiryDate = DateTime.parse(expiryRaw);
      } catch (_) {
        AppNotification.show(context, message: context.l10n.expiryDateFormatError, type: AppNotificationType.warning);
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

      AppNotification.show(context, message: context.l10n.purchaseReceiptPosted(batchUuid), type: AppNotificationType.success);
      _batchNumberController.text = 'BATCH-${DateTime.now().millisecondsSinceEpoch}';
      _quantityController.text = '1';
      _unitCostController.clear();
      _expiryDateController.clear();
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotification.show(context, message: context.l10n.purchaseReceiptPostFailed(error.toString()), type: AppNotificationType.error);
    } finally {
      if (mounted) {
        setState(() {
          _postingReceipt = false;
        });
      }
    }
  }
}

List<_InventorySelectOption> _relationOptions({required String tableName, required String fallbackValue, required String fallbackLabel, List<String> labelKeys = const <String>[]}) {
  final optionsByValue = <String, _InventorySelectOption>{fallbackValue: _InventorySelectOption(value: fallbackValue, label: fallbackLabel)};

  final database = LocalDatabase.current;
  if (database != null && database.isAvailable) {
    for (final row in database.getRowsForType(tableName)) {
      if (row['deletedAt'] != null || row['deleted_at'] != null) {
        continue;
      }

      final value = row['uuid']?.toString().trim() ?? row['id']?.toString().trim() ?? '';
      if (value.isEmpty) {
        continue;
      }

      final label = _relationOptionLabel(row, labelKeys: labelKeys) ?? value;
      optionsByValue[value] = _InventorySelectOption(value: value, label: label);
    }
  }

  final options = optionsByValue.values.toList(growable: false);
  options.sort((left, right) => left.label.toLowerCase().compareTo(right.label.toLowerCase()));
  return options;
}

String? _relationOptionLabel(Map<String, dynamic> row, {required List<String> labelKeys}) {
  final candidates = <String>{...labelKeys, 'name', 'title', 'supplierInvoiceNumber', 'invoiceNumber', 'username', 'email'};
  for (final key in candidates) {
    final value = row[key]?.toString().trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
  }
  return null;
}

class _InventorySelectOption {
  const _InventorySelectOption({required this.value, required this.label});

  final String value;
  final String label;
}

class _InventoryModule {
  const _InventoryModule({required this.label, required this.tableName, required this.child});

  final String label;
  final String? tableName;
  final Widget child;
}

enum _InventorySection { operations, procurement, transfer, sales, pricing, workforce, relations }

enum _InventoryRelationsGroup { access, partners, structure, financials }
