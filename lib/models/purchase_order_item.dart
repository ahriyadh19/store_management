// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class PurchaseOrderItem {
  @Id()
  int id = 0;
  String uuid;
  String purchaseOrderUuid;
  String productUuid;
  String? supplierProductOfferUuid;
  int quantity;
  Decimal unitCost;
  Decimal discountAmount;
  Decimal lineTotal;
  int receivedQuantity;

  PurchaseOrderItem({
    this.id = 0,
    String? uuid,
    required this.purchaseOrderUuid,
    required this.productUuid,
    this.supplierProductOfferUuid,
    required this.quantity,
    required this.unitCost,
    required this.discountAmount,
    required this.lineTotal,
    this.receivedQuantity = 0,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  PurchaseOrderItem copyWith({
    int? id,
    String? uuid,
    String? purchaseOrderUuid,
    String? productUuid,
    String? supplierProductOfferUuid,
    int? quantity,
    Decimal? unitCost,
    Decimal? discountAmount,
    Decimal? lineTotal,
    int? receivedQuantity,
  }) {
    return PurchaseOrderItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      purchaseOrderUuid: purchaseOrderUuid ?? this.purchaseOrderUuid,
      productUuid: productUuid ?? this.productUuid,
      supplierProductOfferUuid: supplierProductOfferUuid ?? this.supplierProductOfferUuid,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      discountAmount: discountAmount ?? this.discountAmount,
      lineTotal: lineTotal ?? this.lineTotal,
      receivedQuantity: receivedQuantity ?? this.receivedQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'purchaseOrderUuid': purchaseOrderUuid,
      'productUuid': productUuid,
      'supplierProductOfferUuid': supplierProductOfferUuid,
      'quantity': quantity,
      'unitCost': unitCost.toString(),
      'discountAmount': discountAmount.toString(),
      'lineTotal': lineTotal.toString(),
      'receivedQuantity': receivedQuantity,
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'purchase_order_uuid': purchaseOrderUuid,
      'product_uuid': productUuid,
      'supplier_product_offer_uuid': supplierProductOfferUuid,
      'quantity': quantity,
      'unit_cost': unitCost.toString(),
      'discount_amount': discountAmount.toString(),
      'line_total': lineTotal.toString(),
      'received_quantity': receivedQuantity,
    };
  }

  factory PurchaseOrderItem.fromMap(Map<String, dynamic> map) {
    return PurchaseOrderItem(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      purchaseOrderUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'purchaseOrderUuid'), 'purchaseOrderUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      supplierProductOfferUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'supplierProductOfferUuid')),
      quantity: ModelParsing.intOrThrow(ModelParsing.value(map, 'quantity'), 'quantity'),
      unitCost: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'unitCost'), 'unitCost'),
      discountAmount: ModelParsing.decimalOrNull(ModelParsing.value(map, 'discountAmount')) ?? Decimal.zero,
      lineTotal: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'lineTotal'), 'lineTotal'),
      receivedQuantity: ModelParsing.intOrNull(ModelParsing.value(map, 'receivedQuantity')) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseOrderItem.fromJson(String source) => PurchaseOrderItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PurchaseOrderItem(id: $id, uuid: $uuid, purchaseOrderUuid: $purchaseOrderUuid, productUuid: $productUuid, supplierProductOfferUuid: $supplierProductOfferUuid, quantity: $quantity, unitCost: $unitCost, discountAmount: $discountAmount, lineTotal: $lineTotal, receivedQuantity: $receivedQuantity)';
  }

  @override
  bool operator ==(covariant PurchaseOrderItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.purchaseOrderUuid == purchaseOrderUuid &&
        other.productUuid == productUuid &&
        other.supplierProductOfferUuid == supplierProductOfferUuid &&
        other.quantity == quantity &&
        other.unitCost == unitCost &&
        other.discountAmount == discountAmount &&
        other.lineTotal == lineTotal &&
        other.receivedQuantity == receivedQuantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        purchaseOrderUuid.hashCode ^
        productUuid.hashCode ^
        supplierProductOfferUuid.hashCode ^
        quantity.hashCode ^
        unitCost.hashCode ^
        discountAmount.hashCode ^
        lineTotal.hashCode ^
        receivedQuantity.hashCode;
  }
}
