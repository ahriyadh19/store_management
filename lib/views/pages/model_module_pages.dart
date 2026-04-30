import 'package:decimal/decimal.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/models/categories.dart';
import 'package:store_management/models/client.dart';
import 'package:store_management/models/company.dart';
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
final ModelFormDefinition<Store> storeFormDefinition = ModelFormDefinition<Store>(
  fields: [
    _textField('name', 'Store name', required: true),
    _multilineField('description', 'Description', required: true),
    _multilineField('address', 'Address', required: true),
    _textField('phone', 'Phone', type: ModelFormFieldType.phone, required: true),
    _textField('email', 'Email', type: ModelFormFieldType.email, required: true),
  ],
  fromMap: Store.fromMap,
  toMap: (store) => store.toMap(),
  sampleModel: Store(
    name: 'Central Store',
    description: 'Primary retail location and stock coordination point.',
    address: '12 Commerce Ave, Downtown',
    phone: '+967700000001',
    email: 'central@store.app',
  ),
);

final ModelFormDefinition<Branch> branchFormDefinition = ModelFormDefinition<Branch>(
  fields: [
    _textField('name', 'Branch name', required: true),
    _multilineField('description', 'Description', required: true),
    _multilineField('address', 'Address', required: true),
    _textField('phone', 'Phone', type: ModelFormFieldType.phone, required: true),
    _textField('email', 'Email', type: ModelFormFieldType.email, required: true),
    _statusField(),
  ],
  fromMap: Branch.fromMap,
  toMap: (branch) => branch.toMap(),
  sampleModel: Branch(
    name: 'North Branch',
    description: 'Regional storefront for walk-in sales.',
    address: '45 Market Road, North District',
    phone: '+967700000002',
    email: 'north.branch@store.app',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<Product> productFormDefinition = ModelFormDefinition<Product>(
  fields: [
    _textField('name', 'Product name', required: true),
    _multilineField('description', 'Description', required: true),
    _statusField(),
  ],
  fromMap: Product.fromMap,
  toMap: (product) => product.toMap(),
  sampleModel: Product(
    name: 'Premium Flour 25kg',
    description: 'Bulk flour package used by regular wholesale customers.',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<Categories> categoryFormDefinition = ModelFormDefinition<Categories>(
  fields: [
    _textField('name', 'Category name', required: true),
    _multilineField('description', 'Description', required: true),
    _textField('parentUuid', 'Parent category UUID'),
    _statusField(),
  ],
  fromMap: Categories.fromMap,
  toMap: (category) => category.toMap(),
  sampleModel: Categories(
    name: 'Bakery Supplies',
    description: 'Flour, sugar, yeast, and baking accessories.',
    status: RecordStatus.active.code,
    parentUuid: null,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<Tags> tagFormDefinition = ModelFormDefinition<Tags>(
  fields: [
    _textField('name', 'Tag name', required: true),
    _multilineField('description', 'Description', required: true),
    _statusField(),
  ],
  fromMap: Tags.fromMap,
  toMap: (tag) => tag.toMap(),
  sampleModel: Tags(
    name: 'Fast moving',
    description: 'Products with high turnover and replenishment priority.',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<Client> clientFormDefinition = ModelFormDefinition<Client>(
  fields: [
    _textField('name', 'Client name', required: true),
    _multilineField('description', 'Description', required: true),
    _textField('email', 'Email', type: ModelFormFieldType.email, required: true),
    _textField('phone', 'Phone', type: ModelFormFieldType.phone, required: true),
    _multilineField('address', 'Address', required: true),
    _decimalField('creditLimit', 'Credit limit', required: true),
    _decimalField('currentCredit', 'Current credit', required: true),
    _decimalField('availableCredit', 'Available credit', required: true),
    _statusField(),
  ],
  fromMap: Client.fromMap,
  toMap: (client) => client.toMap(),
  sampleModel: Client(
    name: 'Blue Market',
    description: 'High-volume client with monthly billing terms.',
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

final ModelFormDefinition<Company> companyFormDefinition = ModelFormDefinition<Company>(
  fields: [
    _textField('name', 'Company name', required: true),
    _multilineField('description', 'Description', required: true),
    _statusField(),
  ],
  fromMap: Company.fromMap,
  toMap: (company) => company.toMap(),
  sampleModel: Company(
    name: 'Al Noor Trading',
    description: 'Primary supplier of packaged food and household items.',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<User> userFormDefinition = ModelFormDefinition<User>(
  fields: [
    _textField('name', 'Full name', required: true),
    _textField('username', 'Username', required: true),
    _textField('email', 'Email', type: ModelFormFieldType.email, required: true),
    _textField(
      'password',
      'Password',
      hintText: 'Leave empty when not changing the password.',
    ),
    _statusField(),
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

final ModelFormDefinition<Roles> roleFormDefinition = ModelFormDefinition<Roles>(
  fields: [
    _textField('name', 'Role name', required: true),
    _multilineField('description', 'Description', required: true),
    _statusField(),
  ],
  fromMap: Roles.fromMap,
  toMap: (role) => role.toMap(),
  sampleModel: Roles(
    name: 'Store Supervisor',
    description: 'Can manage inventory updates, clients, and invoice approvals.',
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<StoreInvoice> invoiceFormDefinition = ModelFormDefinition<StoreInvoice>(
  fields: [
    _textField('storeUuid', 'Store UUID', required: true),
    _textField('clientUuid', 'Client UUID', required: true),
    _textField('invoiceNumber', 'Invoice number', required: true),
    _selectionField('invoiceType', 'Invoice type', _invoiceTypeOptions, required: true),
    _integerField('itemCount', 'Item count', required: true),
    _decimalField('totalAmount', 'Total amount', required: true),
    _decimalField('paidAmount', 'Paid amount', required: true),
    _decimalField('balanceAmount', 'Balance amount', required: true),
    _multilineField('notes', 'Notes', required: true),
    _dateTimeField('issuedAt', 'Issued at', required: true),
    _dateTimeField('dueAt', 'Due at', required: true),
    _statusField(),
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
    notes: 'Deliver through branch pickup.',
    issuedAt: _transactionAt,
    dueAt: _transactionAt.add(const Duration(days: 14)),
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<StoreReturn> returnFormDefinition = ModelFormDefinition<StoreReturn>(
  fields: [
    _textField('storeUuid', 'Store UUID', required: true),
    _textField('clientUuid', 'Client UUID', required: true),
    _textField('returnNumber', 'Return number', required: true),
    _selectionField('returnType', 'Return type', _returnTypeOptions, required: true),
    _integerField('itemCount', 'Item count', required: true),
    _decimalField('totalAmount', 'Total amount', required: true),
    _multilineField('reason', 'Reason', required: true),
    _dateTimeField('transactionDate', 'Transaction date', required: true),
    _statusField(),
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
    reason: 'Packaging arrived damaged during delivery.',
    transactionDate: _transactionAt,
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<StorePaymentVoucher> paymentVoucherFormDefinition = ModelFormDefinition<StorePaymentVoucher>(
  fields: [
    _textField('storeUuid', 'Store UUID', required: true),
    _textField('clientUuid', 'Client UUID', required: true),
    _textField('voucherNumber', 'Voucher number', required: true),
    _textField('payeeName', 'Payee name', required: true),
    _decimalField('amount', 'Amount', required: true),
    _selectionField('paymentMethod', 'Payment method', _paymentMethodOptions, required: true),
    _textField('referenceNumber', 'Reference number', required: true),
    _multilineField('description', 'Description', required: true),
    _dateTimeField('transactionDate', 'Transaction date', required: true),
    _statusField(),
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
    description: 'Partial settlement for credit invoice.',
    transactionDate: _transactionAt,
    status: RecordStatus.active.code,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<InventoryMovement> inventoryMovementFormDefinition = ModelFormDefinition<InventoryMovement>(
  fields: [
    _textField('companyProductUuid', 'Company product UUID', required: true),
    _textField('productUuid', 'Product UUID', required: true),
    _selectionField('movementType', 'Movement type', _movementTypeOptions, required: true),
    _integerField('quantityDelta', 'Quantity delta', required: true),
    _integerField('balanceAfter', 'Balance after', required: true),
    _decimalField('unitCost', 'Unit cost'),
    _selectionField('referenceType', 'Reference type', _referenceTypeOptions, required: true),
    _textField('referenceUuid', 'Reference UUID'),
    _multilineField('note', 'Note', required: true),
    _textField('createdByUserUuid', 'Created by user UUID'),
  ],
  fromMap: InventoryMovement.fromMap,
  toMap: (movement) => movement.toMap(),
  sampleModel: InventoryMovement(
    companyProductUuid: 'company-product-001',
    productUuid: 'product-flour-001',
    movementType: InventoryMovementType.restock,
    quantityDelta: 50,
    balanceAfter: 180,
    unitCost: Decimal.parse('9.75'),
    referenceType: InventoryReferenceType.restock,
    referenceUuid: 'restock-2024-0005',
    note: 'Weekly replenishment from warehouse.',
    createdByUserUuid: 'user-ops-manager-001',
    createdAt: _createdAt,
    updatedAt: _updatedAt,
  ),
);

final ModelFormDefinition<StoreFinancialTransaction> transactionFormDefinition = ModelFormDefinition<StoreFinancialTransaction>(
  fields: [
    _textField('storeUuid', 'Store UUID', required: true),
    _textField('clientUuid', 'Client UUID', required: true),
    _textField('transactionNumber', 'Transaction number', required: true),
    _selectionField('transactionType', 'Transaction type', _transactionTypeOptions, required: true),
    _selectionField('sourceType', 'Source type', _sourceTypeOptions, required: true),
    _textField('sourceUuid', 'Source UUID', required: true),
    _decimalField('amount', 'Amount', required: true),
    _selectionField('entryType', 'Entry type', _entryTypeOptions, required: true),
    _multilineField('description', 'Description', required: true),
    _dateTimeField('transactionDate', 'Transaction date', required: true),
    _statusField(),
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
    description: 'Payment receipt linked to voucher settlement.',
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

ModelFormFieldDefinition _statusField() {
  return _selectionField('status', 'Status', _statusOptions, required: true);
}

final List<ModelFormSelectOption> _statusOptions = [
  const ModelFormSelectOption(label: 'Active', value: 1),
  const ModelFormSelectOption(label: 'Inactive', value: 0),
];

final List<ModelFormSelectOption> _paymentMethodOptions = [
  for (final method in StorePaymentMethod.values)
    ModelFormSelectOption(label: _enumLabel(method.name), value: method.value),
];

final List<ModelFormSelectOption> _invoiceTypeOptions = [
  for (final type in StoreInvoiceType.values)
    ModelFormSelectOption(label: _enumLabel(type.name), value: type.value),
];

final List<ModelFormSelectOption> _returnTypeOptions = [
  for (final type in StoreReturnType.values)
    ModelFormSelectOption(label: _enumLabel(type.name), value: type.value),
];

final List<ModelFormSelectOption> _movementTypeOptions = [
  for (final type in InventoryMovementType.values)
    ModelFormSelectOption(label: _enumLabel(type.name), value: type.value),
];

final List<ModelFormSelectOption> _referenceTypeOptions = [
  for (final type in InventoryReferenceType.values)
    ModelFormSelectOption(label: _enumLabel(type.name), value: type.value),
];

final List<ModelFormSelectOption> _transactionTypeOptions = [
  for (final type in FinancialTransactionType.values)
    ModelFormSelectOption(label: _enumLabel(type.name), value: type.value),
];

final List<ModelFormSelectOption> _sourceTypeOptions = [
  for (final type in FinancialSourceType.values)
    ModelFormSelectOption(label: _enumLabel(type.name), value: type.value),
];

final List<ModelFormSelectOption> _entryTypeOptions = [
  for (final type in LedgerEntryType.values)
    ModelFormSelectOption(label: _enumLabel(type.name), value: type.value),
];

String _enumLabel(String value) {
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

final DateTime _createdAt = DateTime(2024, 4, 20, 9, 0);
final DateTime _updatedAt = DateTime(2024, 4, 21, 14, 30);
final DateTime _transactionAt = DateTime(2024, 4, 26, 11, 45);
