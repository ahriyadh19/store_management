// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class BranchPrice {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String branchUuid;
  String productUuid;
  String priceType;
  Decimal price;
  DateTime? startsAt;
  DateTime? endsAt;
  int priority;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  BranchPrice({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    required this.branchUuid,
    required this.productUuid,
    required this.priceType,
    required this.price,
    this.startsAt,
    this.endsAt,
    this.priority = 0,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'uuid': uuid,
    'ownerUuid': ownerUuid,
    'branchUuid': branchUuid,
    'productUuid': productUuid,
    'priceType': priceType,
    'price': price.toString(),
    'startsAt': startsAt?.millisecondsSinceEpoch,
    'endsAt': endsAt?.millisecondsSinceEpoch,
    'priority': priority,
    'status': status,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'synced': synced,
    'deletedAt': deletedAt?.millisecondsSinceEpoch,
    'syncedAt': syncedAt?.millisecondsSinceEpoch,
  };

  factory BranchPrice.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return BranchPrice(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      branchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'branchUuid'), 'branchUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      priceType: ModelParsing.stringOrThrow(ModelParsing.value(map, 'priceType'), 'priceType'),
      price: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'price'), 'price'),
      startsAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'startsAt')),
      endsAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'endsAt')),
      priority: ModelParsing.intOrNull(ModelParsing.value(map, 'priority')) ?? 0,
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());
  factory BranchPrice.fromJson(String source) => BranchPrice.fromMap(json.decode(source) as Map<String, dynamic>);
}
