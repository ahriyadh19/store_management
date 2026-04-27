enum RecordStatus {
  inactive(0),
  active(1);

  const RecordStatus(this.code);

  final int code;

  static RecordStatus fromCode(int code) {
    return RecordStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => throw FormatException('Unsupported record status code: $code'),
    );
  }
}

enum StorePaymentMethod {
  cash('cash'),
  bankTransfer('bank_transfer'),
  card('card'),
  cheque('cheque'),
  mobileMoney('mobile_money'),
  other('other');

  const StorePaymentMethod(this.value);

  final String value;

  static StorePaymentMethod fromValue(String value) {
    return StorePaymentMethod.values.firstWhere(
      (method) => method.value == value,
      orElse: () => throw FormatException('Unsupported payment method: $value'),
    );
  }
}

enum StoreReturnType {
  salesReturn('sales_return'),
  purchaseReturn('purchase_return'),
  adjustmentReturn('adjustment_return');

  const StoreReturnType(this.value);

  final String value;

  static StoreReturnType fromValue(String value) {
    return StoreReturnType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unsupported return type: $value'),
    );
  }
}

enum FinancialTransactionType {
  invoicePosting('invoice_posting'),
  paymentReceipt('payment_receipt'),
  returnPosting('return_posting'),
  adjustment('adjustment');

  const FinancialTransactionType(this.value);

  final String value;

  static FinancialTransactionType fromValue(String value) {
    return FinancialTransactionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unsupported transaction type: $value'),
    );
  }
}

enum FinancialSourceType {
  invoice('invoice'),
  paymentVoucher('payment_voucher'),
  storeReturn('store_return'),
  inventoryMovement('inventory_movement'),
  manual('manual');

  const FinancialSourceType(this.value);

  final String value;

  static FinancialSourceType fromValue(String value) {
    return FinancialSourceType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unsupported source type: $value'),
    );
  }
}

enum LedgerEntryType {
  debit('debit'),
  credit('credit');

  const LedgerEntryType(this.value);

  final String value;

  static LedgerEntryType fromValue(String value) {
    return LedgerEntryType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unsupported ledger entry type: $value'),
    );
  }
}

enum InventoryMovementType {
  purchase('purchase'),
  sale('sale'),
  returnIn('return_in'),
  returnOut('return_out'),
  restock('restock'),
  adjustment('adjustment');

  const InventoryMovementType(this.value);

  final String value;

  static InventoryMovementType fromValue(String value) {
    return InventoryMovementType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unsupported inventory movement type: $value'),
    );
  }
}

enum InventoryReferenceType {
  invoice('invoice'),
  invoiceItem('invoice_item'),
  storeReturn('store_return'),
  returnItem('return_item'),
  restock('restock'),
  adjustment('adjustment');

  const InventoryReferenceType(this.value);

  final String value;

  static InventoryReferenceType fromValue(String value) {
    return InventoryReferenceType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unsupported inventory reference type: $value'),
    );
  }
}