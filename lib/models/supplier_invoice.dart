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
  String invoiceNumber;
  DateTime invoiceDate;
  DateTime? dueDate;
  String currencyCode;
  Decimal totalAmount;
  Decimal taxAmount;
  Decimal discountAmount;
  Decimal netAmount;
  String status;
  String notes;
  String? createdByUserUuid;
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
    required this.invoiceNumber,
    required this.invoiceDate,
    this.dueDate,
    required this.currencyCode,
    required this.totalAmount,
    required this.taxAmount,
    required this.discountAmount,
    required this.netAmount,
    required this.status,
    required this.notes,
    this.createdByUserUuid,
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
    String? invoiceNumber,
    DateTime? invoiceDate,
    DateTime? dueDate,
    String? currencyCode,
    Decimal? totalAmount,
    Decimal? taxAmount,
    Decimal? discountAmount,
    Decimal? netAmount,
    String? status,
    String? notes,
    String? createdByUserUuid,
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
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      dueDate: dueDate ?? this.dueDate,
      currencyCode: currencyCode ?? this.currencyCode,
      totalAmount: totalAmount ?? this.totalAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      netAmount: netAmount ?? this.netAmount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdByUserUuid: createdByUserUuid ?? this.createdByUserUuid,
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
      'invoiceNumber': invoiceNumber,
      'invoiceDate': invoiceDate.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'currencyCode': currencyCode,
      'totalAmount': totalAmount.toString(),
      'taxAmount': taxAmount.toString(),
      'discountAmount': discountAmount.toString(),
      'netAmount': netAmount.toString(),
      'status': status,
      'notes': notes,
      'createdByUserUuid': createdByUserUuid,
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
      'invoice_number': invoiceNumber,
      'invoice_date': ModelParsing.dateTimeToIso8601Utc(invoiceDate),
      'due_date': ModelParsing.dateTimeOrNullToIso8601Utc(dueDate),
      'currency_code': currencyCode,
      'total_amount': totalAmount.toString(),
      'tax_amount': taxAmount.toString(),
      'discount_amount': discountAmount.toString(),
      'net_amount': netAmount.toString(),
      'status': status,
      'notes': notes,
      'created_by_user_uuid': createdByUserUuid,
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
      invoiceNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'invoiceNumber'), 'invoiceNumber'),
      invoiceDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'invoiceDate'), 'invoiceDate'),
      dueDate: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'dueDate')),
      currencyCode: ModelParsing.stringOrThrow(ModelParsing.value(map, 'currencyCode'), 'currencyCode'),
      totalAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'totalAmount'), 'totalAmount'),
      taxAmount: ModelParsing.decimalOrNull(ModelParsing.value(map, 'taxAmount')) ?? Decimal.zero,
      discountAmount: ModelParsing.decimalOrNull(ModelParsing.value(map, 'discountAmount')) ?? Decimal.zero,
      netAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'netAmount'), 'netAmount'),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      notes: ModelParsing.stringOrNull(ModelParsing.value(map, 'notes')) ?? '',
      createdByUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'createdByUserUuid')),
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
    return 'SupplierInvoice(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, storeUuid: $storeUuid, supplierUuid: $supplierUuid, purchaseOrderUuid: $purchaseOrderUuid, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, currencyCode: $currencyCode, totalAmount: $totalAmount, taxAmount: $taxAmount, discountAmount: $discountAmount, netAmount: $netAmount, status: $status, notes: $notes, createdByUserUuid: $createdByUserUuid, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
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
        other.invoiceNumber == invoiceNumber &&
        other.invoiceDate == invoiceDate &&
        other.dueDate == dueDate &&
        other.currencyCode == currencyCode &&
        other.totalAmount == totalAmount &&
        other.taxAmount == taxAmount &&
        other.discountAmount == discountAmount &&
        other.netAmount == netAmount &&
        other.status == status &&
        other.notes == notes &&
        other.createdByUserUuid == createdByUserUuid &&
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
        invoiceNumber.hashCode ^
        invoiceDate.hashCode ^
        dueDate.hashCode ^
        currencyCode.hashCode ^
        totalAmount.hashCode ^
        taxAmount.hashCode ^
        discountAmount.hashCode ^
        netAmount.hashCode ^
        status.hashCode ^
        notes.hashCode ^
        createdByUserUuid.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}
