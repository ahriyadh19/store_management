// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class StoreInvoiceItem {
  @Id()
  int id = 0;
  String uuid;
  String invoiceUuid;
  String companyProductUuid;
  String productUuid;
  int quantity;
  Decimal unitPrice;
  Decimal discountAmount;
  Decimal taxAmount;
  Decimal lineTotal;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  StoreInvoiceItem({
    this.id = 0,
    String? uuid,
    required this.invoiceUuid,
    required this.companyProductUuid,
    required this.productUuid,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.lineTotal,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreInvoiceItem copyWith({
    int? id,
    String? uuid,
    String? invoiceUuid,
    String? companyProductUuid,
    String? productUuid,
    int? quantity,
    Decimal? unitPrice,
    Decimal? discountAmount,
    Decimal? taxAmount,
    Decimal? lineTotal,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return StoreInvoiceItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      invoiceUuid: invoiceUuid ?? this.invoiceUuid,
      companyProductUuid: companyProductUuid ?? this.companyProductUuid,
      productUuid: productUuid ?? this.productUuid,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      lineTotal: lineTotal ?? this.lineTotal,
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
      'invoiceUuid': invoiceUuid,
      'companyProductUuid': companyProductUuid,
      'productUuid': productUuid,
      'quantity': quantity,
      'unitPrice': unitPrice.toString(),
      'discountAmount': discountAmount.toString(),
      'taxAmount': taxAmount.toString(),
      'lineTotal': lineTotal.toString(),
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory StoreInvoiceItem.fromMap(Map<String, dynamic> map) {
    return StoreInvoiceItem(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      invoiceUuid: ModelParsing.stringOrThrow(map['invoiceUuid'], 'invoiceUuid'),
      companyProductUuid: ModelParsing.stringOrThrow(map['companyProductUuid'], 'companyProductUuid'),
      productUuid: ModelParsing.stringOrThrow(map['productUuid'], 'productUuid'),
      quantity: ModelParsing.intOrThrow(map['quantity'], 'quantity'),
      unitPrice: ModelParsing.decimalOrThrow(map['unitPrice'], 'unitPrice'),
      discountAmount: ModelParsing.decimalOrThrow(map['discountAmount'], 'discountAmount'),
      taxAmount: ModelParsing.decimalOrThrow(map['taxAmount'], 'taxAmount'),
      lineTotal: ModelParsing.decimalOrThrow(map['lineTotal'], 'lineTotal'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'] ?? map['created_at'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'] ?? map['updated_at'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInvoiceItem.fromJson(String source) => StoreInvoiceItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreInvoiceItem(id: $id, uuid: $uuid, invoiceUuid: $invoiceUuid, companyProductUuid: $companyProductUuid, productUuid: $productUuid, quantity: $quantity, unitPrice: $unitPrice, discountAmount: $discountAmount, taxAmount: $taxAmount, lineTotal: $lineTotal, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant StoreInvoiceItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.invoiceUuid == invoiceUuid &&
        other.companyProductUuid == companyProductUuid &&
        other.productUuid == productUuid &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.discountAmount == discountAmount &&
        other.taxAmount == taxAmount &&
        other.lineTotal == lineTotal &&
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
        invoiceUuid.hashCode ^
        companyProductUuid.hashCode ^
        productUuid.hashCode ^
        quantity.hashCode ^
        unitPrice.hashCode ^
        discountAmount.hashCode ^
        taxAmount.hashCode ^
        lineTotal.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}