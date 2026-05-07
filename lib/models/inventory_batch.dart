// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class InventoryBatch {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String storeUuid;
  String? supplierUuid;
  String productUuid;
  String? supplierInvoiceUuid;
  String? supplierInvoiceItemRef;
  String? batchNumber;
  DateTime receivedAt;
  DateTime? expiryDate;
  Decimal unitCost;
  int initialQuantity;
  int remainingQuantity;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  InventoryBatch({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    required this.storeUuid,
    this.supplierUuid,
    required this.productUuid,
    this.supplierInvoiceUuid,
    this.supplierInvoiceItemRef,
    this.batchNumber,
    required this.receivedAt,
    this.expiryDate,
    required this.unitCost,
    required this.initialQuantity,
    required this.remainingQuantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  InventoryBatch copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? storeUuid,
    String? supplierUuid,
    String? productUuid,
    String? supplierInvoiceUuid,
    String? supplierInvoiceItemRef,
    String? batchNumber,
    DateTime? receivedAt,
    DateTime? expiryDate,
    Decimal? unitCost,
    int? initialQuantity,
    int? remainingQuantity,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return InventoryBatch(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      storeUuid: storeUuid ?? this.storeUuid,
      supplierUuid: supplierUuid ?? this.supplierUuid,
      productUuid: productUuid ?? this.productUuid,
      supplierInvoiceUuid: supplierInvoiceUuid ?? this.supplierInvoiceUuid,
      supplierInvoiceItemRef: supplierInvoiceItemRef ?? this.supplierInvoiceItemRef,
      batchNumber: batchNumber ?? this.batchNumber,
      receivedAt: receivedAt ?? this.receivedAt,
      expiryDate: expiryDate ?? this.expiryDate,
      unitCost: unitCost ?? this.unitCost,
      initialQuantity: initialQuantity ?? this.initialQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
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
      'productUuid': productUuid,
      'supplierInvoiceUuid': supplierInvoiceUuid,
      'supplierInvoiceItemRef': supplierInvoiceItemRef,
      'batchNumber': batchNumber,
      'receivedAt': receivedAt.millisecondsSinceEpoch,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'unitCost': unitCost.toString(),
      'initialQuantity': initialQuantity,
      'remainingQuantity': remainingQuantity,
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
      'product_uuid': productUuid,
      'supplier_invoice_uuid': supplierInvoiceUuid,
      'supplier_invoice_item_ref': supplierInvoiceItemRef,
      'batch_number': batchNumber,
      'received_at': ModelParsing.dateTimeToIso8601Utc(receivedAt),
      'expiry_date': ModelParsing.dateTimeOrNullToIso8601Utc(expiryDate),
      'unit_cost': unitCost.toString(),
      'initial_quantity': initialQuantity,
      'remaining_quantity': remainingQuantity,
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory InventoryBatch.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return InventoryBatch(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      supplierUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'supplierUuid')),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      supplierInvoiceUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'supplierInvoiceUuid')),
      supplierInvoiceItemRef: ModelParsing.stringOrNull(ModelParsing.value(map, 'supplierInvoiceItemRef')),
      batchNumber: ModelParsing.stringOrNull(ModelParsing.value(map, 'batchNumber')),
      receivedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'receivedAt'), 'receivedAt'),
      expiryDate: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'expiryDate')),
      unitCost: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'unitCost'), 'unitCost'),
      initialQuantity: ModelParsing.intOrThrow(ModelParsing.value(map, 'initialQuantity'), 'initialQuantity'),
      remainingQuantity: ModelParsing.intOrThrow(ModelParsing.value(map, 'remainingQuantity'), 'remainingQuantity'),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryBatch.fromJson(String source) => InventoryBatch.fromMap(json.decode(source) as Map<String, dynamic>);
}
