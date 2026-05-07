// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class InventoryTransaction {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String productUuid;
  String? batchUuid;
  String holderType;
  String holderUuid;
  String transactionType;
  int quantity;
  Decimal? unitCost;
  Decimal? unitPrice;
  String referenceType;
  String? referenceUuid;
  String? linkedTransactionUuid;
  String? staffUserUuid;
  DateTime occurredAt;
  String note;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  InventoryTransaction({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    required this.productUuid,
    this.batchUuid,
    required this.holderType,
    required this.holderUuid,
    required this.transactionType,
    required this.quantity,
    this.unitCost,
    this.unitPrice,
    required this.referenceType,
    this.referenceUuid,
    this.linkedTransactionUuid,
    this.staffUserUuid,
    required this.occurredAt,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'ownerUuid': ownerUuid,
      'productUuid': productUuid,
      'batchUuid': batchUuid,
      'holderType': holderType,
      'holderUuid': holderUuid,
      'transactionType': transactionType,
      'quantity': quantity,
      'unitCost': unitCost?.toString(),
      'unitPrice': unitPrice?.toString(),
      'referenceType': referenceType,
      'referenceUuid': referenceUuid,
      'linkedTransactionUuid': linkedTransactionUuid,
      'staffUserUuid': staffUserUuid,
      'occurredAt': occurredAt.millisecondsSinceEpoch,
      'note': note,
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
      'product_uuid': productUuid,
      'batch_uuid': batchUuid,
      'holder_type': holderType,
      'holder_uuid': holderUuid,
      'transaction_type': transactionType,
      'quantity': quantity,
      'unit_cost': unitCost?.toString(),
      'unit_price': unitPrice?.toString(),
      'reference_type': referenceType,
      'reference_uuid': referenceUuid,
      'linked_transaction_uuid': linkedTransactionUuid,
      'staff_user_uuid': staffUserUuid,
      'occurred_at': ModelParsing.dateTimeToIso8601Utc(occurredAt),
      'note': note,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory InventoryTransaction.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return InventoryTransaction(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      batchUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'batchUuid')),
      holderType: ModelParsing.stringOrThrow(ModelParsing.value(map, 'holderType'), 'holderType'),
      holderUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'holderUuid'), 'holderUuid'),
      transactionType: ModelParsing.stringOrThrow(ModelParsing.value(map, 'transactionType'), 'transactionType'),
      quantity: ModelParsing.intOrThrow(ModelParsing.value(map, 'quantity'), 'quantity'),
      unitCost: ModelParsing.decimalOrNull(ModelParsing.value(map, 'unitCost')),
      unitPrice: ModelParsing.decimalOrNull(ModelParsing.value(map, 'unitPrice')),
      referenceType: ModelParsing.stringOrThrow(ModelParsing.value(map, 'referenceType'), 'referenceType'),
      referenceUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'referenceUuid')),
      linkedTransactionUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'linkedTransactionUuid')),
      staffUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'staffUserUuid')),
      occurredAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'occurredAt'), 'occurredAt'),
      note: ModelParsing.stringOrNull(ModelParsing.value(map, 'note')) ?? '',
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryTransaction.fromJson(String source) => InventoryTransaction.fromMap(json.decode(source) as Map<String, dynamic>);
}
