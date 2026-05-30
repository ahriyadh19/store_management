// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class StoreInvoiceItem extends AuditedSyncModel {
  String invoiceUuid;
  String supplierProductUuid;
  String productUuid;
  int quantity;
  Decimal unitPrice;
  Decimal discountAmount;
  Decimal taxAmount;
  Decimal lineTotal;

  StoreInvoiceItem({
    super.id = 0,
    super.uuid,
    required this.invoiceUuid,
    required this.supplierProductUuid,
    required this.productUuid,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.lineTotal,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  StoreInvoiceItem copyWith({
    int? id,
    String? uuid,
    String? invoiceUuid,
    String? supplierProductUuid,
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
      supplierProductUuid: supplierProductUuid ?? this.supplierProductUuid,
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
      'invoiceUuid': invoiceUuid,
      'supplierProductUuid': supplierProductUuid,
      'productUuid': productUuid,
      'quantity': quantity,
      'unitPrice': unitPrice.toString(),
      'discountAmount': discountAmount.toString(),
      'taxAmount': taxAmount.toString(),
      'lineTotal': lineTotal.toString(),
      ...auditedSyncMap(),
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'invoice_uuid': invoiceUuid,
      'supplier_product_uuid': supplierProductUuid,
      'product_uuid': productUuid,
      'quantity': quantity,
      'unit_price': unitPrice.toString(),
      'discount_amount': discountAmount.toString(),
      'tax_amount': taxAmount.toString(),
      'line_total': lineTotal.toString(),
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory StoreInvoiceItem.fromMap(Map<String, dynamic> map) {
    return StoreInvoiceItem(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      invoiceUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'invoiceUuid'), 'invoiceUuid'),
      supplierProductUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'supplierProductUuid'), 'supplierProductUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      quantity: ModelParsing.intOrThrow(ModelParsing.value(map, 'quantity'), 'quantity'),
      unitPrice: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'unitPrice'), 'unitPrice'),
      discountAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'discountAmount'), 'discountAmount'),
      taxAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'taxAmount'), 'taxAmount'),
      lineTotal: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'lineTotal'), 'lineTotal'),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInvoiceItem.fromJson(String source) => StoreInvoiceItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreInvoiceItem(id: $id, uuid: $uuid, invoiceUuid: $invoiceUuid, supplierProductUuid: $supplierProductUuid, productUuid: $productUuid, quantity: $quantity, unitPrice: $unitPrice, discountAmount: $discountAmount, taxAmount: $taxAmount, lineTotal: $lineTotal, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, invoiceUuid, supplierProductUuid, productUuid, quantity, unitPrice, discountAmount, taxAmount, lineTotal];
}
