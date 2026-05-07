// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class SupplierInvoice {
  @Id()
  int id = 0;
  String uuid;
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
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  SupplierInvoice({
    this.id = 0,
    String? uuid,
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
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

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
      'id': id,
      'uuid': uuid,
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
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
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

  factory SupplierInvoice.fromJson(String source) => SupplierInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SupplierInvoice(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, storeUuid: $storeUuid, supplierUuid: $supplierUuid, purchaseOrderUuid: $purchaseOrderUuid, supplierInvoiceNumber: $supplierInvoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, currencyCode: $currencyCode, subtotal: $subtotal, taxAmount: $taxAmount, totalAmount: $totalAmount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant SupplierInvoice other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.ownerUuid == ownerUuid &&
        other.storeUuid == storeUuid &&
        other.supplierUuid == supplierUuid &&
        other.purchaseOrderUuid == purchaseOrderUuid &&
        other.supplierInvoiceNumber == supplierInvoiceNumber &&
        other.invoiceDate == invoiceDate &&
        other.dueDate == dueDate &&
        other.currencyCode == currencyCode &&
        other.subtotal == subtotal &&
        other.taxAmount == taxAmount &&
        other.totalAmount == totalAmount &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        ownerUuid.hashCode ^
        storeUuid.hashCode ^
        supplierUuid.hashCode ^
        purchaseOrderUuid.hashCode ^
        supplierInvoiceNumber.hashCode ^
        invoiceDate.hashCode ^
        dueDate.hashCode ^
        currencyCode.hashCode ^
        subtotal.hashCode ^
        taxAmount.hashCode ^
        totalAmount.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}
