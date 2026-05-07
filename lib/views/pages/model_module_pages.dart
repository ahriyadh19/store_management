import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/models/categories.dart';
import 'package:store_management/models/client.dart';
import 'package:store_management/models/supplier.dart';
import 'package:store_management/models/inventory_movement.dart';
import 'package:store_management/models/inventory_batch.dart';
import 'package:store_management/models/inventory_transaction.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/branch_price.dart';
import 'package:store_management/models/purchase_order.dart';
import 'package:store_management/models/purchase_order_item.dart';
import 'package:store_management/models/promotion_rule.dart';
import 'package:store_management/models/product.dart';
import 'package:store_management/models/roles.dart';
import 'package:store_management/models/sales_invoice.dart';
import 'package:store_management/models/sales_order.dart';
import 'package:store_management/models/sales_return.dart';
import 'package:store_management/models/staff_activity_log.dart';
import 'package:store_management/models/staff_attendance.dart';
import 'package:store_management/models/staff_shift.dart';
import 'package:store_management/models/store.dart';
import 'package:store_management/models/store_financial_transaction.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/models/store_payment_voucher.dart';
import 'package:store_management/models/store_return.dart';
import 'package:store_management/models/supplier_invoice.dart';
import 'package:store_management/models/tags.dart';
import 'package:store_management/models/transfer_order.dart';
import 'package:store_management/models/transfer_order_item.dart';
import 'package:store_management/models/users.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/inventory_transaction_service.dart';
import 'package:store_management/services/owner_scope_service.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/views/components/model_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

