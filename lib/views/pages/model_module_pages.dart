import 'package:decimal/decimal.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/models/categories.dart';
import 'package:store_management/models/client.dart';
import 'package:store_management/models/supplier.dart';
import 'package:store_management/models/inventory_movement.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/product.dart';
import 'package:store_management/models/roles.dart';
import 'package:store_management/models/store.dart';
import 'package:store_management/models/store_financial_transaction.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/models/store_payment_voucher.dart';
import 'package:store_management/models/store_return.dart';
import 'package:store_management/models/tags.dart';
import 'package:store_management/models/users.dart';
import 'package:store_management/views/components/model_form.dart';
ModelFormDefinition<Store> storeFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Store>(
  fields: [
    _textField('name', _t(l10n, 'Store name', 'اسم المتجر'), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _multilineField('address', _t(l10n, 'Address', 'العنوان'), required: true),
    _textField('phone', _t(l10n, 'Phone', 'الهاتف'), type: ModelFormFieldType.phone, required: true),
    _textField('email', _t(l10n, 'Email', 'البريد الإلكتروني'), type: ModelFormFieldType.email, required: true),
  ],
  fromMap: Store.fromMap,
  toMap: (store) => store.toMap(),
  sampleModel: Store(
    name: 'Central Store',
    description: _t(l10n, 'Primary retail location and stock coordination point.', 'موقع البيع الرئيسي ونقطة تنسيق المخزون.'),
    address: '12 Commerce Ave, Downtown',
    phone: '+967700000001',
    email: 'central@store.app',
  ),
);

ModelFormDefinition<Branch> branchFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Branch>(
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

ModelFormDefinition<Product> productFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Product>(
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

ModelFormDefinition<Categories> categoryFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Categories>(
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

ModelFormDefinition<Tags> tagFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Tags>(
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

ModelFormDefinition<Client> clientFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Client>(
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

ModelFormDefinition<Supplier> supplierFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Supplier>(
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

ModelFormDefinition<User> userFormDefinition(AppLocalizations l10n) => ModelFormDefinition<User>(
  fields: [
    _textField('name', _t(l10n, 'Full name', 'الاسم الكامل'), required: true),
    _textField('username', _t(l10n, 'Username', 'اسم المستخدم'), required: true),
    _textField('email', _t(l10n, 'Email', 'البريد الإلكتروني'), type: ModelFormFieldType.email, required: true),
    _textField(
      'password',
      _t(l10n, 'Password', 'كلمة المرور'),
      hintText: _t(l10n, 'Leave empty when not changing the password.', 'اتركه فارغًا عند عدم تغيير كلمة المرور.'),
    ),
    _statusField(l10n),
  ],
  fromMap: User.fromMap,
  toMap: (user) => user.toMap(includePassword: false),
  sampleModel: User(
    name: 'Operations Manager',
    username: 'ops.manager',
    email: 'ops.manager@store.app',
    password: '',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

ModelFormDefinition<Roles> roleFormDefinition(AppLocalizations l10n) => ModelFormDefinition<Roles>(
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

ModelFormDefinition<StoreInvoice> invoiceFormDefinition(AppLocalizations l10n) => ModelFormDefinition<StoreInvoice>(
  fields: [
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('clientUuid', _t(l10n, 'Client UUID', 'معرّف العميل UUID'), required: true),
    _textField('invoiceNumber', _t(l10n, 'Invoice number', 'رقم الفاتورة'), required: true),
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

ModelFormDefinition<StoreReturn> returnFormDefinition(AppLocalizations l10n) => ModelFormDefinition<StoreReturn>(
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

ModelFormDefinition<StorePaymentVoucher> paymentVoucherFormDefinition(AppLocalizations l10n) => ModelFormDefinition<StorePaymentVoucher>(
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

ModelFormDefinition<InventoryMovement> inventoryMovementFormDefinition(AppLocalizations l10n) => ModelFormDefinition<InventoryMovement>(
  fields: [
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

ModelFormDefinition<StoreFinancialTransaction> transactionFormDefinition(AppLocalizations l10n) => ModelFormDefinition<StoreFinancialTransaction>(
  fields: [
    _textField('storeUuid', _t(l10n, 'Store UUID', 'معرّف المتجر UUID'), required: true),
    _textField('clientUuid', _t(l10n, 'Client UUID', 'معرّف العميل UUID'), required: true),
    _textField('transactionNumber', _t(l10n, 'Transaction number', 'رقم العملية'), required: true),
    _selectionField('transactionType', _t(l10n, 'Transaction type', 'نوع العملية'), _transactionTypeOptions(l10n), required: true),
    _selectionField('sourceType', _t(l10n, 'Source type', 'نوع المصدر'), _sourceTypeOptions(l10n), required: true),
    _textField('sourceUuid', _t(l10n, 'Source UUID', 'معرّف المصدر UUID'), required: true),
    _decimalField('amount', _t(l10n, 'Amount', 'المبلغ'), required: true),
    _selectionField('entryType', _t(l10n, 'Entry type', 'نوع القيد'), _entryTypeOptions(l10n), required: true),
    _multilineField('description', _t(l10n, 'Description', 'الوصف'), required: true),
    _dateTimeField('transactionDate', _t(l10n, 'Transaction date', 'تاريخ العملية'), required: true),
    _statusField(l10n),
  ],
  fromMap: StoreFinancialTransaction.fromMap,
  toMap: (transaction) => transaction.toMap(),
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

final DateTime _createdAt = DateTime(2024, 4, 20, 9, 0);
final DateTime _updatedAt = DateTime(2024, 4, 21, 14, 30);
final DateTime _transactionAt = DateTime(2024, 4, 26, 11, 45);
