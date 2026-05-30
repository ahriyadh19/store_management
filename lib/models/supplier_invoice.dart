// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class SupplierInvoice extends StatusedSyncModel<String> {
  String ownerUuid;
  String storeUuid;
  String supplierUuid;
  String? purchaseOrderUuid;
  String supplierInvoiceNumber;
  DateTime invoiceDate;
  DateTime? dueDate;
  String currencyCode;
  Decimal subtotal;
  Decimal taxAmount;
  Decimal totalAmount;

  SupplierInvoice({
    super.id = 0,
    super.uuid,
    required this.ownerUuid,
    required this.storeUuid,
    required this.supplierUuid,
    this.purchaseOrderUuid,
    required this.supplierInvoiceNumber,
    required this.invoiceDate,
    this.dueDate,
    required this.currencyCode,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  SupplierInvoice copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? storeUuid,
    String? supplierUuid,
    String? purchaseOrderUuid,
    String? supplierInvoiceNumber,
    DateTime? invoiceDate,
    DateTime? dueDate,
    String? currencyCode,
    Decimal? subtotal,
    Decimal? taxAmount,
    Decimal? totalAmount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return SupplierInvoice(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      storeUuid: storeUuid ?? this.storeUuid,
      supplierUuid: supplierUuid ?? this.supplierUuid,
      purchaseOrderUuid: purchaseOrderUuid ?? this.purchaseOrderUuid,
      supplierInvoiceNumber: supplierInvoiceNumber ?? this.supplierInvoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      dueDate: dueDate ?? this.dueDate,
      currencyCode: currencyCode ?? this.currencyCode,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerUuid': ownerUuid,
      'storeUuid': storeUuid,
      'supplierUuid': supplierUuid,
      'purchaseOrderUuid': purchaseOrderUuid,
      'supplierInvoiceNumber': supplierInvoiceNumber,
      'invoiceDate': invoiceDate.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'currencyCode': currencyCode,
      'subtotal': subtotal.toString(),
      'taxAmount': taxAmount.toString(),
      'totalAmount': totalAmount.toString(),
      ...statusedSyncMap(),
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'owner_uuid': ownerUuid,
      'store_uuid': storeUuid,
      'supplier_uuid': supplierUuid,
      'purchase_order_uuid': purchaseOrderUuid,
      'supplier_invoice_number': supplierInvoiceNumber,
      'invoice_date': ModelParsing.dateTimeToIso8601Utc(invoiceDate),
      'due_date': ModelParsing.dateTimeOrNullToIso8601Utc(dueDate),
      'currency_code': currencyCode,
      'subtotal': subtotal.toString(),
      'tax_amount': taxAmount.toString(),
      'total_amount': totalAmount.toString(),
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory SupplierInvoice.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;

    return SupplierInvoice(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      supplierUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'supplierUuid'), 'supplierUuid'),
      purchaseOrderUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'purchaseOrderUuid')),
      supplierInvoiceNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'supplierInvoiceNumber'), 'supplierInvoiceNumber'),
      invoiceDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'invoiceDate'), 'invoiceDate'),
      dueDate: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'dueDate')),
      currencyCode: ModelParsing.stringOrThrow(ModelParsing.value(map, 'currencyCode'), 'currencyCode'),
      subtotal: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'subtotal'), 'subtotal'),
      taxAmount: ModelParsing.decimalOrNull(ModelParsing.value(map, 'taxAmount')) ?? Decimal.zero,
      totalAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'totalAmount'), 'totalAmount'),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierInvoice.fromJson(String source) =>
      SupplierInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SupplierInvoice(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, storeUuid: $storeUuid, supplierUuid: $supplierUuid, purchaseOrderUuid: $purchaseOrderUuid, supplierInvoiceNumber: $supplierInvoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, currencyCode: $currencyCode, subtotal: $subtotal, taxAmount: $taxAmount, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...statusedSyncProps,
    ownerUuid,
    storeUuid,
    supplierUuid,
    purchaseOrderUuid,
    supplierInvoiceNumber,
    invoiceDate,
    dueDate,
    currencyCode,
    subtotal,
    taxAmount,
    totalAmount,
  ];
}