ModelFormDefinition<Store> storeFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Store>(
  tableName: 'store',
  fields: [
    _textField('ownerUserUuid', _t(l10n, 'Owner user UUID', 'معرّف مالك المتجر UUID'), required: true),
    _textField('name', _t(l10n, 'Store name', 'اسم المتجر'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _multilineField('address', _t(l10n, 'Address', 'العنوان'), required: true),
    _textField('phone', _t(l10n, 'Phone', 'الهاتف'), type: ModelFormFieldType.phone, required: true),
    _textField('email', _t(l10n, 'Email', 'البريد الإلكتروني'), type: ModelFormFieldType.email, required: true),
  ],
  fromMap: Store.fromMap,
  toMap: (store) => store.toMap(),
  sampleModel: Store(
    ownerUserUuid: '11111111-1111-4111-8111-111111111111',
    name: 'Central Store',
    description: _t(l10n, 'Primary retail location and stock coordination point.', 'موقع البيع الرئيسي ونقطة تنسيق المخزون.'),
    address: '12 Commerce Ave, Downtown',
    phone: '+967700000001',
    email: 'central@store.app',
  ),
);

ModelFormDefinition<Branch> branchFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Branch>(
  tableName: 'branch',
  fields: [
    _textField('name', _t(l10n, 'Branch name', 'اسم الفرع'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _multilineField('address', _t(l10n, 'Address', 'العنوان'), required: true),
    _textField('phone', _t(l10n, 'Phone', 'الهاتف'), type: ModelFormFieldType.phone, required: true),
    _textField('email', _t(l10n, 'Email', 'البريد الإلكتروني'), type: ModelFormFieldType.email, required: true),
    _statusField(l10n),
  ],
  fromMap: Branch.fromMap,
  toMap: (branch) => branch.toMap(),
  sampleModel: Branch(
    name: 'North Branch',
    description: _t(l10n, 'Regional storefront for walk-in sales.', 'واجهة بيع إقليمية للمبيعات المباشرة.'),
    address: '45 Market Road, North District',
    phone: '+967700000002',
    email: 'north.branch@store.app',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<Product> productFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Product>(
  tableName: 'products',
  fields: [
    _textField('name', _t(l10n, 'Product name', 'اسم المنتج'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _statusField(l10n),
  ],
  fromMap: Product.fromMap,
  toMap: (product) => product.toMap(),
  sampleModel: Product(
    name: 'Premium Flour 25kg',
    description: _t(l10n, 'Bulk flour package used by regular wholesale customers.', 'عبوة دقيق كبيرة يستخدمها عملاء الجملة بشكل منتظم.'),
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<Categories> categoryFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Categories>(
  tableName: 'category',
  fields: [
    _textField('name', _t(l10n, 'Category name', 'اسم الفئة'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _textField('parentUuid', _t(l10n, 'Parent category UUID', 'معرّف الفئة الأصلية UUID')),
    _statusField(l10n),
  ],
  fromMap: Categories.fromMap,
  toMap: (category) => category.toMap(),
  sampleModel: Categories(
    name: 'Bakery Supplies',
    description: _t(l10n, 'Flour, sugar, yeast, and baking accessories.', 'الدقيق والسكر والخميرة وإكسسوارات الخبز.'),
    status: RecordStatus.active.code,
    parentUuid: null,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<Tags> tagFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Tags>(
  tableName: 'tags',
  fields: [
    _textField('name', _t(l10n, 'Tag name', 'اسم الوسم'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _statusField(l10n),
  ],
  fromMap: Tags.fromMap,
  toMap: (tag) => tag.toMap(),
  sampleModel: Tags(
    name: 'Fast moving',
    description: _t(l10n, 'Products with high turnover and replenishment priority.', 'منتجات ذات دوران مرتفع وأولوية في إعادة التزويد.'),
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<Client> clientFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Client>(
  tableName: 'client',
  fields: [
    _textField('name', _t(l10n, 'Client name', 'اسم العميل'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _textField('email', _t(l10n, 'Email', 'البريد الإلكتروني'), type: ModelFormFieldType.email, required: true),
    _textField('phone', _t(l10n, 'Phone', 'الهاتف'), type: ModelFormFieldType.phone, required: true),
    _multilineField('address', _t(l10n, 'Address', 'العنوان'), required: true),
    _decimalField('creditLimit', _t(l10n, 'Credit limit', 'حد الائتمان'), required: true),
    _decimalField('currentCredit', _t(l10n, 'Current credit', 'الائتمان الحالي'), required: true),
    _decimalField('availableCredit', _t(l10n, 'Available credit', 'الائتمان المتاح'), required: true),
    _statusField(l10n),
  ],
  fromMap: Client.fromMap,
  toMap: (client) => client.toMap(),
  sampleModel: Client(
    name: 'Blue Market',
    description: _t(l10n, 'High-volume client with monthly billing terms.', 'عميل بحجم تعامل مرتفع وبشروط فوترة شهرية.'),
    email: 'accounts@bluemarket.com',
    phone: '+967700000010',
    address: '85 Trade Street, Sanaa',
    status: RecordStatus.active.code,
    creditLimit: Decimal.parse('5000'),
    currentCredit: Decimal.parse('1450'),
    availableCredit: Decimal.parse('3550'),
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<Supplier> supplierFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Supplier>(
  tableName: 'supplier',
  fields: [
    _textField('name', _t(l10n, 'Supplier name', 'اسم الشركة'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _statusField(l10n),
  ],
  fromMap: Supplier.fromMap,
  toMap: (supplier) => supplier.toMap(),
  sampleModel: Supplier(
    name: 'Al Noor Trading',
    description: _t(l10n, 'Primary supplier of packaged food and household items.', 'المورّد الرئيسي للمواد الغذائية المعبأة والمواد المنزلية.'),
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<User> userFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<User>(
  tableName: 'users',
  fields: [
    _textField('name', _t(l10n, 'Full name', 'الاسم الكامل'), required: true),
    _textField('username', _t(l10n, 'Username', 'اسم المستخدم'), required: true),
    _textField('email', _t(l10n, 'Email', 'البريد الإلكتروني'), type: ModelFormFieldType.email, required: true),
    _statusField(l10n),
  ],
  fromMap: User.fromMap,
  toMap: (user) => user.toMap(includePassword: false),
  sampleModel: User(
    name: 'Operations Manager',
    username: 'ops.manager',
    email: 'ops.manager@store.app',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<Roles> roleFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<Roles>(
  tableName: 'roles',
  fields: [
    _textField('name', _t(l10n, 'Role name', 'اسم الدور'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _statusField(l10n),
  ],
  fromMap: Roles.fromMap,
  toMap: (role) => role.toMap(),
  sampleModel: Roles(
    name: 'Store Supervisor',
    description: _t(l10n, 'Can manage inventory updates, clients, and invoice approvals.', 'يمكنه إدارة تحديثات المخزون والعملاء واعتمادات الفواتير.'),
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<StoreInvoice> invoiceFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<StoreInvoice>(
  tableName: 'store_invoice',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID')),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID')),
    _textField('clientUuid', _t(l10n, 'Client UUID', 'معرّف العميل UUID'), required: true),
    _textField('invoiceNumber', _t(l10n, 'Invoice number', 'رقم الفاتورة'), required: true),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID')),
    _integerField('quantity', _t(l10n, 'Quantity', 'الكمية')),
    _decimalField('unitPrice', _t(l10n, 'Unit price', 'سعر الوحدة')),
    _selectionField('batchSelectionStrategy', _t(l10n, 'Batch strategy', 'استراتيجية اختيار الدفعة'), const [ModelFormSelectOption(label: 'FIFO', value: 'fifo'), ModelFormSelectOption(label: 'FEFO', value: 'fefo')]),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
    _selectionField('invoiceType', _t(l10n, 'Invoice type', 'نوع الفاتورة'), _invoiceTypeOptions(l10n), required: true),
    _integerField('itemCount', _t(l10n, 'Item count', 'عدد العناصر'), required: true),
    _decimalField('totalAmount', _t(l10n, 'Total amount', 'المبلغ الإجمالي'), required: true),
    _decimalField('paidAmount', _t(l10n, 'Paid amount', 'المبلغ المدفوع'), required: true),
    _decimalField('balanceAmount', _t(l10n, 'Balance amount', 'المبلغ المتبقي'), required: true),
    _multilineField('notes', _t(l10n, 'Notes', 'ملاحظات'), required: true),
    _dateTimeField('issuedAt', _t(l10n, 'Issued at', 'تاريخ الإصدار'), required: true),
    _dateTimeField('dueAt', _t(l10n, 'Due at', 'تاريخ الاستحقاق'), required: true),
    _statusField(l10n),
  ],
  fromMap: StoreInvoice.fromMap,
  toMap: (invoice) => invoice.toMap(),
  afterCreateHook: ({required model, required values}) async {
    final ownerUuid = _stringOrNull(values['ownerUuid']);
    final branchUuid = _stringOrNull(values['branchUuid']);
    final productUuid = _stringOrNull(values['productUuid']);
    final quantity = _intOrNull(values['quantity']);
    final unitPrice = _numOrNull(values['unitPrice']);

    if (ownerUuid == null || branchUuid == null || productUuid == null || quantity == null || quantity <= 0 || unitPrice == null) {
      return;
    }

    final strategyValue = (_stringOrNull(values['batchSelectionStrategy']) ?? 'fifo').toLowerCase();
    final strategy = strategyValue == 'fefo' ? BatchSelectionStrategy.fefo : BatchSelectionStrategy.fifo;

    await _inventoryTransactionService.postSaleTransactions(
      ownerUuid: ownerUuid,
      branchUuid: branchUuid,
      productUuid: productUuid,
      salesInvoiceUuid: model.uuid,
      quantity: quantity,
      unitPrice: unitPrice,
      strategy: strategy,
      staffUserUuid: _stringOrNull(values['createdByUserUuid']),
    );
  },
  sampleModel: StoreInvoice(
    storeUuid: 'store-central-001',
    clientUuid: 'client-blue-market-001',
    invoiceNumber: 'INV-2024-0008',
    invoiceType: StoreInvoiceType.credit,
    itemCount: 4,
    totalAmount: Decimal.parse('830.50'),
    paidAmount: Decimal.parse('300'),
    balanceAmount: Decimal.parse('530.50'),
    notes: _t(l10n, 'Deliver through branch pickup.', 'يتم التسليم عبر الاستلام من الفرع.'),
    issuedAt: _transactionAt,
    dueAt: _transactionAt.add(const Duration(days: 14)),
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<StoreReturn> returnFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<StoreReturn>(
  tableName: 'store_return',
  fields: [
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('clientUuid', _t(l10n, 'Client UUID', 'معرّف العميل UUID'), required: true),
    _textField('returnNumber', _t(l10n, 'Return number', 'رقم المرتجع'), required: true),
    _selectionField('returnType', _t(l10n, 'Return type', 'نوع المرتجع'), _returnTypeOptions(l10n), required: true),
    _integerField('itemCount', _t(l10n, 'Item count', 'عدد العناصر'), required: true),
    _decimalField('totalAmount', _t(l10n, 'Total amount', 'المبلغ الإجمالي'), required: true),
    _multilineField('reason', _t(l10n, 'Reason', 'السبب'), required: true),
    _dateTimeField('transactionDate', _t(l10n, 'Transaction date', 'تاريخ العملية'), required: true),
    _statusField(l10n),
  ],
  fromMap: StoreReturn.fromMap,
  toMap: (storeReturn) => storeReturn.toMap(),
  sampleModel: StoreReturn(
    storeUuid: 'store-central-001',
    clientUuid: 'client-blue-market-001',
    returnNumber: 'RET-2024-0003',
    returnType: StoreReturnType.salesReturn,
    itemCount: 2,
    totalAmount: Decimal.parse('120'),
    reason: _t(l10n, 'Packaging arrived damaged during delivery.', 'وصل التغليف تالفًا أثناء التسليم.'),
    transactionDate: _transactionAt,
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<StorePaymentVoucher> paymentVoucherFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<StorePaymentVoucher>(
  tableName: 'store_payment_voucher',
  fields: [
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('clientUuid', _t(l10n, 'Client UUID', 'معرّف العميل UUID'), required: true),
    _textField('voucherNumber', _t(l10n, 'Voucher number', 'رقم السند'), required: true),
    _textField('payeeName', _t(l10n, 'Payee name', 'اسم المستفيد'), required: true),
    _decimalField('amount', _t(l10n, 'Amount', 'المبلغ'), required: true),
    _selectionField('paymentMethod', _t(l10n, 'Payment method', 'طريقة الدفع'), _paymentMethodOptions(l10n), required: true),
    _textField('referenceNumber', _t(l10n, 'Reference number', 'الرقم المرجعي'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _dateTimeField('transactionDate', _t(l10n, 'Transaction date', 'تاريخ العملية'), required: true),
    _statusField(l10n),
  ],
  fromMap: StorePaymentVoucher.fromMap,
  toMap: (voucher) => voucher.toMap(),
  sampleModel: StorePaymentVoucher(
    storeUuid: 'store-central-001',
    clientUuid: 'client-blue-market-001',
    voucherNumber: 'PV-2024-0011',
    payeeName: 'Blue Market',
    amount: Decimal.parse('300'),
    paymentMethod: StorePaymentMethod.bankTransfer,
    referenceNumber: 'TRX-4488',
    description: _t(l10n, 'Partial settlement for credit invoice.', 'تسوية جزئية لفاتورة آجلة.'),
    transactionDate: _transactionAt,
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<InventoryMovement> inventoryMovementFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<InventoryMovement>(
  tableName: 'inventory_movement',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID')),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID')),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID')),
    _textField('supplierUuid', _t(l10n, 'Supplier UUID', 'معرّف المورد UUID')),
    _textField('supplierInvoiceUuid', _t(l10n, 'Supplier invoice UUID', 'معرّف فاتورة المورد UUID')),
    _textField('batchNumber', _t(l10n, 'Batch number', 'رقم الدفعة')),
    _dateTimeField('expiryDate', _t(l10n, 'Expiry date', 'تاريخ الانتهاء')),
    _textField('supplierProductUuid', _t(l10n, 'Supplier product UUID', 'معرّف منتج الشركة UUID'), required: true),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID'), required: true),
    _selectionField('movementType', _t(l10n, 'Movement type', 'نوع الحركة'), _movementTypeOptions(l10n), required: true),
    _integerField('quantityDelta', _t(l10n, 'Quantity delta', 'تغير الكمية'), required: true),
    _integerField('balanceAfter', _t(l10n, 'Balance after', 'الرصيد بعد الحركة'), required: true),
    _decimalField('unitCost', _t(l10n, 'Unit cost', 'تكلفة الوحدة')),
    _selectionField('referenceType', _t(l10n, 'Reference type', 'نوع المرجع'), _referenceTypeOptions(l10n), required: true),
    _textField('referenceUuid', _t(l10n, 'Reference UUID', 'معرّف المرجع UUID')),
    _multilineField('note', _t(l10n, 'Note', 'ملاحظة'), required: true),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
  ],
  fromMap: InventoryMovement.fromMap,
  toMap: (movement) => movement.toMap(),
  afterCreateHook: ({required model, required values}) async {
    final movementType = _stringOrNull(values['movementType'])?.toLowerCase();
    if (movementType != InventoryMovementType.purchase.value) {
      return;
    }

    final scope = await _resolveOwnerScope();
    final ownerUuid = _stringOrNull(values['ownerUuid']) ?? scope.ownerUuid;
    final storeUuid = _stringOrNull(values['storeUuid']);
    final branchUuid = _stringOrNull(values['branchUuid']);
    final supplierUuid = _stringOrNull(values['supplierUuid']);
    final supplierInvoiceUuid = _stringOrNull(values['supplierInvoiceUuid']) ?? _stringOrNull(values['referenceUuid']) ?? model.referenceUuid;
    final quantity = _intOrNull(values['quantityDelta']);
    final unitCost = _numOrNull(values['unitCost']);
    final expiryMillis = _intOrNull(values['expiryDate']);

    if (ownerUuid == null || storeUuid == null || branchUuid == null || supplierUuid == null || supplierInvoiceUuid == null || quantity == null || quantity <= 0 || unitCost == null) {
      return;
    }

    await _inventoryTransactionService.postPurchaseReceipt(
      ownerUuid: ownerUuid,
      storeUuid: storeUuid,
      branchUuid: branchUuid,
      supplierUuid: supplierUuid,
      productUuid: model.productUuid,
      supplierInvoiceUuid: supplierInvoiceUuid,
      batchNumber: _stringOrNull(values['batchNumber']),
      expiryDate: expiryMillis == null ? null : DateTime.fromMillisecondsSinceEpoch(expiryMillis),
      quantity: quantity,
      unitCost: unitCost,
      staffUserUuid: _stringOrNull(values['createdByUserUuid']),
    );
  },
  sampleModel: InventoryMovement(
    supplierProductUuid: 'supplier-product-001',
    productUuid: 'product-flour-001',
    movementType: InventoryMovementType.restock,
    quantityDelta: 50,
    balanceAfter: 180,
    unitCost: Decimal.parse('9.75'),
    referenceType: InventoryReferenceType.restock,
    referenceUuid: 'restock-2024-0005',
    note: _t(l10n, 'Weekly replenishment from warehouse.', 'إعادة تزويد أسبوعية من المستودع.'),
    createdByUserUuid: 'user-ops-manager-001',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<StoreFinancialTransaction> transactionFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<StoreFinancialTransaction>(
  tableName: 'store_financial_transaction',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID')),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('clientUuid', _t(l10n, 'Client UUID', 'معرّف العميل UUID'), required: true),
    _textField('transactionNumber', _t(l10n, 'Transaction number', 'رقم العملية'), required: true),
    _selectionField('transactionType', _t(l10n, 'Transaction type', 'نوع العملية'), _transactionTypeOptions(l10n), required: true),
    _selectionField('sourceType', _t(l10n, 'Source type', 'نوع المصدر'), _sourceTypeOptions(l10n), required: true),
    _textField('sourceUuid', _t(l10n, 'Source UUID', 'معرّف المصدر UUID'), required: true),
    _decimalField('amount', _t(l10n, 'Amount', 'المبلغ'), required: true),
    _selectionField('entryType', _t(l10n, 'Entry type', 'نوع القيد'), _entryTypeOptions(l10n), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _textField('sourceBranchUuid', _t(l10n, 'Source branch UUID', 'معرّف الفرع المصدر UUID')),
    _textField('destinationBranchUuid', _t(l10n, 'Destination branch UUID', 'معرّف الفرع الوجهة UUID')),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID')),
    _textField('batchUuid', _t(l10n, 'Batch UUID', 'معرّف الدفعة UUID')),
    _integerField('quantity', _t(l10n, 'Quantity', 'الكمية')),
    _decimalField('unitCost', _t(l10n, 'Unit cost', 'تكلفة الوحدة')),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
    _dateTimeField('transactionDate', _t(l10n, 'Transaction date', 'تاريخ العملية'), required: true),
    _statusField(l10n),
  ],
  fromMap: StoreFinancialTransaction.fromMap,
  toMap: (transaction) => transaction.toMap(),
  afterCreateHook: ({required model, required values}) async {
    final sourceType = _stringOrNull(values['sourceType'])?.toLowerCase();
    if (sourceType != 'inventory_movement') {
      return;
    }

    final ownerUuid = _stringOrNull(values['ownerUuid']);
    final sourceBranchUuid = _stringOrNull(values['sourceBranchUuid']);
    final destinationBranchUuid = _stringOrNull(values['destinationBranchUuid']);
    final productUuid = _stringOrNull(values['productUuid']);
    final batchUuid = _stringOrNull(values['batchUuid']);
    final quantity = _intOrNull(values['quantity']);
    final unitCost = _numOrNull(values['unitCost']) ?? 0;

    if (ownerUuid == null || sourceBranchUuid == null || destinationBranchUuid == null || productUuid == null || batchUuid == null || quantity == null || quantity <= 0) {
      return;
    }

    await _inventoryTransactionService.postTransferTransactions(
      ownerUuid: ownerUuid,
      transferOrderUuid: model.sourceUuid,
      sourceBranchUuid: sourceBranchUuid,
      destinationBranchUuid: destinationBranchUuid,
      productUuid: productUuid,
      lots: <InventoryAllocationLot>[InventoryAllocationLot(batchUuid: batchUuid, quantity: quantity, unitCost: unitCost)],
      staffUserUuid: _stringOrNull(values['createdByUserUuid']),
    );
  },
  sampleModel: StoreFinancialTransaction(
    storeUuid: 'store-central-001',
    clientUuid: 'client-blue-market-001',
    transactionNumber: 'FT-2024-0057',
    transactionType: FinancialTransactionType.paymentReceipt,
    sourceType: FinancialSourceType.paymentVoucher,
    sourceUuid: 'PV-2024-0011',
    amount: Decimal.parse('300'),
    entryType: LedgerEntryType.credit,
    description: _t(l10n, 'Payment receipt linked to voucher settlement.', 'إيصال دفع مرتبط بتسوية سند.'),
    transactionDate: _transactionAt,
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<PurchaseOrder> purchaseOrderFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<PurchaseOrder>(
  tableName: 'purchase_order',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('supplierUuid', _t(l10n, 'Supplier UUID', 'معرّف المورد UUID'), required: true),
    _textField('poNumber', _t(l10n, 'PO number', 'رقم أمر الشراء'), required: true),
    _dateTimeField('orderDate', _t(l10n, 'Order date', 'تاريخ الطلب'), required: true),
    _dateTimeField('expectedDate', _t(l10n, 'Expected date', 'تاريخ التوقع')),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _purchaseOrderStatusOptions(l10n), required: true),
    _textField('currencyCode', _t(l10n, 'Currency code', 'رمز العملة'), required: true),
    _decimalField('totalAmount', _t(l10n, 'Total amount', 'المبلغ الإجمالي'), required: true),
    _multilineField('notes', _t(l10n, 'Notes', 'ملاحظات'), required: true),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
  ],
  fromMap: PurchaseOrder.fromMap,
  toMap: (purchaseOrder) => purchaseOrder.toMap(),
  sampleModel: PurchaseOrder(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    storeUuid: '22222222-2222-4222-8222-222222222222',
    supplierUuid: '33333333-3333-4333-8333-333333333333',
    poNumber: 'PO-2026-0002',
    orderDate: _transactionAt,
    expectedDate: _transactionAt.add(const Duration(days: 7)),
    status: 'draft',
    currencyCode: 'USD',
    totalAmount: Decimal.parse('0'),
    notes: _t(l10n, 'Initial draft purchase order.', 'مسودة أولية لأمر الشراء.'),
    createdByUserUuid: '44444444-4444-4444-8444-444444444444',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<PurchaseOrderItem> purchaseOrderItemFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<PurchaseOrderItem>(
  tableName: 'purchase_order_item',
  fields: [
    _textField('purchaseOrderUuid', _t(l10n, 'Purchase order UUID', 'معرّف أمر الشراء UUID'), required: true),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID'), required: true),
    _textField('supplierProductOfferUuid', _t(l10n, 'Supplier product offer UUID', 'معرّف عرض المورد UUID')),
    _integerField('quantity', _t(l10n, 'Quantity', 'الكمية'), required: true),
    _decimalField('unitCost', _t(l10n, 'Unit cost', 'تكلفة الوحدة'), required: true),
    _decimalField('discountAmount', _t(l10n, 'Discount amount', 'مبلغ الخصم'), required: true),
    _decimalField('lineTotal', _t(l10n, 'Line total', 'الإجمالي الفرعي'), required: true),
    _integerField('receivedQuantity', _t(l10n, 'Received quantity', 'الكمية المستلمة')),
  ],
  fromMap: PurchaseOrderItem.fromMap,
  toMap: (purchaseOrderItem) => purchaseOrderItem.toMap(),
  sampleModel: PurchaseOrderItem(
    purchaseOrderUuid: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    productUuid: 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
    supplierProductOfferUuid: 'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
    quantity: 12,
    unitCost: Decimal.parse('10.5'),
    discountAmount: Decimal.parse('6'),
    lineTotal: Decimal.parse('120'),
    receivedQuantity: 0,
  ),
);

ModelFormDefinition<SupplierInvoice> supplierInvoiceFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<SupplierInvoice>(
  tableName: 'supplier_invoice',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('supplierUuid', _t(l10n, 'Supplier UUID', 'معرّف المورد UUID'), required: true),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('purchaseOrderUuid', _t(l10n, 'Purchase order UUID', 'معرّف أمر الشراء UUID')),
    _textField('supplierInvoiceNumber', _t(l10n, 'Supplier invoice number', 'رقم فاتورة المورد'), required: true),
    _dateTimeField('invoiceDate', _t(l10n, 'Invoice date', 'تاريخ الفاتورة'), required: true),
    _dateTimeField('dueDate', _t(l10n, 'Due date', 'تاريخ الاستحقاق')),
    _textField('currencyCode', _t(l10n, 'Currency code', 'رمز العملة'), required: true),
    _decimalField('subtotal', _t(l10n, 'Subtotal', 'الإجمالي قبل الضريبة'), required: true),
    _decimalField('taxAmount', _t(l10n, 'Tax amount', 'قيمة الضريبة'), required: true),
    _decimalField('totalAmount', _t(l10n, 'Total amount', 'المبلغ الإجمالي'), required: true),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _supplierInvoiceStatusOptions(l10n), required: true),
  ],
  fromMap: SupplierInvoice.fromMap,
  toMap: (supplierInvoice) => supplierInvoice.toMap(),
  sampleModel: SupplierInvoice(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    supplierUuid: '33333333-3333-4333-8333-333333333333',
    storeUuid: '22222222-2222-4222-8222-222222222222',
    purchaseOrderUuid: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    supplierInvoiceNumber: 'SI-2026-0012',
    invoiceDate: _transactionAt,
    dueDate: _transactionAt.add(const Duration(days: 30)),
    currencyCode: 'USD',
    subtotal: Decimal.parse('1475'),
    taxAmount: Decimal.parse('75'),
    totalAmount: Decimal.parse('1550'),
    status: 'open',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<InventoryBatch> inventoryBatchFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<InventoryBatch>(
  tableName: 'inventory_batch',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('supplierUuid', _t(l10n, 'Supplier UUID', 'معرّف المورد UUID')),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID'), required: true),
    _textField('supplierInvoiceUuid', _t(l10n, 'Supplier invoice UUID', 'معرّف فاتورة المورد UUID')),
    _textField('supplierInvoiceItemRef', _t(l10n, 'Supplier invoice item ref', 'مرجع عنصر فاتورة المورد')),
    _textField('batchNumber', _t(l10n, 'Batch number', 'رقم الدفعة')),
    _dateTimeField('receivedAt', _t(l10n, 'Received at', 'تاريخ الاستلام'), required: true),
    _dateTimeField('expiryDate', _t(l10n, 'Expiry date', 'تاريخ الانتهاء')),
    _decimalField('unitCost', _t(l10n, 'Unit cost', 'تكلفة الوحدة'), required: true),
    _integerField('initialQuantity', _t(l10n, 'Initial quantity', 'الكمية الابتدائية'), required: true),
    _integerField('remainingQuantity', _t(l10n, 'Remaining quantity', 'الكمية المتبقية'), required: true),
    _statusField(l10n),
  ],
  fromMap: InventoryBatch.fromMap,
  toMap: (inventoryBatch) => inventoryBatch.toMap(),
  sampleModel: InventoryBatch(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    storeUuid: '22222222-2222-4222-8222-222222222222',
    supplierUuid: '33333333-3333-4333-8333-333333333333',
    productUuid: 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
    supplierInvoiceUuid: 'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
    supplierInvoiceItemRef: 'SI-LN-01',
    batchNumber: 'BATCH-2026-01',
    receivedAt: _transactionAt,
    expiryDate: _transactionAt.add(const Duration(days: 180)),
    unitCost: Decimal.parse('11.25'),
    initialQuantity: 100,
    remainingQuantity: 100,
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<InventoryTransaction> inventoryTransactionFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<InventoryTransaction>(
  tableName: 'inventory_transaction',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID'), required: true),
    _textField('batchUuid', _t(l10n, 'Batch UUID', 'معرّف الدفعة UUID')),
    _selectionField('holderType', _t(l10n, 'Holder type', 'نوع الحافظ'), _holderTypeOptions(l10n), required: true),
    _textField('holderUuid', _t(l10n, 'Holder UUID', 'معرّف الحافظ UUID'), required: true),
    _selectionField('transactionType', _t(l10n, 'Transaction type', 'نوع الحركة'), _inventoryTransactionTypeOptions(l10n), required: true),
    _integerField('quantity', _t(l10n, 'Quantity', 'الكمية'), required: true),
    _decimalField('unitCost', _t(l10n, 'Unit cost', 'تكلفة الوحدة')),
    _decimalField('unitPrice', _t(l10n, 'Unit price', 'سعر الوحدة')),
    _textField('referenceType', _t(l10n, 'Reference type', 'نوع المرجع'), required: true),
    _textField('referenceUuid', _t(l10n, 'Reference UUID', 'معرّف المرجع UUID')),
    _textField('linkedTransactionUuid', _t(l10n, 'Linked transaction UUID', 'معرّف الحركة المرتبطة UUID')),
    _textField('staffUserUuid', _t(l10n, 'Staff user UUID', 'معرّف موظف التنفيذ UUID')),
    _dateTimeField('occurredAt', _t(l10n, 'Occurred at', 'تاريخ الحدوث'), required: true),
    _multilineField('note', _t(l10n, 'Note', 'ملاحظة'), required: true),
  ],
  fromMap: InventoryTransaction.fromMap,
  toMap: (inventoryTransaction) => inventoryTransaction.toMap(),
  sampleModel: InventoryTransaction(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    productUuid: 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
    batchUuid: 'dddddddd-dddd-4ddd-8ddd-dddddddddddd',
    holderType: 'branch',
    holderUuid: 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
    transactionType: 'purchase',
    quantity: 30,
    unitCost: Decimal.parse('11.25'),
    unitPrice: null,
    referenceType: 'supplier_invoice',
    referenceUuid: 'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
    linkedTransactionUuid: null,
    staffUserUuid: 'ffffffff-ffff-4fff-8fff-ffffffffffff',
    occurredAt: _transactionAt,
    note: _t(l10n, 'Initial stocking transaction.', 'حركة تزويد أولية.'),
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<TransferOrder> transferOrderFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<TransferOrder>(
  tableName: 'transfer_order',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('sourceBranchUuid', _t(l10n, 'Source branch UUID', 'معرّف الفرع المصدر UUID'), required: true),
    _textField('destinationBranchUuid', _t(l10n, 'Destination branch UUID', 'معرّف الفرع الوجهة UUID'), required: true),
    _textField('transferNumber', _t(l10n, 'Transfer number', 'رقم التحويل'), required: true),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _transferOrderStatusOptions(l10n), required: true),
    _dateTimeField('requestedAt', _t(l10n, 'Requested at', 'وقت الطلب'), required: true),
    _dateTimeField('shippedAt', _t(l10n, 'Shipped at', 'وقت الشحن')),
    _dateTimeField('receivedAt', _t(l10n, 'Received at', 'وقت الاستلام')),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
  ],
  fromMap: TransferOrder.fromMap,
  toMap: (transferOrder) => transferOrder.toMap(),
  sampleModel: TransferOrder(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    sourceBranchUuid: '22222222-2222-4222-8222-222222222222',
    destinationBranchUuid: '33333333-3333-4333-8333-333333333333',
    transferNumber: 'TR-2026-0001',
    status: 'draft',
    requestedAt: _transactionAt,
    shippedAt: null,
    receivedAt: null,
    createdByUserUuid: '44444444-4444-4444-8444-444444444444',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<TransferOrderItem> transferOrderItemFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<TransferOrderItem>(
  tableName: 'transfer_order_item',
  fields: [
    _textField('transferOrderUuid', _t(l10n, 'Transfer order UUID', 'معرّف أمر التحويل UUID'), required: true),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID'), required: true),
    _integerField('quantity', _t(l10n, 'Quantity', 'الكمية'), required: true),
    _integerField('shippedQuantity', _t(l10n, 'Shipped quantity', 'الكمية المشحونة')),
    _integerField('receivedQuantity', _t(l10n, 'Received quantity', 'الكمية المستلمة')),
  ],
  fromMap: TransferOrderItem.fromMap,
  toMap: (transferOrderItem) => transferOrderItem.toMap(),
  sampleModel: TransferOrderItem(transferOrderUuid: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', productUuid: 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', quantity: 10, shippedQuantity: 0, receivedQuantity: 0),
);

ModelFormDefinition<SalesOrder> salesOrderFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<SalesOrder>(
  tableName: 'sales_order',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID'), required: true),
    _textField('customerUuid', _t(l10n, 'Customer UUID', 'معرّف العميل UUID')),
    _textField('orderNumber', _t(l10n, 'Order number', 'رقم الطلب'), required: true),
    _dateTimeField('orderDate', _t(l10n, 'Order date', 'تاريخ الطلب'), required: true),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _salesOrderStatusOptions(l10n), required: true),
    _selectionField('pricingStrategy', _t(l10n, 'Pricing strategy', 'استراتيجية التسعير'), _pricingStrategyOptions(l10n), required: true),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
  ],
  fromMap: SalesOrder.fromMap,
  toMap: (salesOrder) => salesOrder.toMap(),
  sampleModel: SalesOrder(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    storeUuid: '22222222-2222-4222-8222-222222222222',
    branchUuid: '33333333-3333-4333-8333-333333333333',
    customerUuid: '44444444-4444-4444-8444-444444444444',
    orderNumber: 'SO-2026-0001',
    orderDate: _transactionAt,
    status: 'draft',
    pricingStrategy: 'branch',
    createdByUserUuid: '55555555-5555-4555-8555-555555555555',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<SalesInvoice> salesInvoiceFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<SalesInvoice>(
  tableName: 'sales_invoice',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID'), required: true),
    _textField('salesOrderUuid', _t(l10n, 'Sales order UUID', 'معرّف أمر البيع UUID')),
    _textField('customerUuid', _t(l10n, 'Customer UUID', 'معرّف العميل UUID')),
    _textField('invoiceNumber', _t(l10n, 'Invoice number', 'رقم الفاتورة'), required: true),
    _dateTimeField('issuedAt', _t(l10n, 'Issued at', 'تاريخ الإصدار'), required: true),
    _textField('currencyCode', _t(l10n, 'Currency code', 'رمز العملة'), required: true),
    _decimalField('subtotal', _t(l10n, 'Subtotal', 'الإجمالي قبل الضريبة'), required: true),
    _decimalField('discountAmount', _t(l10n, 'Discount amount', 'مبلغ الخصم'), required: true),
    _decimalField('taxAmount', _t(l10n, 'Tax amount', 'قيمة الضريبة'), required: true),
    _decimalField('totalAmount', _t(l10n, 'Total amount', 'المبلغ الإجمالي'), required: true),
    _decimalField('paidAmount', _t(l10n, 'Paid amount', 'المبلغ المدفوع'), required: true),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _salesInvoiceStatusOptions(l10n), required: true),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
  ],
  fromMap: SalesInvoice.fromMap,
  toMap: (salesInvoice) => salesInvoice.toMap(),
  sampleModel: SalesInvoice(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    storeUuid: '22222222-2222-4222-8222-222222222222',
    branchUuid: '33333333-3333-4333-8333-333333333333',
    salesOrderUuid: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    customerUuid: '44444444-4444-4444-8444-444444444444',
    invoiceNumber: 'SINV-2026-0001',
    issuedAt: _transactionAt,
    currencyCode: 'USD',
    subtotal: Decimal.parse('100'),
    discountAmount: Decimal.parse('5'),
    taxAmount: Decimal.parse('10'),
    totalAmount: Decimal.parse('105'),
    paidAmount: Decimal.parse('0'),
    status: 'open',
    createdByUserUuid: '55555555-5555-4555-8555-555555555555',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<SalesReturn> salesReturnFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<SalesReturn>(
  tableName: 'sales_return',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('salesInvoiceUuid', _t(l10n, 'Sales invoice UUID', 'معرّف فاتورة البيع UUID'), required: true),
    _textField('returnNumber', _t(l10n, 'Return number', 'رقم المرتجع'), required: true),
    _dateTimeField('returnDate', _t(l10n, 'Return date', 'تاريخ المرتجع'), required: true),
    _multilineField('reason', _t(l10n, 'Reason', 'السبب'), required: true),
    _decimalField('refundAmount', _t(l10n, 'Refund amount', 'مبلغ الاسترداد'), required: true),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _salesReturnStatusOptions(l10n), required: true),
    _textField('createdByUserUuid', _t(l10n, 'Created by user UUID', 'معرّف المستخدم المنشئ UUID')),
  ],
  fromMap: SalesReturn.fromMap,
  toMap: (salesReturn) => salesReturn.toMap(),
  sampleModel: SalesReturn(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    salesInvoiceUuid: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    returnNumber: 'SRET-2026-0001',
    returnDate: _transactionAt,
    reason: _t(l10n, 'Damaged package returned by customer.', 'إرجاع تغليف تالف من العميل.'),
    refundAmount: Decimal.parse('25'),
    status: 'draft',
    createdByUserUuid: '55555555-5555-4555-8555-555555555555',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<BranchPrice> branchPriceFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<BranchPrice>(
  tableName: 'branch_price',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID'), required: true),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID'), required: true),
    _selectionField('priceType', _t(l10n, 'Price type', 'نوع السعر'), _priceTypeOptions(l10n), required: true),
    _decimalField('price', _t(l10n, 'Price', 'السعر'), required: true),
    _dateTimeField('startsAt', _t(l10n, 'Starts at', 'يبدأ في')),
    _dateTimeField('endsAt', _t(l10n, 'Ends at', 'ينتهي في')),
    _integerField('priority', _t(l10n, 'Priority', 'الأولوية')),
    _statusField(l10n),
  ],
  fromMap: BranchPrice.fromMap,
  toMap: (branchPrice) => branchPrice.toMap(),
  sampleModel: BranchPrice(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    branchUuid: '22222222-2222-4222-8222-222222222222',
    productUuid: '33333333-3333-4333-8333-333333333333',
    priceType: 'regular',
    price: Decimal.parse('12.5'),
    startsAt: _transactionAt,
    endsAt: _transactionAt.add(const Duration(days: 30)),
    priority: 1,
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<PromotionRule> promotionRuleFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<PromotionRule>(
  tableName: 'promotion_rule',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('name', _t(l10n, 'Name', 'الاسم'), required: true),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID')),
    _textField('productUuid', _t(l10n, 'Product UUID', 'معرّف المنتج UUID')),
    _selectionField('discountType', _t(l10n, 'Discount type', 'نوع الخصم'), _discountTypeOptions(l10n), required: true),
    _decimalField('discountValue', _t(l10n, 'Discount value', 'قيمة الخصم'), required: true),
    _dateTimeField('startsAt', _t(l10n, 'Starts at', 'يبدأ في'), required: true),
    _dateTimeField('endsAt', _t(l10n, 'Ends at', 'ينتهي في')),
    _statusField(l10n),
  ],
  fromMap: PromotionRule.fromMap,
  toMap: (promotionRule) => promotionRule.toMap(),
  sampleModel: PromotionRule(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    name: 'Weekend Promo',
    branchUuid: '22222222-2222-4222-8222-222222222222',
    productUuid: '33333333-3333-4333-8333-333333333333',
    discountType: 'percent',
    discountValue: Decimal.parse('10'),
    startsAt: _transactionAt,
    endsAt: _transactionAt.add(const Duration(days: 7)),
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<StaffShift> staffShiftFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<StaffShift>(
  tableName: 'staff_shift',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID'), required: true),
    _textField('userUuid', _t(l10n, 'User UUID', 'معرّف المستخدم UUID'), required: true),
    _dateTimeField('shiftDate', _t(l10n, 'Shift date', 'تاريخ المناوبة'), required: true),
    _dateTimeField('startAt', _t(l10n, 'Start at', 'تبدأ في'), required: true),
    _dateTimeField('endAt', _t(l10n, 'End at', 'تنتهي في')),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _staffShiftStatusOptions(l10n), required: true),
  ],
  fromMap: StaffShift.fromMap,
  toMap: (staffShift) => staffShift.toMap(),
  sampleModel: StaffShift(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    branchUuid: '22222222-2222-4222-8222-222222222222',
    userUuid: '33333333-3333-4333-8333-333333333333',
    shiftDate: _transactionAt,
    startAt: _transactionAt,
    endAt: _transactionAt.add(const Duration(hours: 8)),
    status: 'scheduled',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<StaffAttendance> staffAttendanceFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<StaffAttendance>(
  tableName: 'staff_attendance',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('staffShiftUuid', _t(l10n, 'Staff shift UUID', 'معرّف المناوبة UUID'), required: true),
    _dateTimeField('checkInAt', _t(l10n, 'Check in at', 'وقت تسجيل الدخول')),
    _dateTimeField('checkOutAt', _t(l10n, 'Check out at', 'وقت تسجيل الخروج')),
    _integerField('minutesWorked', _t(l10n, 'Minutes worked', 'دقائق العمل')),
    _selectionField('status', _t(l10n, 'Status', 'الحالة'), _attendanceStatusOptions(l10n), required: true),
  ],
  fromMap: StaffAttendance.fromMap,
  toMap: (staffAttendance) => staffAttendance.toMap(),
  sampleModel: StaffAttendance(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    staffShiftUuid: '22222222-2222-4222-8222-222222222222',
    checkInAt: _transactionAt,
    checkOutAt: _transactionAt.add(const Duration(hours: 8)),
    minutesWorked: 480,
    status: 'present',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<StaffActivityLog> staffActivityLogFormDefinition(AppLocalizations l10n) => _serverBackedDefinition<StaffActivityLog>(
  tableName: 'staff_activity_log',
  fields: [
    _textField('ownerUuid', _t(l10n, 'Owner UUID', 'معرّف المالك UUID'), required: true),
    _textField('branchUuid', _t(l10n, 'Branch UUID', 'معرّف الفرع UUID')),
    _textField('userUuid', _t(l10n, 'User UUID', 'معرّف المستخدم UUID')),
    _textField('action', _t(l10n, 'Action', 'الإجراء'), required: true),
    _textField('entityType', _t(l10n, 'Entity type', 'نوع الكيان'), required: true),
    _textField('entityUuid', _t(l10n, 'Entity UUID', 'معرّف الكيان UUID')),
    ModelFormFieldDefinition(
      key: 'metadataJson',
      label: _t(l10n, 'Metadata (JSON)', 'بيانات إضافية (JSON)'),
      type: ModelFormFieldType.multiline,
      hintText: '{"channel":"manual"}',
      transformValue: (rawValue) {
        final rawText = (rawValue as String?)?.trim() ?? '';
        if (rawText.isEmpty) {
          return <String, dynamic>{};
        }
        try {
          final decoded = jsonDecode(rawText);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          }
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
        } catch (_) {
          // Fall back to preserving raw value for malformed input.
        }
        return <String, dynamic>{'raw': rawText};
      },
    ),
  ],
  fromMap: StaffActivityLog.fromMap,
  toMap: (staffActivityLog) => staffActivityLog.toMap(),
  sampleModel: StaffActivityLog(
    ownerUuid: '11111111-1111-4111-8111-111111111111',
    branchUuid: '22222222-2222-4222-8222-222222222222',
    userUuid: '33333333-3333-4333-8333-333333333333',
    action: 'create_invoice',
    entityType: 'sales_invoice',
    entityUuid: '44444444-4444-4444-8444-444444444444',
    metadataJson: <String, dynamic>{'channel': 'manual'},
    createdAt: _createdAt,
  ),
);

ModelFormDefinition<T> _serverBackedDefinition<T extends Object>({
  required String tableName,
  required List<ModelFormFieldDefinition> fields,
  required T Function(Map<String, dynamic> map) fromMap,
  required Map<String, dynamic> Function(T model) toMap,
  required T sampleModel,
  ModelAfterCreateHook<T>? afterCreateHook,
}) {
  final supabaseQuery = _supabaseQueryDelegate(tableName: tableName, fromMap: fromMap, toMap: toMap);
  final supabaseCreate = _supabaseCreateDelegate(tableName: tableName, fromMap: fromMap, toMap: toMap);
  final supabaseUpdate = _supabaseUpdateDelegate(tableName: tableName, fromMap: fromMap, toMap: toMap);
  final supabaseDelete = _supabaseDeleteDelegate(tableName: tableName, toMap: toMap);
  final localQuery = _localQueryDelegate(tableName: tableName, fromMap: fromMap, toMap: toMap);
  final localCreate = _localCreateDelegate(tableName: tableName, fromMap: fromMap, toMap: toMap);
  final localUpdate = _localUpdateDelegate(tableName: tableName, fromMap: fromMap, toMap: toMap);
  final localDelete = _localDeleteDelegate(tableName: tableName, toMap: toMap);

  return ModelFormDefinition<T>(
    fields: fields,
    fromMap: fromMap,
    toMap: toMap,
    sampleModel: sampleModel,
    afterCreateHook: afterCreateHook,
    queryDelegate: (request) async {
      switch (_storagePreferenceOrDefault()) {
        case StoragePreference.onlineOnly:
          return supabaseQuery(request);
        case StoragePreference.localOnly:
          return localQuery(request);
        case StoragePreference.hybrid:
          try {
            return await _hybridQueryDelegate(tableName: tableName, fromMap: fromMap, toMap: toMap)(request);
          } catch (_) {
            return localQuery(request);
          }
      }
    },
    createDelegate: (model) async {
      switch (_storagePreferenceOrDefault()) {
        case StoragePreference.onlineOnly:
          return supabaseCreate(model);
        case StoragePreference.localOnly:
          return localCreate(model, syncState: OfflineSyncState.pendingUpsert);
        case StoragePreference.hybrid:
          try {
            final created = await supabaseCreate(model);
            await localCreate(created, syncState: OfflineSyncState.synced);
            return created;
          } catch (_) {
            return localCreate(model, syncState: OfflineSyncState.pendingUpsert);
          }
      }
    },
    updateDelegate: (model) async {
      switch (_storagePreferenceOrDefault()) {
        case StoragePreference.onlineOnly:
          return supabaseUpdate(model);
        case StoragePreference.localOnly:
          return localUpdate(model, syncState: OfflineSyncState.pendingUpsert);
        case StoragePreference.hybrid:
          try {
            final updated = await supabaseUpdate(model);
            await localUpdate(updated, syncState: OfflineSyncState.synced);
            return updated;
          } catch (_) {
            return localUpdate(model, syncState: OfflineSyncState.pendingUpsert);
          }
      }
    },
    deleteDelegate: (model) async {
      switch (_storagePreferenceOrDefault()) {
        case StoragePreference.onlineOnly:
          await supabaseDelete(model);
          return;
        case StoragePreference.localOnly:
          await localDelete(model, syncState: OfflineSyncState.pendingDelete);
          return;
        case StoragePreference.hybrid:
          try {
            await supabaseDelete(model);
            await localDelete(model, syncState: OfflineSyncState.synced);
            return;
          } catch (_) {
            await localDelete(model, syncState: OfflineSyncState.pendingDelete);
            return;
          }
      }
    },
  );
}

ModelQueryDelegate<T> _supabaseQueryDelegate<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) {
  return (request) async {
    final records = await _fetchSupabaseRecords(tableName: tableName, fromMap: fromMap, toMap: toMap);
    return _buildQueryResult(records: records, request: request, toMap: toMap);
  };
}

ModelQueryDelegate<T> _hybridQueryDelegate<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) {
  return (request) async {
    final remoteRecords = await _fetchSupabaseRecords(tableName: tableName, fromMap: fromMap, toMap: toMap);
    final mergedRecords = _mergePendingLocalRecords(tableName: tableName, remoteRecords: remoteRecords, fromMap: fromMap, toMap: toMap);
    return _buildQueryResult(records: mergedRecords, request: request, toMap: toMap);
  };
}

ModelCreateDelegate<T> _supabaseCreateDelegate<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) {
  return (model) async {
    final client = Supabase.instance.client;
    final scope = await _resolveOwnerScope();
    final payload = _enforceTenantPayloadScope(
      tableName,
      Map<String, dynamic>.from(toMap(model))
      ..remove('id')
        ..removeWhere((key, value) => value == null),
      scope,
    );

    final inserted = await client.from(tableName).insert(payload).select().single();
    if (tableName == 'purchase_order_item') {
      final purchaseOrderUuid = payload['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        await _recalculatePurchaseOrderTotalRemote(purchaseOrderUuid: purchaseOrderUuid);
      }
    }
    return fromMap(Map<String, dynamic>.from(inserted));
  };
}

ModelUpdateDelegate<T> _supabaseUpdateDelegate<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) {
  return (model) async {
    final client = Supabase.instance.client;
    final scope = await _resolveOwnerScope();
    final payload = _enforceTenantPayloadScope(tableName, Map<String, dynamic>.from(toMap(model))..removeWhere((key, value) => value == null), scope);

    final updatedAt = DateTime.now().millisecondsSinceEpoch;
    payload['updatedAt'] = updatedAt;
    payload['updated_at'] = updatedAt;

    final uuid = payload['uuid'];
    final id = payload['id'];

    dynamic query = client.from(tableName).update(payload);
    query = _applyTenantQueryScope(query, tableName, scope);
    if (uuid != null && uuid.toString().isNotEmpty) {
      query = query.eq('uuid', uuid);
    } else if (id != null) {
      query = query.eq('id', id);
    }

    final updated = await query.select().maybeSingle();
    if (tableName == 'purchase_order_item') {
      final purchaseOrderUuid = payload['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        await _recalculatePurchaseOrderTotalRemote(purchaseOrderUuid: purchaseOrderUuid);
      }
    }
    if (updated == null) {
      return model;
    }
    return fromMap(Map<String, dynamic>.from(updated));
  };
}

ModelDeleteDelegate<T> _supabaseDeleteDelegate<T extends Object>({required String tableName, required Map<String, dynamic> Function(T model) toMap}) {
  return (model) async {
    final client = Supabase.instance.client;
    final scope = await _resolveOwnerScope();
    final data = _enforceTenantPayloadScope(tableName, toMap(model), scope);
    final uuid = data['uuid'];
    final id = data['id'];
    final now = DateTime.now().millisecondsSinceEpoch;

    final supportsSoftDelete = !_hardDeleteTables.contains(tableName);
    dynamic query = supportsSoftDelete ? client.from(tableName).update({'deletedAt': now, 'updatedAt': now}) : client.from(tableName).delete();
    query = _applyTenantQueryScope(query, tableName, scope);
    if (uuid != null && uuid.toString().isNotEmpty) {
      query = query.eq('uuid', uuid);
    } else if (id != null) {
      query = query.eq('id', id);
    }

    await query;

    if (tableName == 'purchase_order_item') {
      final purchaseOrderUuid = data['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        await _recalculatePurchaseOrderTotalRemote(purchaseOrderUuid: purchaseOrderUuid);
      }
    }
  };
}

ModelQueryDelegate<T> _localQueryDelegate<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) {
  return (request) async {
    final database = _requireLocalDatabase();
    final records = <T>[];

    for (final record in database.getRecordsForType(tableName)) {
      if (record.isDeleted) {
        continue;
      }

      try {
        final payload = Map<String, dynamic>.from(jsonDecode(record.payloadJson) as Map);
        final deletedAt = payload['deletedAt'] ?? payload['deleted_at'];
        if (deletedAt != null) {
          continue;
        }
        records.add(fromMap(payload));
      } catch (_) {
        // Ignore malformed cached records.
      }
    }

    return _buildQueryResult(records: records, request: request, toMap: toMap);
  };
}

Future<T> Function(T model, {int syncState}) _localCreateDelegate<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) {
  return (model, {int syncState = OfflineSyncState.pendingUpsert}) async {
    final database = _requireLocalDatabase();
    final now = DateTime.now().millisecondsSinceEpoch;
    final payload = Map<String, dynamic>.from(toMap(model))
      ..remove('id')
      ..removeWhere((key, value) => value == null);

    payload['createdAt'] ??= now;
    payload['updatedAt'] = now;
    payload['deletedAt'] = null;

    final recordUuid = _recordUuidFromPayload(payload, fallback: 'local-$now');
    database.putRecord(
      modelType: tableName,
      recordUuid: recordUuid,
      payloadJson: jsonEncode(payload),
      updatedAtMillis: _updatedAtMillisFromPayload(payload, fallback: now),
      syncState: syncState,
      isDeleted: false,
    );

    if (tableName == 'purchase_order_item') {
      final purchaseOrderUuid = payload['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        _recalculatePurchaseOrderTotalLocal(purchaseOrderUuid: purchaseOrderUuid);
      }
    }

    return fromMap(payload);
  };
}

Future<T> Function(T model, {int syncState}) _localUpdateDelegate<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) {
  return (model, {int syncState = OfflineSyncState.pendingUpsert}) async {
    final database = _requireLocalDatabase();
    final now = DateTime.now().millisecondsSinceEpoch;
    final payload = Map<String, dynamic>.from(toMap(model))..removeWhere((key, value) => value == null);

    payload['updatedAt'] = now;
    payload['deletedAt'] = null;

    final recordUuid = _recordUuidFromPayload(payload, fallback: 'local-$now');
    database.putRecord(
      modelType: tableName,
      recordUuid: recordUuid,
      payloadJson: jsonEncode(payload),
      updatedAtMillis: _updatedAtMillisFromPayload(payload, fallback: now),
      syncState: syncState,
      isDeleted: false,
    );

    if (tableName == 'purchase_order_item') {
      final purchaseOrderUuid = payload['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        _recalculatePurchaseOrderTotalLocal(purchaseOrderUuid: purchaseOrderUuid);
      }
    }

    return fromMap(payload);
  };
}

Future<void> Function(T model, {int syncState}) _localDeleteDelegate<T extends Object>({required String tableName, required Map<String, dynamic> Function(T model) toMap}) {
  return (model, {int syncState = OfflineSyncState.pendingDelete}) async {
    final database = _requireLocalDatabase();
    final now = DateTime.now().millisecondsSinceEpoch;
    final payload = Map<String, dynamic>.from(toMap(model))
      ..removeWhere((key, value) => value == null)
      ..['updatedAt'] = now;

    final supportsSoftDelete = !_hardDeleteTables.contains(tableName);
    if (supportsSoftDelete) {
      payload['deletedAt'] = now;
    }

    final recordUuid = _recordUuidFromPayload(payload, fallback: 'local-$now');
    if (supportsSoftDelete) {
      database.putRecord(modelType: tableName, recordUuid: recordUuid, payloadJson: jsonEncode(payload), updatedAtMillis: now, syncState: syncState, isDeleted: true);
    } else {
      database.removeRecord(modelType: tableName, recordUuid: recordUuid);
    }

    if (tableName == 'purchase_order_item') {
      final purchaseOrderUuid = payload['purchaseOrderUuid']?.toString();
      if (purchaseOrderUuid != null && purchaseOrderUuid.isNotEmpty) {
        _recalculatePurchaseOrderTotalLocal(purchaseOrderUuid: purchaseOrderUuid);
      }
    }
  };
}

const Set<String> _hardDeleteTables = <String>{'purchase_order_item', 'transfer_order_item', 'staff_attendance', 'staff_activity_log'};

Future<void> _recalculatePurchaseOrderTotalRemote({required String purchaseOrderUuid}) async {
  final client = Supabase.instance.client;
  final scope = await _resolveOwnerScope();

  final rows = await client.from('purchase_order_item').select('lineTotal').eq('purchaseOrderUuid', purchaseOrderUuid);

  var total = Decimal.zero;
  for (final row in rows as List<dynamic>) {
    final lineTotal = (row as Map<String, dynamic>)['lineTotal'];
    final parsed = _decimalOrZero(lineTotal);
    total += parsed;
  }

  final now = DateTime.now().millisecondsSinceEpoch;
  dynamic query = client.from('purchase_order').update({'totalAmount': total.toString(), 'updatedAt': now});
  query = _applyTenantQueryScope(query, 'purchase_order', scope).eq('uuid', purchaseOrderUuid);
  await query;
}

void _recalculatePurchaseOrderTotalLocal({required String purchaseOrderUuid}) {
  final database = LocalDatabase.current;
  if (database == null || !database.isAvailable) {
    return;
  }

  var total = Decimal.zero;
  for (final localRecord in database.getRecordsForType('purchase_order_item')) {
    if (localRecord.isDeleted) {
      continue;
    }

    try {
      final payload = Map<String, dynamic>.from(jsonDecode(localRecord.payloadJson) as Map);
      if (payload['purchaseOrderUuid']?.toString() != purchaseOrderUuid) {
        continue;
      }
      total += _decimalOrZero(payload['lineTotal']);
    } catch (_) {
      // Ignore malformed local records.
    }
  }

  for (final purchaseOrderRecord in database.getRecordsForType('purchase_order')) {
    try {
      final payload = Map<String, dynamic>.from(jsonDecode(purchaseOrderRecord.payloadJson) as Map);
      if (payload['uuid']?.toString() != purchaseOrderUuid) {
        continue;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      payload['totalAmount'] = total.toString();
      payload['updatedAt'] = now;
      database.putRecord(modelType: 'purchase_order', recordUuid: purchaseOrderRecord.recordUuid, payloadJson: jsonEncode(payload), updatedAtMillis: now, syncState: OfflineSyncState.pendingUpsert, isDeleted: false);
      return;
    } catch (_) {
      // Ignore malformed local records.
    }
  }
}

Decimal _decimalOrZero(Object? value) {
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

ModelQueryResult<T> _buildQueryResult<T extends Object>({required List<T> records, required ModelQueryRequest request, required Map<String, dynamic> Function(T model) toMap}) {
  final overallCount = records.length;
  final normalizedQuery = request.searchQuery.trim().toLowerCase();
  final filtered = normalizedQuery.isEmpty
      ? List<T>.from(records)
      : records
            .where((record) {
              final data = toMap(record);
              return data.values.any((value) => (value?.toString().toLowerCase() ?? '').contains(normalizedQuery));
            })
            .toList(growable: false);

  final sortColumnName = request.sortColumnName;
  if (sortColumnName != null && sortColumnName.isNotEmpty) {
    filtered.sort((left, right) {
      final leftValue = toMap(left)[sortColumnName];
      final rightValue = toMap(right)[sortColumnName];
      final compareResult = _compareSupabaseValues(leftValue, rightValue);
      return request.sortAscending ? compareResult : -compareResult;
    });
  }

  final totalCount = filtered.length;
  final pageSize = request.pageSize <= 0 ? 10 : request.pageSize;
  final pageIndex = request.pageIndex < 0 ? 0 : request.pageIndex;
  final start = (pageIndex * pageSize).clamp(0, totalCount);
  final end = (start + pageSize).clamp(0, totalCount);
  final paged = filtered.sublist(start, end);

  return ModelQueryResult<T>(records: paged, totalCount: totalCount, overallCount: overallCount);
}

Future<List<T>> _fetchSupabaseRecords<T extends Object>({required String tableName, required T Function(Map<String, dynamic> map) fromMap, required Map<String, dynamic> Function(T model) toMap}) async {
  final client = Supabase.instance.client;
  final scope = await _resolveOwnerScope();
  dynamic query = client.from(tableName).select();
  query = _applyTenantQueryScope(query, tableName, scope);
  final response = await query;
  final rows = (response as List<dynamic>).map((row) => Map<String, dynamic>.from(row as Map)).toList(growable: false);

  final records = <T>[];
  for (final row in rows) {
    try {
      final deletedAt = row['deletedAt'] ?? row['deleted_at'];
      if (deletedAt != null) {
        continue;
      }
      records.add(fromMap(Map<String, dynamic>.from(row)));
    } catch (_) {
      // Skip malformed rows so one bad record does not break the full list.
    }
  }

  _cacheRemoteRecords(tableName: tableName, records: records, toMap: toMap);
  return records;
}

List<T> _mergePendingLocalRecords<T extends Object>({
  required String tableName,
  required List<T> remoteRecords,
  required T Function(Map<String, dynamic> map) fromMap,
  required Map<String, dynamic> Function(T model) toMap,
}) {
  final database = LocalDatabase.current;
  if (database == null || !database.isAvailable) {
    return remoteRecords;
  }

  final recordByKey = <String, T>{for (final record in remoteRecords) _recordUuidFromPayload(toMap(record), fallback: toMap(record).toString()): record};

  for (final localRecord in database.getRecordsForType(tableName)) {
    if (localRecord.syncState == OfflineSyncState.synced) {
      continue;
    }

    if (localRecord.isDeleted || localRecord.syncState == OfflineSyncState.pendingDelete) {
      recordByKey.remove(localRecord.recordUuid);
      continue;
    }

    try {
      final payload = Map<String, dynamic>.from(jsonDecode(localRecord.payloadJson) as Map);
      recordByKey[localRecord.recordUuid] = fromMap(payload);
    } catch (_) {
      // Ignore malformed pending records.
    }
  }

  return recordByKey.values.toList(growable: false);
}

void _cacheRemoteRecords<T extends Object>({required String tableName, required List<T> records, required Map<String, dynamic> Function(T model) toMap}) {
  final database = LocalDatabase.current;
  if (database == null || !database.isAvailable) {
    return;
  }

  final remoteRecordUuids = <String>{};
  for (final record in records) {
    final payload = Map<String, dynamic>.from(toMap(record))..removeWhere((key, value) => value == null);
    final recordUuid = _recordUuidFromPayload(payload, fallback: payload.toString());
    remoteRecordUuids.add(recordUuid);
    database.putRecord(
      modelType: tableName,
      recordUuid: recordUuid,
      payloadJson: jsonEncode(payload),
      updatedAtMillis: _updatedAtMillisFromPayload(payload, fallback: DateTime.now().millisecondsSinceEpoch),
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
}

StoragePreference _storagePreferenceOrDefault() {
  return AppPreferencesController.current?.storagePreference ?? StoragePreference.hybrid;
}

LocalDatabase _requireLocalDatabase() {
  final database = LocalDatabase.current;
  if (database == null || !database.isAvailable) {
    throw StateError('Local storage is not available on this platform.');
  }
  return database;
}

String _recordUuidFromPayload(Map<String, dynamic> payload, {required String fallback}) {
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

int _updatedAtMillisFromPayload(Map<String, dynamic> payload, {required int fallback}) {
  final value = payload['updatedAt'] ?? payload['updated_at'];
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  return fallback;
}

int _compareSupabaseValues(Object? left, Object? right) {
  if (identical(left, right)) {
    return 0;
  }
  if (left == null) {
    return 1;
  }
  if (right == null) {
    return -1;
  }
  if (left is num && right is num) {
    return left.compareTo(right);
  }
  if (left is bool && right is bool) {
    return left == right ? 0 : (left ? 1 : -1);
  }
  return left.toString().toLowerCase().compareTo(right.toString().toLowerCase());
}

ModelFormFieldDefinition _textField(
  String key,
  String label, {
  ModelFormFieldType type = ModelFormFieldType.text,
  bool required = false,
  String? hintText,
}) {
  return ModelFormFieldDefinition(
    key: key,
    label: label,
    type: type,
    required: required,
    hintText: hintText,
  );
}

ModelFormFieldDefinition _multilineField(String key, String label, {bool required = false}) {
  return ModelFormFieldDefinition(
    key: key,
    label: label,
    type: ModelFormFieldType.multiline,
    required: required,
  );
}

ModelFormFieldDefinition _integerField(String key, String label, {bool required = false}) {
  return ModelFormFieldDefinition(
    key: key,
    label: label,
    type: ModelFormFieldType.integer,
    required: required,
  );
}

ModelFormFieldDefinition _decimalField(String key, String label, {bool required = false}) {
  return ModelFormFieldDefinition(
    key: key,
    label: label,
    type: ModelFormFieldType.decimal,
    required: required,
  );
}

ModelFormFieldDefinition _dateTimeField(String key, String label, {bool required = false}) {
  return ModelFormFieldDefinition(
    key: key,
    label: label,
    type: ModelFormFieldType.dateTime,
    required: required,
    transformValue: (rawValue) {
      if (rawValue == null) {
        return null;
      }
      final parsed = DateTime.parse(rawValue as String);
      return parsed.millisecondsSinceEpoch;
    },
  );
}

ModelFormFieldDefinition _selectionField(
  String key,
  String label,
  List<ModelFormSelectOption> options, {
  bool required = false,
}) {
  return ModelFormFieldDefinition(
    key: key,
    label: label,
    type: ModelFormFieldType.selection,
    required: required,
    options: options,
  );
}

ModelFormFieldDefinition _statusField(AppLocalizations l10n) {
  return _selectionField('status', _t(l10n, 'Status', 'الحالة'), _statusOptions(l10n), required: true);
}

List<ModelFormSelectOption> _statusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Active', 'نشط'), value: 1),
  ModelFormSelectOption(label: _t(l10n, 'Inactive', 'غير نشط'), value: 0),
];

List<ModelFormSelectOption> _paymentMethodOptions(AppLocalizations l10n) => [
  for (final method in StorePaymentMethod.values)
    ModelFormSelectOption(label: _enumLabel(l10n, method.name), value: method.value),
];

List<ModelFormSelectOption> _invoiceTypeOptions(AppLocalizations l10n) => [
  for (final type in StoreInvoiceType.values)
    ModelFormSelectOption(label: _enumLabel(l10n, type.name), value: type.value),
];

List<ModelFormSelectOption> _returnTypeOptions(AppLocalizations l10n) => [
  for (final type in StoreReturnType.values)
    ModelFormSelectOption(label: _enumLabel(l10n, type.name), value: type.value),
];

List<ModelFormSelectOption> _movementTypeOptions(AppLocalizations l10n) => [
  for (final type in InventoryMovementType.values)
    ModelFormSelectOption(label: _enumLabel(l10n, type.name), value: type.value),
];

List<ModelFormSelectOption> _referenceTypeOptions(AppLocalizations l10n) => [
  for (final type in InventoryReferenceType.values)
    ModelFormSelectOption(label: _enumLabel(l10n, type.name), value: type.value),
];

List<ModelFormSelectOption> _transactionTypeOptions(AppLocalizations l10n) => [
  for (final type in FinancialTransactionType.values)
    ModelFormSelectOption(label: _enumLabel(l10n, type.name), value: type.value),
];

List<ModelFormSelectOption> _sourceTypeOptions(AppLocalizations l10n) => [
  for (final type in FinancialSourceType.values)
    ModelFormSelectOption(label: _enumLabel(l10n, type.name), value: type.value),
];

List<ModelFormSelectOption> _entryTypeOptions(AppLocalizations l10n) => [
  for (final type in LedgerEntryType.values)
    ModelFormSelectOption(label: _enumLabel(l10n, type.name), value: type.value),
];

List<ModelFormSelectOption> _purchaseOrderStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Draft', 'مسودة'), value: 'draft'),
  ModelFormSelectOption(label: _t(l10n, 'Submitted', 'مُقدَّم'), value: 'submitted'),
  ModelFormSelectOption(label: _t(l10n, 'Partial received', 'استلام جزئي'), value: 'partial_received'),
  ModelFormSelectOption(label: _t(l10n, 'Received', 'مستلم'), value: 'received'),
  ModelFormSelectOption(label: _t(l10n, 'Cancelled', 'ملغي'), value: 'cancelled'),
];

List<ModelFormSelectOption> _supplierInvoiceStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Draft', 'مسودة'), value: 'draft'),
  ModelFormSelectOption(label: _t(l10n, 'Open', 'مفتوحة'), value: 'open'),
  ModelFormSelectOption(label: _t(l10n, 'Partially paid', 'مدفوعة جزئيا'), value: 'partially_paid'),
  ModelFormSelectOption(label: _t(l10n, 'Paid', 'مدفوعة'), value: 'paid'),
  ModelFormSelectOption(label: _t(l10n, 'Cancelled', 'ملغية'), value: 'cancelled'),
];

List<ModelFormSelectOption> _transferOrderStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Draft', 'مسودة'), value: 'draft'),
  ModelFormSelectOption(label: _t(l10n, 'Approved', 'معتمد'), value: 'approved'),
  ModelFormSelectOption(label: _t(l10n, 'In transit', 'قيد النقل'), value: 'in_transit'),
  ModelFormSelectOption(label: _t(l10n, 'Partially received', 'مستلم جزئيا'), value: 'partially_received'),
  ModelFormSelectOption(label: _t(l10n, 'Received', 'مستلم'), value: 'received'),
  ModelFormSelectOption(label: _t(l10n, 'Cancelled', 'ملغي'), value: 'cancelled'),
];

List<ModelFormSelectOption> _salesOrderStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Draft', 'مسودة'), value: 'draft'),
  ModelFormSelectOption(label: _t(l10n, 'Confirmed', 'مؤكد'), value: 'confirmed'),
  ModelFormSelectOption(label: _t(l10n, 'Fulfilled', 'منفذ'), value: 'fulfilled'),
  ModelFormSelectOption(label: _t(l10n, 'Cancelled', 'ملغي'), value: 'cancelled'),
];

List<ModelFormSelectOption> _pricingStrategyOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Branch', 'فرع'), value: 'branch'),
  ModelFormSelectOption(label: _t(l10n, 'Store', 'متجر'), value: 'store'),
];

List<ModelFormSelectOption> _salesInvoiceStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Open', 'مفتوحة'), value: 'open'),
  ModelFormSelectOption(label: _t(l10n, 'Partially paid', 'مدفوعة جزئيا'), value: 'partially_paid'),
  ModelFormSelectOption(label: _t(l10n, 'Paid', 'مدفوعة'), value: 'paid'),
  ModelFormSelectOption(label: _t(l10n, 'Void', 'ملغاة'), value: 'void'),
];

List<ModelFormSelectOption> _salesReturnStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Draft', 'مسودة'), value: 'draft'),
  ModelFormSelectOption(label: _t(l10n, 'Approved', 'معتمد'), value: 'approved'),
  ModelFormSelectOption(label: _t(l10n, 'Refunded', 'تم الاسترداد'), value: 'refunded'),
  ModelFormSelectOption(label: _t(l10n, 'Cancelled', 'ملغي'), value: 'cancelled'),
];

List<ModelFormSelectOption> _priceTypeOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Regular', 'عادي'), value: 'regular'),
  ModelFormSelectOption(label: _t(l10n, 'Promo', 'ترويجي'), value: 'promo'),
  ModelFormSelectOption(label: _t(l10n, 'Clearance', 'تصريف'), value: 'clearance'),
];

List<ModelFormSelectOption> _discountTypeOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Percent', 'نسبة'), value: 'percent'),
  ModelFormSelectOption(label: _t(l10n, 'Fixed', 'ثابت'), value: 'fixed'),
];

List<ModelFormSelectOption> _staffShiftStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Scheduled', 'مجدولة'), value: 'scheduled'),
  ModelFormSelectOption(label: _t(l10n, 'In progress', 'قيد التنفيذ'), value: 'in_progress'),
  ModelFormSelectOption(label: _t(l10n, 'Completed', 'مكتملة'), value: 'completed'),
  ModelFormSelectOption(label: _t(l10n, 'Cancelled', 'ملغاة'), value: 'cancelled'),
];

List<ModelFormSelectOption> _attendanceStatusOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Present', 'حاضر'), value: 'present'),
  ModelFormSelectOption(label: _t(l10n, 'Absent', 'غائب'), value: 'absent'),
  ModelFormSelectOption(label: _t(l10n, 'Late', 'متأخر'), value: 'late'),
  ModelFormSelectOption(label: _t(l10n, 'Half day', 'نصف يوم'), value: 'half_day'),
];

List<ModelFormSelectOption> _holderTypeOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'Store', 'متجر'), value: 'store'),
  ModelFormSelectOption(label: _t(l10n, 'Branch', 'فرع'), value: 'branch'),
];

List<ModelFormSelectOption> _inventoryTransactionTypeOptions(AppLocalizations l10n) => [
  ModelFormSelectOption(label: _t(l10n, 'In', 'وارد'), value: 'in'),
  ModelFormSelectOption(label: _t(l10n, 'Out', 'صادر'), value: 'out'),
  ModelFormSelectOption(label: _t(l10n, 'Transfer out', 'تحويل صادر'), value: 'transfer_out'),
  ModelFormSelectOption(label: _t(l10n, 'Transfer in', 'تحويل وارد'), value: 'transfer_in'),
  ModelFormSelectOption(label: _t(l10n, 'Adjustment', 'تسوية'), value: 'adjustment'),
  ModelFormSelectOption(label: _t(l10n, 'Sale', 'بيع'), value: 'sale'),
  ModelFormSelectOption(label: _t(l10n, 'Sale return', 'مرتجع بيع'), value: 'sale_return'),
  ModelFormSelectOption(label: _t(l10n, 'Purchase', 'شراء'), value: 'purchase'),
  ModelFormSelectOption(label: _t(l10n, 'Supplier return', 'مرتجع مورد'), value: 'supplier_return'),
];

String _enumLabel(AppLocalizations l10n, String value) {
  if (l10n.isArabic) {
    switch (value) {
      case 'inactive':
        return 'غير نشط';
      case 'active':
        return 'نشط';
      case 'cash':
        return 'نقدي';
      case 'bankTransfer':
        return 'تحويل بنكي';
      case 'card':
        return 'بطاقة';
      case 'cheque':
        return 'شيك';
      case 'mobileMoney':
        return 'محفظة إلكترونية';
      case 'other':
        return 'أخرى';
      case 'credit':
        return 'آجل';
      case 'salesReturn':
        return 'مرتجع مبيعات';
      case 'purchaseReturn':
        return 'مرتجع مشتريات';
      case 'adjustmentReturn':
        return 'مرتجع تسوية';
      case 'invoicePosting':
        return 'ترحيل فاتورة';
      case 'paymentReceipt':
        return 'استلام دفعة';
      case 'returnPosting':
        return 'ترحيل مرتجع';
      case 'adjustment':
        return 'تسوية';
      case 'paymentVoucher':
        return 'سند دفع';
      case 'storeReturn':
        return 'مرتجع متجر';
      case 'inventoryMovement':
        return 'حركة مخزون';
      case 'manual':
        return 'يدوي';
      case 'debit':
        return 'مدين';
      case 'purchase':
        return 'شراء';
      case 'sale':
        return 'بيع';
      case 'returnIn':
        return 'مرتجع وارد';
      case 'returnOut':
        return 'مرتجع صادر';
      case 'restock':
        return 'إعادة تزويد';
      case 'invoice':
        return 'فاتورة';
      case 'invoiceItem':
        return 'عنصر فاتورة';
      case 'returnItem':
        return 'عنصر مرتجع';
    }
  }

  final buffer = StringBuffer();
  for (var index = 0; index < value.length; index++) {
    final character = value[index];
    final isUpperCase = character.toUpperCase() == character && character.toLowerCase() != character;
    if (index > 0 && isUpperCase) {
      buffer.write(' ');
    }
    buffer.write(index == 0 ? character.toUpperCase() : character);
  }
  return buffer.toString();
}

String _t(AppLocalizations l10n, String english, String arabic) {
  return l10n.isArabic ? arabic : english;
}

String storeEntityLabel(AppLocalizations l10n) => _t(l10n, 'Store', 'متجر');
String branchEntityLabel(AppLocalizations l10n) => _t(l10n, 'Branch', 'فرع');
String productEntityLabel(AppLocalizations l10n) => _t(l10n, 'Product', 'منتج');
String categoryEntityLabel(AppLocalizations l10n) => _t(l10n, 'Category', 'فئة');
String tagEntityLabel(AppLocalizations l10n) => _t(l10n, 'Tag', 'وسم');
String clientEntityLabel(AppLocalizations l10n) => _t(l10n, 'Client', 'عميل');
String supplierEntityLabel(AppLocalizations l10n) => _t(l10n, 'Supplier', 'شركة');
String userEntityLabel(AppLocalizations l10n) => _t(l10n, 'User', 'مستخدم');
String roleEntityLabel(AppLocalizations l10n) => _t(l10n, 'Role', 'دور');
String invoiceEntityLabel(AppLocalizations l10n) => _t(l10n, 'Invoice', 'فاتورة');
String returnEntityLabel(AppLocalizations l10n) => _t(l10n, 'Return', 'مرتجع');
String paymentVoucherEntityLabel(AppLocalizations l10n) => _t(l10n, 'Payment voucher', 'سند دفع');
String inventoryMovementEntityLabel(AppLocalizations l10n) => _t(l10n, 'Inventory movement', 'حركة مخزون');
String transactionEntityLabel(AppLocalizations l10n) => _t(l10n, 'Transaction', 'عملية');
String purchaseOrderEntityLabel(AppLocalizations l10n) => _t(l10n, 'Purchase order', 'أمر شراء');
String purchaseOrderItemEntityLabel(AppLocalizations l10n) => _t(l10n, 'Purchase order item', 'عنصر أمر شراء');
String supplierInvoiceEntityLabel(AppLocalizations l10n) => _t(l10n, 'Supplier invoice', 'فاتورة مورد');
String inventoryBatchEntityLabel(AppLocalizations l10n) => _t(l10n, 'Inventory batch', 'دفعة مخزون');
String inventoryTransactionEntityLabel(AppLocalizations l10n) => _t(l10n, 'Inventory transaction', 'حركة مخزون تشغيلية');
String transferOrderEntityLabel(AppLocalizations l10n) => _t(l10n, 'Transfer order', 'أمر تحويل');
String transferOrderItemEntityLabel(AppLocalizations l10n) => _t(l10n, 'Transfer order item', 'عنصر أمر تحويل');
String salesOrderEntityLabel(AppLocalizations l10n) => _t(l10n, 'Sales order', 'أمر بيع');
String salesInvoiceEntityLabel(AppLocalizations l10n) => _t(l10n, 'Sales invoice', 'فاتورة بيع');
String salesReturnEntityLabel(AppLocalizations l10n) => _t(l10n, 'Sales return', 'مرتجع بيع');
String branchPriceEntityLabel(AppLocalizations l10n) => _t(l10n, 'Branch price', 'سعر الفرع');
String promotionRuleEntityLabel(AppLocalizations l10n) => _t(l10n, 'Promotion rule', 'قاعدة ترويجية');
String staffShiftEntityLabel(AppLocalizations l10n) => _t(l10n, 'Staff shift', 'مناوبة الموظف');
String staffAttendanceEntityLabel(AppLocalizations l10n) => _t(l10n, 'Staff attendance', 'حضور الموظف');
String staffActivityLogEntityLabel(AppLocalizations l10n) => _t(l10n, 'Staff activity log', 'سجل نشاط الموظف');

final DateTime _createdAt = DateTime(2024, 4, 20, 9, 0);
final DateTime _updatedAt = DateTime(2024, 4, 21, 14, 30);
final DateTime _transactionAt = DateTime(2024, 4, 26, 11, 45);

final OwnerScopeService _ownerScopeService = OwnerScopeService();
final InventoryTransactionService _inventoryTransactionService = InventoryTransactionService(ownerScopeService: _ownerScopeService);

const Set<String> _ownerScopedTables = <String>{
  'store',
  'branch',
  'products',
  'supplier',
  'client',
  'category',
  'tags',
  'roles',
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

const Set<String> _storeScopedTables = <String>{'store_supplier', 'store_client', 'store_user', 'store_branches'};
const Set<String> _branchScopedTables = <String>{'branch_product'};
const Set<String> _selfScopedTables = <String>{'users'};

Future<OwnerScope> _resolveOwnerScope() => _ownerScopeService.resolveCurrentScope();

Map<String, dynamic> _enforceTenantPayloadScope(String tableName, Map<String, dynamic> payload, OwnerScope scope) {
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

dynamic _applyTenantQueryScope(dynamic query, String tableName, OwnerScope scope) {
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

String? _stringOrNull(Object? value) {
  final normalized = value?.toString().trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized;
}

int? _intOrNull(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }

  final normalized = _stringOrNull(value);
  if (normalized == null) {
    return null;
  }

  return int.tryParse(normalized);
}

num? _numOrNull(Object? value) {
  if (value is num) {
    return value;
  }

  final normalized = _stringOrNull(value);
  if (normalized == null) {
    return null;
  }

  return num.tryParse(normalized);
}

