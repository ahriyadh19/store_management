// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class StoreReturnItem extends AuditedSyncModel {
  static const Object _unset = Object();

  String returnUuid;
  String? invoiceItemUuid;
  String supplierProductUuid;
  String productUuid;
  int quantity;
  Decimal unitPrice;
  Decimal lineTotal;
  String reason;

  StoreReturnItem({
    super.id = 0,
    super.uuid,
    required this.returnUuid,
    this.invoiceItemUuid,
    required this.supplierProductUuid,
    required this.productUuid,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.reason,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  StoreReturnItem copyWith({
    int? id,
    String? uuid,
    String? returnUuid,
    Object? invoiceItemUuid = _unset,
    String? supplierProductUuid,
    String? productUuid,
    int? quantity,
    Decimal? unitPrice,
    Decimal? lineTotal,
    String? reason,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return StoreReturnItem(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      returnUuid: returnUuid ?? this.returnUuid,
      invoiceItemUuid: identical(invoiceItemUuid, _unset)
          ? this.invoiceItemUuid
          : invoiceItemUuid as String?,
      supplierProductUuid: supplierProductUuid ?? this.supplierProductUuid,
      productUuid: productUuid ?? this.productUuid,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      reason: reason ?? this.reason,
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
      'returnUuid': returnUuid,
      'invoiceItemUuid': invoiceItemUuid,
      'supplierProductUuid': supplierProductUuid,
      'productUuid': productUuid,
      'quantity': quantity,
      'unitPrice': unitPrice.toString(),
      'lineTotal': lineTotal.toString(),
      'reason': reason,
      ...auditedSyncMap(),
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'return_uuid': returnUuid,
      'invoice_item_uuid': invoiceItemUuid,
      'supplier_product_uuid': supplierProductUuid,
      'product_uuid': productUuid,
      'quantity': quantity,
      'unit_price': unitPrice.toString(),
      'line_total': lineTotal.toString(),
      'reason': reason,
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory StoreReturnItem.fromMap(Map<String, dynamic> map) {
    return StoreReturnItem(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      returnUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'returnUuid'),
        'returnUuid',
      ),
      invoiceItemUuid: ModelParsing.stringOrNull(
        ModelParsing.value(map, 'invoiceItemUuid'),
      ),
      supplierProductUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'supplierProductUuid'),
        'supplierProductUuid',
      ),
      productUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'productUuid'),
        'productUuid',
      ),
      quantity: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'quantity'),
        'quantity',
      ),
      unitPrice: ModelParsing.decimalOrThrow(
        ModelParsing.value(map, 'unitPrice'),
        'unitPrice',
      ),
      lineTotal: ModelParsing.decimalOrThrow(
        ModelParsing.value(map, 'lineTotal'),
        'lineTotal',
      ),
      reason: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'reason'),
        'reason',
      ),
      status: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'status'),
        'status',
      ),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'createdAt'),
        'createdAt',
      ),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'updatedAt'),
        'updatedAt',
      ),
      synced:
          ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'deletedAt'),
      ),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'syncedAt'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreReturnItem.fromJson(String source) =>
      StoreReturnItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreReturnItem(id: $id, uuid: $uuid, returnUuid: $returnUuid, invoiceItemUuid: $invoiceItemUuid, supplierProductUuid: $supplierProductUuid, productUuid: $productUuid, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, reason: $reason, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    returnUuid,
    invoiceItemUuid,
    supplierProductUuid,
    productUuid,
    quantity,
    unitPrice,
    lineTotal,
    reason,
  ];
}
