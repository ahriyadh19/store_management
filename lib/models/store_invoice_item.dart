// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreInvoiceItem {
  int? id;
  String uuid;
  int invoiceId;
  String invoiceUuid;
  int companyProductId;
  String companyProductUuid;
  int productId;
  String productUuid;
  int quantity;
  Decimal unitPrice;
  Decimal discountAmount;
  Decimal taxAmount;
  Decimal lineTotal;
  RecordStatus status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreInvoiceItem({
    this.id,
    String? uuid,
    required this.invoiceId,
    required this.invoiceUuid,
    required this.companyProductId,
    required this.companyProductUuid,
    required this.productId,
    required this.productUuid,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.lineTotal,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreInvoiceItem copyWith({
    int? id,
    String? uuid,
    int? invoiceId,
    String? invoiceUuid,
    int? companyProductId,
    String? companyProductUuid,
    int? productId,
    String? productUuid,
    int? quantity,
    Decimal? unitPrice,
    Decimal? discountAmount,
    Decimal? taxAmount,
    Decimal? lineTotal,
    RecordStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreInvoiceItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      invoiceId: invoiceId ?? this.invoiceId,
      invoiceUuid: invoiceUuid ?? this.invoiceUuid,
      companyProductId: companyProductId ?? this.companyProductId,
      companyProductUuid: companyProductUuid ?? this.companyProductUuid,
      productId: productId ?? this.productId,
      productUuid: productUuid ?? this.productUuid,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      lineTotal: lineTotal ?? this.lineTotal,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'invoiceId': invoiceId,
      'invoiceUuid': invoiceUuid,
      'companyProductId': companyProductId,
      'companyProductUuid': companyProductUuid,
      'productId': productId,
      'productUuid': productUuid,
      'quantity': quantity,
      'unitPrice': unitPrice.toString(),
      'discountAmount': discountAmount.toString(),
      'taxAmount': taxAmount.toString(),
      'lineTotal': lineTotal.toString(),
      'status': status.code,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreInvoiceItem.fromMap(Map<String, dynamic> map) {
    return StoreInvoiceItem(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      invoiceId: ModelParsing.intOrThrow(map['invoiceId'], 'invoiceId'),
      invoiceUuid: map['invoiceUuid'] as String,
      companyProductId: ModelParsing.intOrThrow(map['companyProductId'], 'companyProductId'),
      companyProductUuid: map['companyProductUuid'] as String,
      productId: ModelParsing.intOrThrow(map['productId'], 'productId'),
      productUuid: map['productUuid'] as String,
      quantity: ModelParsing.intOrThrow(map['quantity'], 'quantity'),
      unitPrice: ModelParsing.decimalOrThrow(map['unitPrice'], 'unitPrice'),
      discountAmount: ModelParsing.decimalOrThrow(map['discountAmount'], 'discountAmount'),
      taxAmount: ModelParsing.decimalOrThrow(map['taxAmount'], 'taxAmount'),
      lineTotal: ModelParsing.decimalOrThrow(map['lineTotal'], 'lineTotal'),
      status: ModelParsing.recordStatusFromCode(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInvoiceItem.fromJson(String source) => StoreInvoiceItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreInvoiceItem(id: $id, uuid: $uuid, invoiceId: $invoiceId, invoiceUuid: $invoiceUuid, companyProductId: $companyProductId, companyProductUuid: $companyProductUuid, productId: $productId, productUuid: $productUuid, quantity: $quantity, unitPrice: $unitPrice, discountAmount: $discountAmount, taxAmount: $taxAmount, lineTotal: $lineTotal, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreInvoiceItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.invoiceId == invoiceId &&
        other.invoiceUuid == invoiceUuid &&
        other.companyProductId == companyProductId &&
        other.companyProductUuid == companyProductUuid &&
        other.productId == productId &&
        other.productUuid == productUuid &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.discountAmount == discountAmount &&
        other.taxAmount == taxAmount &&
        other.lineTotal == lineTotal &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        invoiceId.hashCode ^
        invoiceUuid.hashCode ^
        companyProductId.hashCode ^
        companyProductUuid.hashCode ^
        productId.hashCode ^
        productUuid.hashCode ^
        quantity.hashCode ^
        unitPrice.hashCode ^
        discountAmount.hashCode ^
        taxAmount.hashCode ^
        lineTotal.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}