// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreReturnItem {
  int? id;
  String uuid;
  int returnId;
  String returnUuid;
  int? invoiceItemId;
  String? invoiceItemUuid;
  int companyProductId;
  String companyProductUuid;
  int productId;
  String productUuid;
  int quantity;
  Decimal unitPrice;
  Decimal lineTotal;
  String reason;
  RecordStatus status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreReturnItem({
    this.id,
    String? uuid,
    required this.returnId,
    required this.returnUuid,
    this.invoiceItemId,
    this.invoiceItemUuid,
    required this.companyProductId,
    required this.companyProductUuid,
    required this.productId,
    required this.productUuid,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreReturnItem copyWith({
    int? id,
    String? uuid,
    int? returnId,
    String? returnUuid,
    int? invoiceItemId,
    String? invoiceItemUuid,
    int? companyProductId,
    String? companyProductUuid,
    int? productId,
    String? productUuid,
    int? quantity,
    Decimal? unitPrice,
    Decimal? lineTotal,
    String? reason,
    RecordStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreReturnItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      returnId: returnId ?? this.returnId,
      returnUuid: returnUuid ?? this.returnUuid,
      invoiceItemId: invoiceItemId ?? this.invoiceItemId,
      invoiceItemUuid: invoiceItemUuid ?? this.invoiceItemUuid,
      companyProductId: companyProductId ?? this.companyProductId,
      companyProductUuid: companyProductUuid ?? this.companyProductUuid,
      productId: productId ?? this.productId,
      productUuid: productUuid ?? this.productUuid,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'returnId': returnId,
      'returnUuid': returnUuid,
      'invoiceItemId': invoiceItemId,
      'invoiceItemUuid': invoiceItemUuid,
      'companyProductId': companyProductId,
      'companyProductUuid': companyProductUuid,
      'productId': productId,
      'productUuid': productUuid,
      'quantity': quantity,
      'unitPrice': unitPrice.toString(),
      'lineTotal': lineTotal.toString(),
      'reason': reason,
      'status': status.code,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreReturnItem.fromMap(Map<String, dynamic> map) {
    return StoreReturnItem(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      returnId: ModelParsing.intOrThrow(map['returnId'], 'returnId'),
      returnUuid: map['returnUuid'] as String,
      invoiceItemId: ModelParsing.intOrNull(map['invoiceItemId']),
      invoiceItemUuid: map['invoiceItemUuid'] as String?,
      companyProductId: ModelParsing.intOrThrow(map['companyProductId'], 'companyProductId'),
      companyProductUuid: map['companyProductUuid'] as String,
      productId: ModelParsing.intOrThrow(map['productId'], 'productId'),
      productUuid: map['productUuid'] as String,
      quantity: ModelParsing.intOrThrow(map['quantity'], 'quantity'),
      unitPrice: ModelParsing.decimalOrThrow(map['unitPrice'], 'unitPrice'),
      lineTotal: ModelParsing.decimalOrThrow(map['lineTotal'], 'lineTotal'),
      reason: map['reason'] as String,
      status: ModelParsing.recordStatusFromCode(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreReturnItem.fromJson(String source) => StoreReturnItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreReturnItem(id: $id, uuid: $uuid, returnId: $returnId, returnUuid: $returnUuid, invoiceItemId: $invoiceItemId, invoiceItemUuid: $invoiceItemUuid, companyProductId: $companyProductId, companyProductUuid: $companyProductUuid, productId: $productId, productUuid: $productUuid, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, reason: $reason, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreReturnItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.returnId == returnId &&
        other.returnUuid == returnUuid &&
        other.invoiceItemId == invoiceItemId &&
        other.invoiceItemUuid == invoiceItemUuid &&
        other.companyProductId == companyProductId &&
        other.companyProductUuid == companyProductUuid &&
        other.productId == productId &&
        other.productUuid == productUuid &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.lineTotal == lineTotal &&
        other.reason == reason &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        returnId.hashCode ^
        returnUuid.hashCode ^
        invoiceItemId.hashCode ^
        invoiceItemUuid.hashCode ^
        companyProductId.hashCode ^
        companyProductUuid.hashCode ^
        productId.hashCode ^
        productUuid.hashCode ^
        quantity.hashCode ^
        unitPrice.hashCode ^
        lineTotal.hashCode ^
        reason.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}